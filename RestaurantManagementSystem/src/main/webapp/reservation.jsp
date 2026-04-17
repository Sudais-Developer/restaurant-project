<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.fresco.dao.StaffManager" %> 
<%@ page import="com.restaurant.model.Table" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reservation | Fresco Fine Dining</title>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    
    <style>
        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(rgba(0,0,0,0.75), rgba(0,0,0,0.75)), url('fire.jpg');
            background-size: cover; background-position: center; background-attachment: fixed;
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
        }

        .navbar {
            display: flex; justify-content: space-between; align-items: center;
            background-color: rgba(0, 0, 0, 0.95); padding: 15px 80px; 
            position: fixed; top: 0; width: 100%; z-index: 1000;
            border-bottom: 1px solid #f7941d; box-sizing: border-box;
        }

        .nav-links { list-style: none; display: flex; gap: 45px; margin: 0; padding: 0; }
        .nav-links a { text-decoration: none; color: #fff; font-weight: 600; font-size: 14px; text-transform: uppercase; letter-spacing: 2px; transition: 0.3s ease; }
        .nav-links a:hover { color: #f7941d; }

        .reservation-container {
            background-color: #1a1a1a; padding: 35px; width: 520px; 
            border: 1px solid #333; margin-top: 80px; box-shadow: 0 15px 35px rgba(0,0,0,0.6);
        }

        h1 { font-size: 2.4rem; text-align: center; margin: 0 0 8px 0; color: #fff; letter-spacing: 2px; text-transform: uppercase; }
        .subheading { text-align: center; font-size: 0.9rem; color: #888; margin-bottom: 25px; border-bottom: 1px solid #333; padding-bottom: 15px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        input, select, textarea { background-color: #222; border: 1px solid #444; color: #ddd; padding: 12px; font-size: 14px; outline: none; width: 100%; box-sizing: border-box; }
        input:focus, select:focus { border-color: #f7941d; }
        .full-width { grid-column: span 2; }
        textarea { height: 90px; resize: none; }

        button {
            width: 100%; background-color: #f7941d; border: none; color: #fff; padding: 14px; 
            font-size: 1.1rem; font-weight: bold; cursor: pointer; text-transform: uppercase;
            margin-top: 10px; transition: 0.3s; letter-spacing: 1px;
        }
        button:hover { background-color: #e8891a; transform: translateY(-2px); }

        @media (max-width: 850px) { .navbar { padding: 15px 30px; } .nav-links { gap: 20px; } }
        @media (max-width: 600px) { .nav-links { display: none; } .reservation-container { width: 90%; } .form-grid { grid-template-columns: 1fr; } .full-width { grid-column: span 1; } }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo"><img src="download.png" alt="Fresco Logo" style="height: 50px;"></div>
    <ul class="nav-links">
        <li><a href="index.html">Home</a></li>
        <li><a href="menu.jsp">Menu</a></li>
        <li><a href="login.jsp">Team</a></li>
        <li><a href="reservation.jsp" style="color:#f7941d;">Reservation</a></li>
        <li><a href="About.jsp">About Us</a></li>
        <li><a href="contect.jsp">Contact</a></li>
    </ul>
</nav>

<div class="reservation-container" data-aos="fade-up" data-aos-duration="700">
    <h1>RESERVATION</h1>
    <p class="subheading">Booking request <span style="color:#f7941d;">+92 3XX-XXXXXXX</span></p>
    
    <form class="form-grid" action="ReservationServlet" method="POST">
        <input type="text" name="name" placeholder="Full Name" required>
        <input type="tel" name="phone" id="phone_input" placeholder="+92 3XX-XXXXXXX" required maxlength="15">
        
        <select name="person" id="person_select" required>
            <option value="" disabled selected>Number of Persons</option>
            <option value="2">2 Persons</option>
            <option value="4">4 Persons</option>
            <option value="6">6 Persons</option>
            <option value="8">8 Persons</option>
            <option value="10">10 Persons</option>
            <option value="12">12 Persons</option>
        </select>
        <input type="date" name="date" id="date_input" required>

        <select name="time" id="time_select" required>
            <option value="" disabled selected>Select Time (2PM - 11PM)</option>
            <option value="02:00 PM">02:00 PM</option>
            <option value="03:00 PM">03:00 PM</option>
            <option value="04:00 PM">04:00 PM</option>
            <option value="05:00 PM">05:00 PM</option>
            <option value="06:00 PM">06:00 PM</option>
            <option value="07:00 PM">07:00 PM</option>
            <option value="08:00 PM">08:00 PM</option>
            <option value="09:00 PM">09:00 PM</option>
            <option value="10:00 PM">10:00 PM</option>
            <option value="11:00 PM">11:00 PM</option>
        </select>
        
        <select name="table" id="table_select" required>
            <option value="" disabled selected>Select Date & Time First</option>
        </select>

        <textarea name="comment" placeholder="Special Instructions..." class="full-width"></textarea>
        
        <div class="full-width">
            <button type="submit">Confirm Reservation</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {
        AOS.init();

        const tableInventory = [
            <% 
                List<Table> allTables = StaffManager.getTables();
                if (allTables != null) {
                    for(int i=0; i < allTables.size(); i++) {
                        Table t = allTables.get(i);
            %>
                { id: <%= t.getTableId() %>, name: '<%= t.getTableName().replace("'", "\\'") %>', cap: <%= t.getCapacity() %> }
                <%= (i < allTables.size() - 1) ? "," : "" %>
            <% 
                    }
                }
            %>
        ];

        let bookedSlots = JSON.parse(localStorage.getItem('fresco_bookings')) || [];

        function updateTableDropdown() {
            const persons = $('#person_select').val();
            const date = $('#date_input').val();
            const time = $('#time_select').val();
            const dropdown = $('#table_select');
            
            if (!persons || !date || !time) {
                dropdown.html('<option value="" disabled selected>Select Date & Time First</option>');
                return;
            }

            const pCount = parseInt(persons);
            let suitableTables = tableInventory.filter(t => t.cap >= pCount).sort((a, b) => a.cap - b.cap);

            let optionsHTML = ['<option value="" disabled selected>Choose Available Table</option>'];
            
            if(suitableTables.length === 0) {
                optionsHTML.push('<option value="" disabled>No tables found for ' + pCount + ' persons</option>');
            } else {
                suitableTables.forEach(t => {
                    const isOccupied = bookedSlots.some(slot => 
                        slot.date === date && slot.time === time && slot.tableId == t.id
                    );

                    if (isOccupied) {
                        optionsHTML.push('<option value="' + t.name + '" disabled style="color: #ff4d4d;">' + t.name + ' [OCCUPIED]</option>');
                    } else {
                        // FIXED: value mein t.id ki jagah t.name rakha hai taake Order.jsp mein name show ho
                        optionsHTML.push('<option value="' + t.name + '" data-cap="' + t.cap + '">' + t.name + ' (Cap: ' + t.cap + ') [AVAILABLE]</option>');
                    }
                });
            }
            dropdown.html(optionsHTML.join(''));
        }

        $('#table_select').on('change', function() {
            const selectedOption = $(this).find(':selected');
            const selectedTableCap = parseInt(selectedOption.data('cap'));
            const personCount = parseInt($('#person_select').val());
            const date = $('#date_input').val();
            const time = $('#time_select').val();

            const smallerTableAvailable = tableInventory.some(t => {
                const isOccupied = bookedSlots.some(slot => 
                    slot.date === date && slot.time === time && slot.tableId == t.id
                );
                return t.cap >= personCount && t.cap < selectedTableCap && !isOccupied;
            });

            if (smallerTableAvailable) {
                alert("Please select a smaller table. Larger tables are reserved for bigger groups.");
                $(this).val(""); 
            }
        });

        // --- NEW & STABLE PHONE LOGIC ---
        $('#phone_input').on('focus', function() {
            if (this.value === "") this.value = "+92 ";
        });

        $('#phone_input').on('input', function(e) {
            let prefix = "+92 ";
            let val = this.value;

            if (!val.startsWith(prefix)) {
                this.value = prefix;
                return;
            }

            let digits = val.substring(4).replace(/\D/g, '');
            digits = digits.substring(0, 10);

            let formatted = prefix;
            if (digits.length > 0) {
                if (digits.length <= 3) {
                    formatted += digits;
                } else {
                    formatted += digits.substring(0, 3) + "-" + digits.substring(3);
                }
            }
            this.value = formatted;
        });

        // --- SUBMIT VALIDATION ---
        $('form').on('submit', function(e) {
            const phoneVal = $('#phone_input').val();
            const nameVal = $('input[name="name"]').val().trim();
            
            const nameRegex = /^[a-zA-Z\s]+$/;
            if(!nameRegex.test(nameVal)) {
                alert("Name can only contain alphabets.");
                e.preventDefault();
                return false;
            }

            if (phoneVal.length < 15) {
                alert("Please enter a valid 11-digit phone number (+92 3XX-XXXXXXX).");
                e.preventDefault();
                return false;
            }

            // Booking record save karte waqt ID dhoondh kar store karte hain
            const tableName = $('#table_select').val();
            const tableObj = tableInventory.find(t => t.name === tableName);

            const newBooking = {
                date: $('#date_input').val(),
                time: $('#time_select').val(),
                tableId: tableObj ? tableObj.id : 0
            };
            
            bookedSlots.push(newBooking);
            localStorage.setItem('fresco_bookings', JSON.stringify(bookedSlots));
            
            $(this).find('button').prop('disabled', true).text('Booking...');
            alert("Reservation Success!");
        });

        $('#person_select, #date_input, #time_select').on('change', updateTableDropdown);
        $('#date_input').attr('min', new Date().toISOString().split('T')[0]);
    });
</script>
</body>
</html>