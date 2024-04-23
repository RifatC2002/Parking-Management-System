import mysql.connector
from flask import Flask, redirect, render_template, request, session, url_for
from mysql.connector import Error

app = Flask(__name__)
app.secret_key = 'NJFDNFDJFJDJFDJFNFNDJFNUJWHDIEFEJUNFUDJUEFJ'

db_config = {
    'host' : 'localhost', 
    'user' : 'root',
    'password' : '',
    'database' : 'parking_system',
    'port' : '3306'
}

def create_connection():
    return mysql.connector.connect(**db_config)

@app.route('/')
def index():
    return render_template('index.html')
  

@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        first_name = request.form['firstName']
        last_name = request.form['lastName']
        contact_no = request.form['contactNo']
        password = request.form['password']
        confirm_password = request.form['confirmPassword']
        emergency_contact = request.form['emergencyContact']
        national_id = request.form['nationalID']
        address_house = request.form['house']
        address_street = request.form['street']
        address_area = request.form['area']
        address_city = request.form['city']
        user_type = request.form['userType']

        if password != confirm_password:
            return render_template('register.html', error_message='Passwords do not match.')

        if len(password) < 7:
            return render_template('register.html', error_message='Password must be at least 7 characters.')

        query = """
            INSERT INTO User (
                FirstName, LastName, ContactNo, Password, EmergencyContact, NationalID,
                AddressHouse, AddressStreet, AddressArea, AddressCity, UserType
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        """
        params = (first_name, last_name, contact_no, password, emergency_contact, national_id,
                  address_house, address_street, address_area, address_city, user_type)
        
        db = create_connection()
        cursor = db.cursor()
        cursor.execute(query, params)
        db.commit()
        last_inserted_id = cursor.lastrowid
        cursor.close()
        db.close()

        return render_template('login.html', success_message='Welcome to the family. Here is your designated ID: ', last_inserted_id=last_inserted_id)

    return render_template('register.html')
  
@app.route('/about')
def about():
    return render_template('about.html')


@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        user_id = request.form['UserID']
        password = request.form['password']
        query = "SELECT * FROM User WHERE UserID = %s AND Password = %s"
        params = (user_id, password)
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(query, params)
        user = cursor.fetchone()
        
        cursor.close()

        session['user'] = user
        
        if user is not None:
            if user['UserType'] == 'Employee':
                return redirect(url_for('employee_homepage'))
            else:
                return redirect(url_for('homepage'))
        else:
            error_message = 'Invalid username or password'
            return render_template('login.html', error_message=error_message)
    else:
        pass
    return render_template('login.html')

@app.route('/logout')
def logout():
    session.pop('user', None)
    return redirect(url_for('index'))
  

@app.route('/employee_homepage')
def employee_homepage():
    return render_template('employee_homepage.html')

@app.route('/homepage')
def homepage():
    return render_template('homepage.html')

@app.route('/book_a_slot', methods=['GET', 'POST'])
def book_a_slot():
    if request.method == 'GET':
        query = """
            SELECT * FROM Slots WHERE Status = 'Available'
        """
        
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(query)
        slots = cursor.fetchall()
        cursor.close()
        db.close()
        
        return render_template('book_a_slot.html', slots=slots)
    
    if request.method == 'POST':

        user_id = session['user']['UserID']
        bookingDate = request.form['bookingDate']
        timeFrom = request.form['timeFrom']
        timeTo = request.form['timeTo']
        ownerName = request.form['ownerName']
        vehicleType = request.form['vehicleType']
        licensePlate = request.form['licensePlate']
        color = request.form['color']
        brand = request.form['brand']
        model = request.form['model']
        slot = request.form['slot']        
        

        query = """
                    INSERT INTO Booking (
                    UserID, BookingDate, TimeFrom, TimeTo, OwnerName, VehicleType, LicensePlate, Color, Brand, Model, SlotID, Status
                    )
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, 'Pending')
                """
        params = (user_id, bookingDate, timeFrom, timeTo, ownerName, vehicleType, licensePlate, color, brand, model, slot)
        
        slots_query = """
            UPDATE Slots SET Status = 'Occupied' WHERE SlotID = %s
        """
        slots_params = (slot,)
    
        
        db = create_connection()
        cursor = db.cursor()
        cursor.execute(query, params)
        db.commit()
        
        cursor.execute(slots_query, slots_params)
        db.commit()
        
        cursor.close()
        db.close()
        
        return redirect(url_for('homepage'))

    return render_template('book_a_slot.html')

