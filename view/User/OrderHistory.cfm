<cfinclude template="Header.cfm">
<cfset variables.orders = application.modelOrderPage.getOrderHistory()>
<div class="historyContainer">
     <div class="searchHistory-bar">
        <input type="text" id="searchOrder" placeholder="Enter Order ID">
        <button onclick="searchOrder()">Search</button>
    </div>
    <cfoutput>
        <cfloop array="#variables.orders#" index="order">
            <div class="orderHistory-card">
                <div class="orderHistory-header">
                   <strong> Order ID: #order.orderId#</strong> | Ordered On: #DateFormat(order.orderDate, "mmm d yyyy")# #TimeFormat(order.orderDate, "h:mm tt")# 
                   <button class="btn btn-outline-danger me-2"
                        onclick="window.location.href='PdfPage.cfm?orderId=#order.orderId# '">
                        <i class="fa-solid fa-file-pdf"></i>
                   </button> 
                </div>
                <cfloop array="#order.products#" index="product">
                    <div class="productHistory-card">
                        <img src="/uploads/#product.productImage#" alt="productImage">
                        <div class="product-info">
                            <h5>#product.productName#</h5>
                            <p>Quantity: #product.quantity#</p>
                            <p>Price: <span>#product.price#</span></p>
                            <p>Tax: <span>#product.tax#%</span></p>
                            <p>Total Price: <span class="priceHistory"><i class="fa-solid fa-indian-rupee-sign"></i>#(product.price + (product.price * product.tax / 100)) * product.quantity#</span></p>
                        </div>
                    </div>
                </cfloop>
                <div class="totalHistory-price">
                    Total Cost: <span class="price"><i class="fa-solid fa-indian-rupee-sign"></i>#order.totalPrice#</span>
                </div>
                <div>
                    <strong>Shipping Address:</strong> #order.address.fname#, #order.address.line1#, #order.address.line2#, #order.address.city#, #order.address.state# - #order.address.pincode# <br>
                    <strong>Contact:</strong> #order.address.phone#
                </div>
            </div>
        </cfloop>
    </cfoutput>
</div>

<script>
    function searchOrder() {
        var orderId = document.getElementById("searchOrder").value;
        var orderCards = document.querySelectorAll(".orderHistory-card");

        orderCards.forEach(card => {
            if (card.innerHTML.includes(orderId) || orderId === "") {
                card.style.display = "block";
            } else {
                card.style.display = "none";
            }
        });
    }
</script>
<cfinclude template="Footer.cfm">
