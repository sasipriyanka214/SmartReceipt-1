<%@ page import="java.text.DecimalFormat" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // =====================================================
    // TECHCART - SMART ELECTRONICS RECEIPT
    // =====================================================

    String customerName = request.getParameter("customerName");
    String phone = request.getParameter("phone");
    String payment = request.getParameter("payment");
    String delivery = request.getParameter("delivery");

    if (customerName == null || customerName.trim().equals("")) {
        customerName = "Guest Customer";
    }

    if (phone == null || phone.trim().equals("")) {
        phone = "Not provided";
    }

    if (payment == null) {
        payment = "UPI";
    }

    if (delivery == null) {
        delivery = "standard";
    }

    // =====================================================
    // PRODUCTS
    // =====================================================

    String[] productNames = {
        "Wireless Headphones",
        "Mechanical Keyboard",
        "Gaming Mouse",
        "Smart Webcam",
        "Bluetooth Speaker"
    };

    String[] productIcons = {
        "🎧",
        "⌨️",
        "🖱️",
        "📷",
        "🔊"
    };

    double[] prices = {
        1499.00,
        2499.00,
        999.00,
        1799.00,
        1299.00
    };

    int[] quantities = {
        1,
        1,
        1,
        1,
        1
    };

    // =====================================================
    // READ QUANTITIES
    // =====================================================

    for (int i = 0; i < quantities.length; i++) {

        String value = request.getParameter("qty" + i);

        if (value != null) {

            try {

                int q = Integer.parseInt(value);

                if (q >= 0) {
                    quantities[i] = q;
                }

            } catch (Exception e) {

                quantities[i] = 0;

            }
        }
    }

    // =====================================================
    // CALCULATIONS
    // =====================================================

    double subtotal = 0;
    int totalItems = 0;

    for (int i = 0; i < prices.length; i++) {

        subtotal = subtotal + (prices[i] * quantities[i]);

        totalItems = totalItems + quantities[i];
    }

    // Fixed 5% discount
    double discount = subtotal * 0.05;

    double afterDiscount = subtotal - discount;

    // 5% tax
    double tax = afterDiscount * 0.05;

    // Delivery
    double deliveryCharge = 0;

    if (delivery.equals("express")) {
        deliveryCharge = 99;
    }

    double grandTotal = afterDiscount + tax + deliveryCharge;

    DecimalFormat df = new DecimalFormat("0.00");

    // =====================================================
    // INVOICE NUMBER
    // =====================================================

    String invoiceNumber =
        "TC-" + new java.text.SimpleDateFormat("yyyyMMddHHmmss")
        .format(new java.util.Date());

    String invoiceDate =
        new java.text.SimpleDateFormat("dd-MM-yyyy")
        .format(new java.util.Date());

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>TechCart - Smart Receipt</title>

<style>

* {
    box-sizing: border-box;
}

body {

    margin: 0;

    font-family:
        Arial,
        Helvetica,
        sans-serif;

    background:
        radial-gradient(
            circle at 10% 20%,
            rgba(59,130,246,0.08),
            transparent 25%
        ),
        radial-gradient(
            circle at 90% 80%,
            rgba(14,165,233,0.08),
            transparent 25%
        ),
        #f3f7fc;

    color: #1e293b;

}

/* =====================================================
   MAIN CONTAINER
   ===================================================== */

.container {

    width: 94%;

    max-width: 1180px;

    margin: 30px auto;

    background: #ffffff;

    border-radius: 20px;

    box-shadow:
        0 12px 40px rgba(15,23,42,0.10);

    overflow: hidden;

}

/* =====================================================
   HEADER
   ===================================================== */

.header {

    padding: 30px;

    background:
        linear-gradient(
            135deg,
            #eff6ff,
            #ffffff
        );

    border-bottom:
        1px solid #dbeafe;

}

.header-top {

    display: flex;

    justify-content: space-between;

    align-items: center;

    gap: 20px;

}

.logo-area {

    display: flex;

    align-items: center;

    gap: 15px;

}

.logo {

    width: 62px;

    height: 62px;

    border-radius: 16px;

    background: #2563eb;

    color: white;

    display: flex;

    justify-content: center;

    align-items: center;

    font-size: 31px;

}

.brand {

    margin: 0;

    font-size: 34px;

    color: #1d4ed8;

}

.tagline {

    margin-top: 5px;

    color: #64748b;

}

.invoice-box {

    text-align: right;

    color: #475569;

    font-size: 14px;

    line-height: 1.8;

}

/* =====================================================
   SECTION
   ===================================================== */