@app.route('/cancel_booking', methods=['GET', 'POST'])
def cancel_booking():
    if request.method == 'POST':
        # Perform the cancellation logic here
        user_id = session['user']['UserID']
        
        # Query to get the last booking for the user
        last_booking_query = """
            SELECT BookingID, SlotID
            FROM Booking
            WHERE UserID = %s AND Status = 'Confirmed' OR Status = 'Pending'
            ORDER BY BookingID DESC
            LIMIT 1
        """
        
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(last_booking_query, (user_id,))
        last_booking = cursor.fetchone()
        
        if last_booking:
            # Update the Booking status to 'Cancelled'
            cancel_booking_query = """
                UPDATE Booking
                SET Status = 'Cancelled'
                WHERE BookingID = %s
            """
            cursor.execute(cancel_booking_query, (last_booking['BookingID'],))
            
            # Update the Slot status to 'Available'
            update_slot_query = """
                UPDATE Slots
                SET Status = 'Available'
                WHERE SlotID = %s
            """
            cursor.execute(update_slot_query, (last_booking['SlotID'],))
            
            db.commit()
            cursor.close()
            db.close()
            
            return redirect(url_for('homepage'))
        
        return redirect(url_for('homepage'))

    return render_template('homepage.html')



@app.route('/checkout', methods=['GET', 'POST'])
def checkout():
    bookings = []
    if request.method == 'POST':
        # Get the form data
        booking_id = request.form['bookingID']
        checkout_date = request.form['checkoutDate']
        extra_time = request.form['extraTime']
        damage_done = request.form['damageDone']
        type_of_damage = request.form['typeOfDamage']
        compensation_amount = float(request.form['compensationAmount'])
        final_payable_amount = float(request.form['finalPayableAmount'])
    
        # Update the Checkout table
        query = """
            INSERT INTO Checkout (BookingID, CheckoutDate, DamageDone, TypeOfDamage, CompensationAmount, ExtraTime, FinalPayableAmount)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        
        params = (booking_id, checkout_date, damage_done, type_of_damage, compensation_amount, extra_time, final_payable_amount)
        
        # Update the Earning table
        earning_query = """
            INSERT INTO Earning (CheckoutID, Amount)
            VALUES (LAST_INSERT_ID(), %s)
        """
        
        #Update the Booking table delete the booking
        booking_query = """
            UPDATE Booking SET Status = 'Completed' WHERE BookingID = %s
        """
        
        earning_params = (final_payable_amount,)
        
        #Update the Slots table to available
        slots_query = """
            UPDATE Slots SET Status = 'Available' WHERE (SELECT SlotID FROM Booking WHERE BookingID = %s)
        """
        
        slots_params = (booking_id,)
        
        
        db = create_connection()
        cursor = db.cursor()
        cursor.execute(query, params)
        db.commit()
        
        cursor.execute(earning_query, earning_params)
        db.commit()
        
        cursor.execute(slots_query, slots_params)
        db.commit()
        
        cursor.execute(booking_query, (booking_id,))
        db.commit()
        
        cursor.close()
        db.close()
        
    else:
        query = """
                    SELECT * FROM Booking WHERE Status = 'Confirmed'
                """
        
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(query)
        bookings = cursor.fetchall()
        cursor.close()
        db.close()
    
    return render_template('checkout.html', bookings=bookings)

@app.route('/pending_requests', methods=['GET', 'POST'])
def pending_requests():
    if request.method == 'GET':
        query = """
            SELECT * FROM Booking WHERE Status = 'Pending'
        """
        
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(query)
        bookings = cursor.fetchall()
        cursor.close()
        db.close()
    
        return render_template('pending_requests.html', bookings=bookings)
    elif request.method == 'POST':
        booking_id = request.form['bookingID']
        action = request.form['action']
        status = 'Confirmed' if action == 'approve' else 'Cancelled'
        
        query = """
            UPDATE Booking SET Status = %s WHERE BookingID = %s
        """
        
        db = create_connection()
        cursor = db.cursor()
        cursor.execute(query, (status, booking_id))
        db.commit()
        cursor.close()
        db.close()
        
        return redirect(url_for('pending_requests'))


@app.route('/earnings', methods=['GET', 'POST'])
def earnings():
    if request.method == 'GET':
        query = """
            SELECT User.FirstName, User.LastName, User.UserID, Earning.Amount, Earning.CheckoutID, Checkout.CheckoutDate FROM Earning, 
            Checkout, Booking, User WHERE Earning.CheckoutID = Checkout.CheckoutID AND Checkout.BookingID = Booking.BookingID 
            AND Booking.UserID = User.UserID
        """
        
        total_earnings_query = """
            SELECT SUM(Amount) AS TotalEarnings FROM Earning
        """
        
        db = create_connection()
        cursor = db.cursor(dictionary=True)
        cursor.execute(query)
        earnings = cursor.fetchall()
        
        total_earnings = cursor.execute(total_earnings_query)
        total_earnings = cursor.fetchone()
        
        cursor.close()
        db.close()
    
        return render_template('earnings.html', earnings=earnings, total_earnings=total_earnings)



if __name__ == '__main__':
    app.run(debug=True)