<cfinclude template="Header.cfm">

<cfset orderHistory = application.modelOrderPage.getOrderHistory()>
<cfdump var="#orderHistory #" abort>


<!---<div class="historyContainer">
    <div class="historySearch-box">
        <input type="text" id="searchOrder" placeholder="Order Id">
        <button onclick="searchOrder()">Search</button>
    </div>

    <cfloop query="orderHistory">
        <div class="orderHistory-card">
            <div class="orderHistory-header">
                Order ID: #orderHistory.orderId#
            </div>
            <div class="orderHistory-details">
                <img src="#orderHistory.fldImage#" class="order-image" alt="Product Image">
                <div class="orderHistory-info">
                    <h3>#orderHistory.fldProductName#</h3>
                    <p><strong>Brand:</strong> #orderHistory.fldBrand#</p>
                    <p><strong>Quantity:</strong> #orderHistory.fldQuantity#</p>
                    <p><strong>Actual Price:</strong> ₹#orderHistory.actualPrice#</p>
                    <p><strong>Tax:</strong> #orderHistory.fldTax#%</p>
                    <p><strong>Total Price:</strong> ₹#orderHistory.fldTotalPrice#</p>
                    <p class="historyTotal-cost">Total Cost: ₹#orderHistory.fldTotalPrice#</p>
                    <div class="shipping">
                        <p><strong>Shipping Address:</strong> #orderHistory.shippingAddress#</p>
                        <p><strong>Contact:</strong> #orderHistory.contact#</p>
                    </div>
                </div>
            </div>
        </div>
    </cfloop>

</div>--->





<cfinclude template="Footer.cfm">