.section {

    padding: 28px;

}

.section-title {

    margin-top: 0;

    margin-bottom: 18px;

    font-size: 23px;

    color: #1e3a8a;

}

/* =====================================================
   CUSTOMER
   ===================================================== */

.customer {

    background: #f8fbff;

    border: 1px solid #dbeafe;

    border-radius: 14px;

    padding: 20px;

    margin-bottom: 28px;

}

.customer-grid {

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 18px;

}

.field label {

    display: block;

    margin-bottom: 7px;

    font-size: 14px;

    font-weight: bold;

    color: #475569;

}

.field input {

    width: 100%;

    padding: 12px;

    border: 1px solid #cbd5e1;

    border-radius: 8px;

    font-size: 15px;

    outline: none;

}

.field input:focus {

    border-color: #2563eb;

}

/* =====================================================
   PRODUCTS
   ===================================================== */

.products {

    display: grid;

    grid-template-columns:
        repeat(5, 1fr);

    gap: 17px;

}

.product {

    background: #ffffff;

    border:
        1px solid #dbeafe;

    border-radius: 15px;

    padding: 14px;

    text-align: center;

    transition: 0.2s;

}

.product:hover {

    transform:
        translateY(-4px);

    box-shadow:
        0 8px 20px
        rgba(37,99,235,0.12);

}

.product-preview {

    height: 120px;

    background:
        linear-gradient(
            135deg,
            #eff6ff,
            #e0f2fe
        );

    border-radius: 11px;

    display: flex;

    justify-content: center;

    align-items: center;

    margin-bottom: 13px;

}

.product-preview span {

    font-size: 53px;

}

.product-name {

    font-size: 14px;

    font-weight: bold;

    min-height: 38px;

    display: flex;

    justify-content: center;

    align-items: center;

}

.price {

    color: #2563eb;

    font-weight: bold;

    font-size: 17px;

    margin: 8px 0;

}

.quantity {

    width: 70px;

    padding: 8px;

    text-align: center;

    border:
        1px solid #cbd5e1;

    border-radius: 7px;

}

/* =====================================================
   OPTIONS
   ===================================================== */

.options {

    margin-top: 28px;

    display: grid;

    grid-template-columns:
        1fr 1fr;

    gap: 20px;

}

.option-box {

    background: #f8fbff;

    border:
        1px solid #dbeafe;

    border-radius: 13px;

    padding: 18px;

}

.option-box h3 {

    margin-top: 0;

    color: #1e3a8a;

}

.option-box label {

    display: block;

    margin: 11px 0;

    cursor: pointer;

}

.option-box input {

    margin-right: 8px;

}

/* =====================================================
   BUTTON
   ===================================================== */

.generate {

    width: 100%;

    margin-top: 25px;

    padding: 15px;

    border: none;

    border-radius: 10px;

    background: #2563eb;

    color: white;

    font-size: 17px;

    font-weight: bold;

    cursor: pointer;

}

.generate:hover {

    background: #1d4ed8;

}

/* =====================================================
   RECEIPT
   ===================================================== */

.receipt {

    margin-top: 30px;

    padding: 25px;

    background: #ffffff;

    border:
        1px solid #dbeafe;

    border-radius: 16px;

}

.receipt-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    border-bottom:
        1px solid #e2e8f0;

    padding-bottom: 15px;

    margin-bottom: 18px;

}

.receipt-header h2 {

    margin: 0;

    color: #1e3a8a;

}

.customer-summary {

    background: #f8fafc;

    border-radius: 10px;

    padding: 13px;

    margin-bottom: 18px;

    font-size: 14px;

}

/* =====================================================
   TABLE
   ===================================================== */

table {

    width: 100%;

    border-collapse: collapse;

}

th {

    background: #1e3a8a;

    color: white;

    padding: 12px;

    text-align: left;

}

td {

    padding: 12px;

    border-bottom:
        1px solid #e5e7eb;

}

.right {

    text-align: right;

}

/* =====================================================
   SUMMARY
   ===================================================== */

.summary {

    max-width: 500px;

    margin:
        22px 0 0 auto;

    background: #f8fbff;

    border:
        1px solid #dbeafe;

    border-radius: 12px;

    padding: 20px;

}

.summary p {

    display: flex;

    justify-content: space-between;

    margin: 11px 0;

}

.discount {

    color: #15803d;

}

.delivery {

    color: #475569;

}

.grand {

    font-size: 22px;

    font-weight: bold;

    color: #1d4ed8;

}

