<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>About Our Team | Fresco Fine Dining</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Great+Vibes&family=Merriweather:ital,wght@0,400;0,700;1,400&family=Poppins:wght@300;500;700&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>

    <style>
        /* === Professional Theme Colors === */
        :root {
            --bg-dark: #0a0a0a;
            --accent-orange: #f7941d;
            --text-gray: #e0dcc9;
        }

        body {
            background-color: var(--bg-dark);
            background-image: linear-gradient(rgba(0,0,0,0.9), rgba(0,0,0,0.9)), url('menu.jpg');
            background-attachment: fixed;
            background-size: cover;
            color: white;
            font-family: 'Merriweather', serif;
            margin: 0;
            overflow-x: hidden;
        }

        /* === Professional Glassmorphism Navbar === */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: rgba(0, 0, 0, 0.85);
            padding: 10px 60px;
            position: fixed;
            top: 0; width: 100%; z-index: 1000;
            backdrop-filter: blur(10px);
            border-bottom: 1px solid rgba(247, 148, 29, 0.3);
        }

        .logo img { height: 60px; transition: transform 0.3s; }
        .logo img:hover { transform: scale(1.05); }

        .nav-links { display: flex; gap: 30px; list-style: none; }
        .nav-links li a {
            color: #ffffff;
            text-decoration: none;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 1.5px;
            transition: 0.3s;
            padding: 8px 0;
            border-bottom: 2px solid transparent;
        }
        .nav-links li a:hover, .nav-links li a.active {
            color: var(--accent-orange);
            border-bottom: 2px solid var(--accent-orange);
        }

        /* === Professional Content Container === */
        main.container {
            background-color: rgba(255, 255, 255, 0.98);
            color: #222;
            margin: 140px auto 60px auto;
            width: 90%;
            max-width: 1150px;
            padding: 5rem 3rem;
            border-radius: 20px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }

        .chef-section {
            display: flex;
            flex-wrap: wrap;
            gap: 5rem;
            align-items: center;
            margin-bottom: 6rem;
            padding-bottom: 4rem;
            border-bottom: 1px solid #ddd;
        }
        .chef-section:last-child { border-bottom: none; margin-bottom: 0; }

        .details h1 { 
            font-family: 'Poppins', sans-serif;
            font-size: 2.8rem; 
            font-weight: 800; 
            color: #111; 
            margin-bottom: 0.5rem; 
        }
        .chef-name { 
            font-family: 'Great Vibes', cursive;
            font-size: 2rem; 
            color: var(--accent-orange); 
            margin-bottom: 1.5rem; 
        }
        
        .about-text { color: #555; font-size: 1.1rem; line-height: 1.8; margin-bottom: 2rem; }

        /* === Skills Styling === */
        .skill-bar { margin-bottom: 1.5rem; }
        .skill-label { display: flex; justify-content: space-between; font-weight: 700; margin-bottom: 8px; color: #333; }
        .progress-bg { background: #eee; border-radius: 20px; height: 12px; overflow: hidden; }
        .progress-fill { 
            height: 100%; 
            background: linear-gradient(to right, #f7941d, #b56a24); 
            border-radius: 20px; 
            transition: width 2s ease-in-out;
        }

        /* === Professional Cards === */
        .stat-card { 
            background: #f9f9f9; 
            padding: 20px; 
            border-radius: 15px; 
            text-align: center; 
            transition: 0.3s;
            border: 1px solid #eee;
        }
        .stat-card:hover { transform: translateY(-10px); box-shadow: 0 10px 20px rgba(0,0,0,0.1); border-color: var(--accent-orange); }
        .stat-card .number { font-size: 2.2rem; font-weight: 800; color: var(--accent-orange); display: block; }

        /* === Chef Image Styling === */
        .image-area img {
            width: 100%;
            max-width: 420px;
            border-radius: 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
            border: 10px solid #fff;
            transition: 0.5s;
        }
        .image-area img:hover { transform: scale(1.03) rotate(1deg); }

        .footer { background: #000; border-top: 1px solid #222; }

        @media (max-width: 768px) {
            main.container { padding: 2rem 1rem; margin-top: 100px; }
            .chef-section { flex-direction: column; text-align: center; gap: 2rem; }
            .navbar { padding: 10px 20px; }
            .nav-links { display: none; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
    <div class="logo"><img src="download.png" alt="Fresco Logo" /></div>
    <ul class="nav-links">
        <li><a href="index.html">Home</a></li>
        <li><a href="menu.jsp">Menu</a></li>
        <li><a href="login.jsp">Team</a></li>
        <li><a href="reservation.jsp">Reservation</a></li>
        <li><a href="About.jsp" class="active">About Us</a></li>
        <li><a href="contect.jsp">Contact Us</a></li>
    </ul>
</nav>

    <main class="container">
        
        <div class="chef-section" data-aos="fade-up">
            <section class="details" data-aos="fade-right" data-aos-delay="200">
                <h1>Executive Chef</h1>
                <p class="chef-name">Mr. Sudais Mughal   &&   Mr. Shazab Ali</p>
                <p class="about-text">
                    With over 15 years of culinary expertise, Chef Sudais && Shazab brings a unique blend of traditional flavors and modern techniques to Fresco. His philosophy is simple: "Cooking is an art, but baking is a science."
                </p>

                <div class="skills">
                    <div class="skill-bar">
                        <div class="skill-label"><span>Meat & Grill Specialties</span><span>97%</span></div>
                        <div class="progress-bg"><div class="progress-fill" style="width: 97%;"></div></div>
                    </div>
                    <div class="skill-bar">
                        <div class="skill-label"><span>Continental Cuisine</span><span>90%</span></div>
                        <div class="progress-bg"><div class="progress-fill" style="width: 90%;"></div></div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4 mt-8">
                    <div class="stat-card"><span class="number">15+</span><span class="label">Years Exp</span></div>
                    <div class="stat-card"><span class="number">70+</span><span class="label">Awards</span></div>
                </div>
            </section>

            <section class="image-area" data-aos="zoom-in" data-aos-delay="400">
                <img src="b.jpg" alt="Chef Sudais Mughal" />
            </section>
        </div>

        <div class="chef-section" data-aos="fade-up">
            <section class="image-area order-2 md:order-1" data-aos="zoom-in" data-aos-delay="400">
                <img src="girl.avif" alt="Chef Zukhruf Mubeen Qazi" />
            </section>

            <section class="details order-1 md:order-2" data-aos="fade-left" data-aos-delay="200">
                <h1>Pastry Specialist</h1>
                <p class="chef-name">Miss. Zukhruf Mubeen Qazi   &&   Miss.Fajar Naeem</p>
                <p class="about-text">
                    Miss Zukhruf && Miss Fajar is the creative soul behind our dessert menu. Her passion for gourmet soups and delicate pastries ensures every meal at Fresco ends on a perfect note.
                </p>

                <div class="skills">
                    <div class="skill-bar">
                        <div class="skill-label"><span>Pastry & Desserts</span><span>95%</span></div>
                        <div class="progress-bg"><div class="progress-fill" style="width: 95%;"></div></div>
                    </div>
                    <div class="skill-bar">
                        <div class="skill-label"><span>Artistic Food Styling</span><span>88%</span></div>
                        <div class="progress-bg"><div class="progress-fill" style="width: 88%;"></div></div>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4 mt-8">
                    <div class="stat-card"><span class="number">12+</span><span class="label">Years Exp</span></div>
                    <div class="stat-card"><span class="number">100+</span><span class="label">Delicacies</span></div>
                </div>
            </section>
        </div>

    </main>

    <footer class="footer text-center p-12 text-gray-500">
        <p class="mb-2">📍 123 Gourmet Street, Food City | 📞 +1 234 567 890</p>
        &copy; 2025 Fresco Fine Dining Restaurant. All Rights Reserved.
    </footer>

    <script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
    <script>
        AOS.init({
            duration: 1000,
            once: true,
            offset: 200
        });
    </script>

</body>
</html>