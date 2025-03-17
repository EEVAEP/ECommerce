<cfif structKeyExists(url, "orderId") AND len(trim(url.orderId)) GT 0>
    <cfset variables.pdfOrders = application.modelOrderPage.getOrderHistory(orderId=url.orderId)>
<cfelse>
    <cfset variables.pdfOrders = []>
</cfif>
<cfif arrayLen(variables.pdfOrders) GT 0>
    <cfset matchingOrder = variables.pdfOrders[1]> 
    <cfheader name="Content-Disposition" value="attachment; filename=Order_#matchingOrder.orderId#.pdf">
    <cfheader name="Content-Type" value="application/pdf">
    <cfcontent type="application/pdf" reset="true">
    <cfdocument format="PDF" orientation="portrait">
        <h1 style="text-align: center;">Order Details</h1>
        <cfoutput>
            <h2>Order ID: #matchingOrder.orderId#</h2>
            <p><strong>Ordered On:</strong> #DateFormat(matchingOrder.orderDate, "mmm d yyyy")#</p>
            <p><strong>Shipping Address:</strong> #matchingOrder.address.fname#, #matchingOrder.address.line1#, #matchingOrder.address.line2#, #matchingOrder.address.city#, #matchingOrder.address.state# - #matchingOrder.address.pincode#</p>
            <p><strong>Contact:</strong> #matchingOrder.address.phone#</p>
            <table border="1" cellpadding="5" cellspacing="0" width="100%">
                <thead>
                    <tr>
                        <th>Product Name</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Tax</th>
                        <th>Total Price</th>
                    </tr>
                </thead>
                <tbody>
                    <cfloop array="#matchingOrder.products#" index="product">
                        <tr>
                            <td>#product.productName#</td>
                            <td>#product.quantity#</td>
                            <td>#product.price#</td>
                            <td>#product.tax#%</td>
                            <td>#(product.price + (product.price * product.tax / 100)) * product.quantity#</td>
                        </tr>
                    </cfloop>
                </tbody>
            </table>
            <h3>Total Cost: <i class="fa-solid fa-indian-rupee-sign"></i>#matchingOrder.totalPrice#</h3>
        </cfoutput>
    </cfdocument>
<cfelse>
    <p>No matching order found.</p>
</cfif>