.success {

    margin-top: 17px;

    padding: 13px;

    text-align: center;

    background: #ecfdf5;

    color: #15803d;

    border-radius: 9px;

    font-weight: bold;

}

/* =====================================================
   STATUS
   ===================================================== */

.status {

    margin-top: 20px;

    display: grid;

    grid-template-columns:
        repeat(3,1fr);

    gap: 10px;

}

.status div {

    padding: 13px;

    text-align: center;

    border-radius: 9px;

    background: #eff6ff;

    color: #1e40af;

    font-size: 14px;

}

/* =====================================================
   ACTION BUTTONS
   ===================================================== */

.actions {

    display: flex;

    gap: 12px;

    margin-top: 20px;

}

.print-btn,
.reset-btn {

    flex: 1;

    padding: 13px;

    border: none;

    border-radius: 9px;

    font-weight: bold;

    cursor: pointer;

}

.print-btn {

    background: #0f172a;

    color: white;

}

.reset-btn {

    background: #e2e8f0;

    color: #1e293b;

}

/* =====================================================
   FOOTER
   ===================================================== */

.footer {

    text-align: center;

    padding: 22px;

    background: #f8fafc;

    color: #64748b;

    font-size: 13px;

}

/* =====================================================
   PRINT
   ===================================================== */

@media print {

    body {

        background: white;

    }

    .container {

        width: 100%;

        margin: 0;

        box-shadow: none;

    }

    .customer,
    .products,
    .options,
    .generate,
    .actions,
    .section > .section-title {

        display: none;

    }

    .receipt {

        border: none;

        margin: 0;

    }

    .footer {

        display: none;

    }

}

/* =====================================================
   RESPONSIVE
   ===================================================== */

@media(max-width: 950px) {

    .products {

        grid-template-columns:
            repeat(3, 1fr);

    }

}

@media(max-width: 650px) {

    .header-top {

        flex-direction: column;

        align-items: flex-start;

    }

    .invoice-box {

        text-align: left;

    }

    .customer-grid,
    .options {

        grid-template-columns: 1fr;

    }

    .products {

        grid-template-columns:
            repeat(2, 1fr);

    }

    .status {

        grid-template-columns: 1fr;

    }

}

</style>

</head>

<body>

<div class="container">

<!-- =====================================================
     HEADER
     ===================================================== -->

<div class="header">

    <div class="header-top">

        <div class="logo-area">

            <div class="logo">
                💻
            </div>

            <div>

                <h1 class="brand">
                    TechCart
                </h1>

                <div class="tagline">
                    Smart Electronics Store
                </div>

            </div>

        </div>

        <div class="invoice-box">

            <b>Smart Digital Invoice</b><br>

            Invoice:
            <%= invoiceNumber %><br>

            Date:
            <%= invoiceDate %>

        </div>

    </div>

</div>


<div class="section">


<!-- =====================================================
     CUSTOMER DETAILS
     ===================================================== -->

<div class="customer">

    <h2 class="section-title">
        👤 Customer Details
    </h2>

    <div class="customer-grid">

        <div class="field">

            <label>
                Customer Name
            </label>

            <input
                type="text"
                name="customerName"
                form="cartForm"
                value="<%= customerName.equals("Guest Customer") ? "" : customerName %>"
                placeholder="Enter your name">

        </div>

        <div class="field">

            <label>
                Phone Number
            </label>

            <input
                type="text"
                name="phone"
                form="cartForm"
                value="<%= phone.equals("Not provided") ? "" : phone %>"
                placeholder="Enter phone number">

        </div>

    </div>

</div>


<!-- =====================================================
     PRODUCTS
     ===================================================== -->

<h2 class="section-title">
    🛍️ Select Your Electronics
</h2>

<form method="post" id="cartForm">

    <div class="products">

        <%
            for (int i = 0; i < productNames.length; i++) {
        %>

        <div class="product">

            <div class="product-preview">

                <span>
                    <%= productIcons[i] %>
                </span>

            </div>

            <div class="product-name">
                <%= productNames[i] %>
            </div>

            <div class="price">
                ₹<%= df.format(prices[i]) %>
            </div>

            <input
                class="quantity"
                type="number"
                name="qty<%= i %>"
                value="<%= quantities[i] %>"
                min="0">

        </div>

        <%
            }
        %>

    </div>


<!-- =====================================================
     PAYMENT + DELIVERY
     ===================================================== -->

