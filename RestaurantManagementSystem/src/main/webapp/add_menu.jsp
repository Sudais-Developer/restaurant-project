<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">

<style>
    :root {
        --gold: #e9a616;
        --glass: rgba(255, 255, 255, 0.05);
        --border: rgba(233, 166, 22, 0.3);
    }

    .admin-container {
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 80vh;
        padding: 20px;
    }

    .glass-card {
        background: rgba(10, 10, 10, 0.8);
        backdrop-filter: blur(15px);
        border: 1px solid var(--border);
        border-radius: 24px;
        padding: 40px;
        width: 100%;
        max-width: 500px;
        box-shadow: 0 25px 50px rgba(0,0,0,0.5);
        transition: transform 0.3s ease;
    }

    .glass-card:hover {
        transform: translateY(-5px);
        border-color: var(--gold);
    }

    .gold-title {
        font-family: 'Playfair Display', serif;
        color: var(--gold);
        font-size: 2.2rem;
        text-align: center;
        margin-bottom: 10px;
        letter-spacing: 2px;
    }

    .subtitle {
        color: #888;
        text-align: center;
        font-size: 0.9rem;
        margin-bottom: 30px;
        text-transform: uppercase;
        letter-spacing: 3px;
    }

    .input-group {
        margin-bottom: 20px;
        position: relative;
    }

    .input-group label {
        display: block;
        color: var(--gold);
        font-size: 0.8rem;
        margin-bottom: 8px;
        margin-left: 5px;
        font-weight: 600;
    }

    .custom-input, .custom-select {
        width: 100%;
        padding: 14px 20px;
        background: rgba(255, 255, 255, 0.03);
        border: 1px solid #333;
        border-radius: 12px;
        color: white;
        font-size: 1rem;
        outline: none;
        transition: 0.3s;
        box-sizing: border-box;
    }

    .custom-input:focus, .custom-select:focus {
        border-color: var(--gold);
        background: rgba(255, 255, 255, 0.07);
        box-shadow: 0 0 15px rgba(233, 166, 22, 0.1);
    }

    .custom-select option {
        background: #111;
        color: white;
    }

    .btn-submit {
        width: 100%;
        padding: 16px;
        background: linear-gradient(45deg, #e9a616, #f7941d);
        color: black;
        border: none;
        border-radius: 12px;
        font-weight: 700;
        font-size: 1.1rem;
        cursor: pointer;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: 0.4s;
        margin-top: 10px;
    }

    .btn-submit:hover {
        filter: brightness(1.2);
        box-shadow: 0 10px 20px rgba(233, 166, 22, 0.3);
        transform: scale(1.02);
    }

    /* Animation */
    @keyframes fadeInUp {
        from { opacity: 0; transform: translateY(20px); }
        to { opacity: 1; transform: translateY(0); }
    }
    .animate-form { animation: fadeInUp 0.8s ease-out; }
</style>

<div class="admin-container">
    <div class="glass-card animate-form">
        <h2 class="gold-title">Add New Dish</h2>
        <p class="subtitle">Management Portal</p>
        
        <form action="AddMenuServlet" method="POST">
            <div class="input-group">
                <label>DISH NAME</label>
                <input type="text" name="name" class="custom-input" placeholder="e.g. Grilled Salmon" required>
            </div>

            <div class="input-group">
                <label>PRICE (RS.)</label>
                <input type="number" name="price" class="custom-input" placeholder="e.g. 1200" required>
            </div>

            <div class="input-group">
                <label>DESCRIPTION</label>
                <input type="text" name="description" class="custom-input" placeholder="Short description..." required>
            </div>

            <div class="input-group">
                <label>MENU CATEGORY</label>
                <select name="session" class="custom-select" required>
                    <option value="" disabled selected>Select Category</option>
                    <option value="Appitizer">Appitizers</option>
                    <option value="main">Main Course</option>
                    <option value="starter">Starters</option>
                    <option value="Drinks">Beverages & Drinks</option>
                </select>
            </div>

            <button type="submit" class="btn-submit">Add to Restaurant Menu</button>
        </form>
    </div>
</div>