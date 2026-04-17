<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Add Staff | Fresco Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #080808;
            color: white;
            display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0;
            background-image: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.9)), url('reservation.jpg');
            background-size: cover;
        }
        .form-card {
            background: rgba(20, 20, 20, 0.95);
            padding: 40px; border-radius: 20px;
            width: 100%; max-width: 450px;
            border: 1px solid rgba(247, 148, 29, 0.3);
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
        }
        .form-card h2 { color: #f7941d; text-align: center; margin-bottom: 30px; letter-spacing: 1px; }
        .input-group { position: relative; margin-bottom: 20px; }
        .input-group i { position: absolute; left: 15px; top: 15px; color: #f7941d; }
        .input-field {
            width: 100%; padding: 12px 12px 12px 45px;
            background: #1a1a1a; border: 1px solid #333;
            color: white; border-radius: 10px; box-sizing: border-box; outline: none;
        }
        .input-field:focus { border-color: #f7941d; }
        select.input-field { appearance: none; cursor: pointer; }
        .submit-btn {
            width: 100%; padding: 15px; background: #f7941d; border: none;
            color: black; font-weight: bold; border-radius: 10px;
            cursor: pointer; transition: 0.3s; text-transform: uppercase;
        }
        .submit-btn:hover { background: #fff; transform: translateY(-2px); }
        .back-link { display: block; text-align: center; margin-top: 20px; color: #888; text-decoration: none; font-size: 0.9rem; }
        .back-link:hover { color: #f7941d; }
    </style>
</head>
<body>

<div class="form-card">
    <h2><i class="fas fa-user-plus"></i> Add New Staff</h2>
    <form action="AddStaffServlet" method="POST">
        <div class="input-group">
            <i class="fas fa-user"></i>
            <input type="text" name="name" class="input-field" placeholder="Full Name" required />
        </div>
        
        <div class="input-group">
            <i class="fas fa-envelope"></i>
            <input type="email" name="email" class="input-field" placeholder="Email Address" required />
        </div>

        <div class="input-group">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" class="input-field" placeholder="System Password" required />
        </div>

        <div class="input-group">
            <i class="fas fa-user-tag"></i>
            <select name="role" class="input-field" required>
                <option value="" disabled selected>Assign Role</option>
                <option value="chef">Kitchen Staff (Chef)</option>
                <option value="waiter">Service Staff (Waiter)</option>
            </select>
        </div>

        <button type="submit" class="submit-btn">Register Staff Member</button>
        <a href="Admin.jsp" class="back-link">Cancel and Return</a>
    </form>
</div>

</body>
</html>