<div class="options">

    <div class="option-box">

        <h3>
            🚚 Delivery Option
        </h3>

        <label>

            <input
                type="radio"
                name="delivery"
                value="standard"
                <%= delivery.equals("standard") ? "checked" : "" %>>

            Standard Delivery — FREE

        </label>

        <label>

            <input
                type="radio"
                name="delivery"
                value="express"
                <%= delivery.equals("express") ? "checked" : "" %>>

            Express Delivery — ₹99

        </label>

    </div>


    <div class="option-box">

        <h3>
            💳 Payment Method
        </h3>

        <label>

            <input
                type="radio"
                name="payment"
                value="UPI"
                <%= payment.equals("UPI") ? "checked" : "" %>>

            UPI

        </label>

        <label>

            <input
                type="radio"
                name="payment"
                value="Card"
                <%= payment.equals("Card") ? "checked" : "" %>>

            Credit / Debit Card

        </label>

        <label>

            <input
                type="radio"
                name="payment"
                value="Cash"
                <%= payment.equals("Cash") ? "checked" : "" %>>

            Cash on Delivery

        </label>

    </div>

</div>


<button
    class="generate"
    type="submit">

    🧾 Generate Smart Receipt

</button>

</form>


<!-- =====================================================
     RECEIPT
     ===================================================== -->

<div class="receipt">

    <div class="receipt-header">

        <h2>
            🧾 Digital Receipt
        </h2>

        <div>
            <b>TechCart</b><br>
            Smart Electronics
        </div>

    </div>


    <div class="customer-summary">

        <b>Customer:</b>
        <%= customerName %>

        &nbsp;&nbsp; | &nbsp;&nbsp;

        <b>Phone:</b>
        <%= phone %>

        &nbsp;&nbsp; | &nbsp;&nbsp;

        <b>Payment:</b>
        <%= payment %>

    </div>


    <table>

        <tr>

            <th>
                Product
            </th>

            <th>
                Price
            </th>

            <th>
                Qty
            </th>

            <th class="right">
                Total
            </th>

        </tr>


        <%
            for (int i = 0; i < productNames.length; i++) {

                if (quantities[i] > 0) {

                    double itemTotal =
                        prices[i] * quantities[i];
        %>

        <tr>

            <td>

                <%= productIcons[i] %>

                <%= productNames[i] %>

            </td>

            <td>

                ₹<%= df.format(prices[i]) %>

            </td>

            <td>

                <%= quantities[i] %>

            </td>

            <td class="right">

                ₹<%= df.format(itemTotal) %>

            </td>

        </tr>

        <%
                }
            }
        %>

    </table>


    <!-- =================================================
         SUMMARY
         ================================================= -->

    <div class="summary">

        <p>

            <b>Total Items</b>

            <span>
                <%= totalItems %>
            </span>

        </p>


        <p>

            <b>Subtotal</b>

            <span>
                ₹<%= df.format(subtotal) %>
            </span>

        </p>


        <p class="discount">

            <b>Discount (5%)</b>

            <span>
                - ₹<%= df.format(discount) %>
            </span>

        </p>


        <p>

            <b>After Discount</b>

            <span>
                ₹<%= df.format(afterDiscount) %>
            </span>

        </p>


        <p>

            <b>Tax (5%)</b>

            <span>
                ₹<%= df.format(tax) %>
            </span>

        </p>


        <p class="delivery">

            <b>Delivery</b>

            <span>

                <%
                    if (deliveryCharge == 0) {
                %>

                    FREE

                <%
                    } else {
                %>

                    ₹<%= df.format(deliveryCharge) %>

                <%
                    }
                %>

            </span>

        </p>


        <hr>


        <p class="grand">

            <span>
                Grand Total
            </span>

            <span>
                ₹<%= df.format(grandTotal) %>
            </span>

        </p>


        <div class="success">

            🎉 5% discount applied successfully!

        </div>

    </div>


    <!-- =================================================
         ORDER STATUS
         ================================================= -->

    <div class="status">

        <div>
            ✓ Products Selected
        </div>

        <div>
            ✓ Payment: <%= payment %>
        </div>

        <div>
            ✓ Order Ready
        </div>

    </div>


    <!-- =================================================
         ACTIONS
         ================================================= -->

    <div class="actions">

        <button
            class="print-btn"
            onclick="window.print()">

            🖨 Print Receipt

        </button>


        <button
            class="reset-btn"
            onclick="window.location.href='smartReceipt.jsp'">

            ↻ New Order

        </button>

    </div>

</div>

</div>


<!-- =====================================================
     FOOTER
     ===================================================== -->

<div class="footer">

    TechCart © 2026

    &nbsp; • &nbsp;

    Smart Electronics

    &nbsp; • &nbsp;

    Thank you for shopping with us! 💙

</div>


</div>

</body>

</html>