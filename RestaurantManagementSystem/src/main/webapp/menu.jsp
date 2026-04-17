<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.fresco.dao.StaffManager" %>
<%@ page import="com.restaurant.model.MenuItem" %>
<%@ page import="java.util.*" %>

<%
    // --- FIX 1: EDIT LOGIC ---
    String isNewOrder = request.getParameter("newOrder");
    String isEdit = request.getParameter("edit");

    if("true".equals(isNewOrder) && !"true".equals(isEdit)) {
        session.removeAttribute("customer_name");
        session.removeAttribute("customer_phone");
    }

    List<MenuItem> allItems = (List<MenuItem>) getServletContext().getAttribute("globalMenu");
    if(allItems == null || allItems.isEmpty()) {
        allItems = StaffManager.getMenuList();
    }
    if(allItems == null) allItems = new ArrayList<>();

    // --- FIX 2: IMAGE MAPPING (Updated for accuracy) ---
    Map<String, String> categoryImages = new HashMap<>();
    categoryImages.put("appetizer", "appppi.jpg");
    categoryImages.put("starter", "appppi.jpg");
    categoryImages.put("main", "main.jpg");
    categoryImages.put("drink", "coffee.jpg");

    String customerName = (String) session.getAttribute("customer_name");
    boolean hasReservation = (customerName != null && !customerName.trim().isEmpty());
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Fresco Menu | Fine Dining</title>
    
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Merriweather:ital,wght@0,400;0,700;1,400&display=swap" rel="stylesheet">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
    
    <style>
        :root { --gold: #e9a616; --dark-bg: rgba(10, 10, 10, 0.95); }
        body { 
            margin: 0; font-family: 'Merriweather', serif; color: #e0dcc9; 
            background: linear-gradient(rgba(0,0,0,0.85), rgba(0,0,0,0.85)), url('menu.jpg'); 
            background-size: cover; background-position: center; background-attachment: fixed; 
        }
        .navbar { 
            display: flex; justify-content: space-between; align-items: center; 
            background-color: rgba(0, 0, 0, 0.95); padding: 12px 50px; position: fixed; 
            top: 0; width: 100%; z-index: 1000; backdrop-filter: blur(12px); 
            border-bottom: 1px solid rgba(233, 166, 22, 0.3); 
        }
        .search-section { margin-top: 140px; text-align: center; }
        .search-bar { 
            padding: 12px 25px; width: 400px; border-radius: 30px; border: 2px solid var(--gold); 
            background: rgba(0,0,0,0.6); color: white; outline: none; font-size: 1rem;
        }
        .search-btn { 
            padding: 12px 30px; border-radius: 30px; background: var(--gold); 
            color: black; font-weight: bold; margin-left: 10px; transition: 0.3s; 
        }
        h1 { font-weight: 700; font-size: 3rem; text-align: center; color: white; margin: 20px 0; }
        .category-title { 
            font-size: 2rem; color: var(--gold); text-transform: uppercase; 
            letter-spacing: 5px; border-bottom: 3px solid var(--gold); padding-bottom: 10px; 
        }
        .menu-container { 
            max-width: 1100px; margin: 0 auto 50px auto; background-color: var(--dark-bg); 
            padding: 40px; border-radius: 25px; display: flex; gap: 40px; 
            align-items: center; border: 1px solid rgba(247, 148, 29, 0.15); 
        }
        .dish-card { margin-bottom: 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); padding-bottom: 15px; }
        .price { font-weight: 700; font-size: 1.3rem; color: #f7941d; }
        .cart-sidebar { 
            position: fixed; top: 180px; right: 25px; width: 320px; background: #fff; 
            color: #1a1a1a; padding: 25px; border-radius: 20px; z-index: 1001; 
            border-top: 6px solid #f7941d; box-shadow: 0 20px 50px rgba(0,0,0,0.5);
        }
        .view-order-btn { 
            width: 100%; background: #111; color: #f7941d; padding: 14px; 
            border-radius: 10px; font-weight: bold; border: 1px solid #f7941d; cursor: pointer;
        }
        .welcome-pulse { animation: pulse 2s infinite; color: var(--gold); font-size: 1.8rem; font-weight: bold; }
        @keyframes pulse { 0% { opacity: 0.8; } 50% { opacity: 1; transform: scale(1.05); } 100% { opacity: 0.8; } }
    </style>
</head>
<body>

<nav class="navbar">
    <div class="logo"><img src="download.png" style="height: 60px;" /></div>
    <ul class="flex gap-8 text-white font-bold list-none">
        <li><a href="index.html" class="hover:text-orange-400">Home</a></li>
        <li><a href="menu.jsp?newOrder=true" class="text-orange-400 border-b-2 border-orange-400">Menu</a></li>
        <li><a href="login.jsp" class="hover:text-orange-400">Team</a></li>
        <li><a href="About.jsp" class="hover:text-orange-400">About</a></li>
        <li><a href="reservation.jsp" class="hover:text-orange-400">Reservation</a></li>
    </ul>
</nav>

<div class="search-section">
    <% if (hasReservation) { %>
        <h2 class="welcome-pulse">Welcome, <%= customerName %>!</h2>
    <% } %>
    <div class="mt-5" data-aos="fade-up">
        <input type="text" id="menuSearch" class="search-bar" placeholder="Search for your favorite dish...">
        <button type="button" class="search-btn">🔍 Search</button>
    </div>
</div>

<h1 data-aos="zoom-in">FRESCO SIGNATURE MENU</h1>

<form id="orderForm" method="post" action="Order.jsp" onsubmit="return validateOrder()">
    <input type="hidden" id="finalOrderData" name="stackOrder">

<%
    Set<String> dynamicCategories = new TreeSet<>();
    for(MenuItem m : allItems) {
        if(m.getSession() != null && !m.getSession().trim().isEmpty()) {
            dynamicCategories.add(m.getSession());
        }
    }

    for(String cat : dynamicCategories) {
        // --- FIXED IMAGE LOGIC ---
        String img = "menu.jpg"; 
        String lowCat = cat.toLowerCase();
        
        // Smart matching to prevent wrong images
        if(lowCat.contains("appetizer") || lowCat.contains("starter")) {
            img = "appppi.jpg";
        } else if(lowCat.contains("main")) {
            img = "main.jpg";
        } else if(lowCat.contains("drink") || lowCat.contains("coffee")) {
            img = "coffee.jpg";
        }

        List<MenuItem> filteredItems = new ArrayList<>();
        for(MenuItem m : allItems) {
            if(m.getSession() != null && m.getSession().equalsIgnoreCase(cat)) {
                filteredItems.add(m);
            }
        }
        if(!filteredItems.isEmpty()) { 
%>
    <div class="category-wrapper text-center my-10" data-aos="fade-up">
        <h3 class="category-title inline-block"><%= cat %></h3>
    </div>

    <div class="menu-container item-group" data-aos="fade-up">
        <div class="flex-1">
            <% for(MenuItem item : filteredItems) { %>
                <div class="dish-card flex justify-between items-center px-4" data-name="<%= item.getItemName().toLowerCase() %>">
                    <div class="flex-1">
                        <span class="text-xl font-bold text-white"><%= item.getItemName() %></span>
                        <div class="text-gray-400 text-sm italic mt-1"><%= item.getDescription() %></div>
                    </div>
                    <div class="text-right ml-4">
                        <span class="price block">Rs. <%= item.getPrice() %></span>
                        <input type="checkbox" class="dish-check mt-3 scale-150 accent-orange-500 cursor-pointer" 
                               data-id="<%= item.getId() %>"
                               data-itemname="<%= item.getItemName() %>" 
                               data-itemprice="<%= item.getPrice() %>">
                    </div>
                </div>
            <% } %>
        </div>
        <div class="photo-container hidden lg:block">
            <img src="<%= img %>" alt="<%= cat %>" class="w-[300px] h-[400px] object-cover rounded-2xl border-2 border-orange-500/30" onerror="this.src='menu.jpg'"/>
        </div>
    </div>
<% 
        } 
    } 
%>

    <div class="cart-sidebar" data-aos="slide-left">
        <h3 class="text-xl font-bold border-b pb-3 mb-4 text-center">🛒 YOUR CART</h3>
        <ul id="cartList" class="list-none p-0 text-sm space-y-3 max-h-64 overflow-y-auto">
            <li class="italic text-gray-400 text-center py-6">No items added yet...</li>
        </ul>
        <div class="border-t mt-5 pt-4 font-bold text-xl flex justify-between">
            <span>Total:</span>
            <span class="text-orange-600">Rs. <span id="cartTotal">0.00</span></span>
        </div>
        <button type="submit" class="view-order-btn mt-5 uppercase hover:bg-orange-500 hover:text-black transition">Place Order Now</button>
    </div>
</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/aos@2.3.1/dist/aos.js"></script>
<script>
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.get('newOrder') === 'true' && urlParams.get('edit') !== 'true') {
        localStorage.removeItem('fresco_cart');
    }

    let cart = JSON.parse(localStorage.getItem('fresco_cart')) || [];
    const hasRes = <%= hasReservation %>;

    function updateUI() {
        let html = "";
        let total = 0;
        
        if(cart.length === 0) {
            html = "<li class='italic text-gray-400 text-center py-6'>No items added yet...</li>";
        } else {
            cart.forEach(item => {
                html += `<li class="flex justify-between items-center bg-gray-100 p-2 rounded border-l-4 border-orange-500 text-black">
                    <span class="font-medium">\${item.name}</span>
                    <span class="font-bold text-orange-700">Rs. \${parseFloat(item.price).toFixed(2)}</span>
                </li>`;
                total += parseFloat(item.price);
            });
        }
        
        $("#cartList").html(html);
        $("#cartTotal").text(total.toFixed(2));
        $("#finalOrderData").val(cart.map(i => i.id).join(","));
        localStorage.setItem('fresco_cart', JSON.stringify(cart));
        syncCheckboxes();
    }

    function syncCheckboxes() {
        $(".dish-check").each(function() {
            const id = $(this).data('id');
            const isSelected = cart.some(item => item.id == id);
            $(this).prop('checked', isSelected);
        });
    }

    $(document).ready(function() {
        AOS.init({ duration: 800, once: true });
        updateUI();

        $(".dish-check").change(function() {
            const id = $(this).data('id');
            const name = $(this).data('itemname');
            const price = $(this).data('itemprice');

            if($(this).is(':checked')) {
                if(!cart.some(i => i.id == id)) cart.push({id, name, price});
            } else {
                cart = cart.filter(i => i.id != id);
            }
            updateUI();
        });

        $("#menuSearch").on("keyup", function() {
            let val = $(this).val().toLowerCase().trim();
            if(val === "") {
                $(".dish-card, .menu-container, .category-wrapper").show();
                return;
            }
            $(".dish-card").each(function() {
                let name = $(this).data('name');
                $(this).toggle(name.includes(val));
            });
            $(".menu-container").each(function() {
                let visibleItems = $(this).find(".dish-card:visible").length;
                $(this).toggle(visibleItems > 0);
                $(this).prev(".category-wrapper").toggle(visibleItems > 0);
            });
        });
    });

    function validateOrder() {
        if(cart.length === 0) { 
            alert("Your cart is empty!"); 
            return false; 
        }
        if(!hasRes) { 
            alert("Redirecting to reservation..."); 
            window.location.href='reservation.jsp'; 
            return false; 
        }
        return true;
    }
</script>
</body>
</html>