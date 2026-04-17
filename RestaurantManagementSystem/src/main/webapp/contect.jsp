<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us | Fresco Fine Dining</title>
    
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <style>
        body {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), url('fire.jpg');
            background-size: cover; background-position: center; background-attachment: fixed;
            min-height: 100vh; display: flex; justify-content: center; align-items: center;
            overflow-x: hidden;
        }

        /* --- Wide Spaced Professional Navbar --- */
        .navbar {
            display: flex; justify-content: space-between; align-items: center;
            background-color: rgba(0, 0, 0, 0.95); padding: 15px 80px;
            position: fixed; top: 0; width: 100%; z-index: 1000;
            border-bottom: 1px solid #f7941d; box-sizing: border-box;
        }

        .nav-links { list-style: none; display: flex; gap: 45px; margin: 0; padding: 0; }
        .nav-links a { 
            text-decoration: none; color: #fff; font-weight: 600; font-size: 14px; 
            text-transform: uppercase; letter-spacing: 2px; transition: 0.3s;
        }
        .nav-links a:hover, .nav-links a.active { color: #f7941d; }

        /* --- Main Compact Container --- */
        .contact-container {
            background-color: #1a1a1a;
            padding: 40px;
            width: 900px; /* Thoda wide rakha hai taake Info aur Form saath aa sakein */
            display: grid;
            grid-template-columns: 1fr 1.2fr; /* Info aur Form ka ratio */
            gap: 40px;
            border: 1px solid #333;
            margin-top: 100px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.7);
        }

        /* --- Left Side: Info Section --- */
        .info-panel { border-right: 1px solid #333; padding-right: 20px; }
        
        h1 {
            font-size: 2.5rem; margin: 0 0 10px 0;
            color: #fff; letter-spacing: 2px; text-transform: uppercase;
        }

        .info-panel h2 {
            color: #f7941d; font-size: 1.2rem; text-transform: uppercase;
            margin-top: 30px; margin-bottom: 10px; letter-spacing: 1px;
        }

        .info-panel p { color: #bbb; line-height: 1.6; font-size: 0.95rem; margin: 5px 0; }

        /* --- Right Side: Form Section (Compact Grid) --- */
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .full-width { grid-column: span 2; }

        input, textarea {
            background-color: #222; border: 1px solid #444;
            color: #ddd; padding: 12px; font-size: 14px;
            outline: none; width: 100%; box-sizing: border-box;
            border-radius: 0; /* Pure Square Look */
        }

        input:focus, textarea:focus { border-color: #f7941d; }

        textarea { height: 120px; resize: none; }

        .btn-send {
            width: 100%; background-color: #f7941d; border: none;
            color: #fff; padding: 15px; font-size: 1rem;
            font-weight: bold; cursor: pointer; text-transform: uppercase;
            letter-spacing: 2px; transition: 0.3s;
        }

        .btn-send:hover { background-color: #e8891a; transform: translateY(-3px); }

        /* Responsive */
        @media (max-width: 900px) {
            .contact-container { grid-template-columns: 1fr; width: 90%; }
            .info-panel { border-right: none; border-bottom: 1px solid #333; padding-bottom: 20px; }
            .navbar { padding: 15px 30px; }
            .nav-links { gap: 20px; }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo"><img src="download.png" style="height: 50px;"></div>
    <ul class="nav-links">
        <li><a href="index.html">Home</a></li>
        <li><a href="menu.jsp">Menu</a></li>
        <li><a href="login.jsp">Team</a></li>
        <li><a href="reservation.jsp">Reservation</a></li>
        <li><a href="About.jsp">About Us</a></li>
        <li><a href="contect.jsp" class="active">Contact</a></li>
    </ul>
</nav>

<div class="contact-container" data-aos="zoom-in" data-aos-duration="800">
    
    <div class="info-panel" data-aos="fade-right" data-aos-delay="200">
        <h1>GET IN TOUCH</h1>
        <p>Experience the finest fire-grilled dining in GIFT University.</p>

        <h2>Location</h2>
        <p>GIFT University<br>Gujranwala, Pakistan</p>

        <h2>Opening Hours</h2>
        <p>Mon - Thu: 02:00 PM - 11:00 PM</p>
        <p>Fri - Sun: 02:00 PM - 11:00 PM</p>

        <h2>Contact</h2>
        <p>Phone: +92 XX-XXXXXXXX</p>
        <p style="color: #f7941d; font-weight: bold;">sudaismughal@gmail.com</p>
    </div>

    <div data-aos="fade-left" data-aos-delay="400">
        <h2 style="color: #fff; margin-bottom: 20px; text-transform: uppercase; font-size: 1.2rem;">Send a Message</h2>
        <form class="form-grid" id="contactForm">
            <input type="text" id="name" placeholder="Name" required>
            <input type="email" id="email" placeholder="Email" required>
            <input type="text" id="subject" placeholder="Subject" class="full-width" required>
            <textarea id="message" placeholder="How can we help you?" class="full-width" required></textarea>
            
            <div class="full-width">
                <button type="submit" class="btn-send">Send via WhatsApp</button>
            </div>
        </form>
    </div>

</div>

<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    AOS.init({ once: true });

    document.getElementById("contactForm").addEventListener("submit", function(e) {
        e.preventDefault();

        // Data Retrieval (Simulating Object mapping)
        const formData = {
            name: document.getElementById("name").value,
            email: document.getElementById("email").value,
            subject: document.getElementById("subject").value,
            msg: document.getElementById("message").value
        };

        // WhatsApp Integration Logic
        let phoneNumber = "923001234567"; 
        let text = `*FRESCO CONTACT*%0A` +
                   `*From:* ${formData.name}%0A` +
                   `*Sub:* ${formData.subject}%0A` +
                   `*Message:* ${formData.msg}`;

        window.open(`https://wa.me/${phoneNumber}?text=${text}`, "_blank");
    });
</script>

</body>
</html>