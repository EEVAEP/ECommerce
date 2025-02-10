<cfcomponent>
    <cffunction  name="getOrderedProductsDetails" access="public" returntype="query">
        <cfargument name="orderId" type="string" required="true">
        <cfquery name="local.qryOrderedProducts" datasource="#application.datasource#">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                OI.fldOrderId,
                OI.fldQuantity,
                P.fldPrice ,
                P.fldTax,
                O.fldTotalPrice,
                O.fldTotalTax,
                O.fldTotalPrice,
                O.fldTotalTax,
                A.fldAddressLine1,
                A.fldAddressLine2,
                A.fldCity,
                A.fldState,
                A.fldPincode,
                A.fldPhonenumber,
                O.fldOrderDate,
                O.fldCardPart
            FROM 
                tblorderitems AS OI
            INNER JOIN tblproduct AS P ON P.fldProduct_ID = OI.fldProductId
            INNER JOIN tblOrder AS O ON O.fldOrder_ID  = OI.fldOrderId
            INNER JOIN shoppingcart.tblAddress AS A ON A.fldAddress_ID = O.fldAddressId
            WHERE
                O.fldOrderId  = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
                AND O.fldOrder_ID  = <cfqueryparam value = "#arguments.orderId#" cfsqltype = "cf_sql_varchar">
            GROUP BY 
                P.fldProductName,
                P.fldProduct_ID,
                OI.fldOrderId,
                OI.fldQuantity,
                P.fldPrice ,
                P.fldTax,
                O.fldTotalPrice,
                O.fldTotalTax 
        </cfquery>
        <cfreturn local.qryOrderedProducts>
    </cffunction>

    <cffunction name="sendMailToUserAddress" access="public" returntype="void">
        <cfargument name= "orderId" type="string" required="true">
        <cfset local.displayOrderedItems = application.modelOrderPage.getOrderedProductsDetails(orderId = arguments.orderId)>
        <cfset local.userDetails = application.modelUserPage.getUserProfileDetails()>
        <cfset local.userMail = local.userDetails.fldEmail>
        <cfset local.payableAmount = local.displayOrderedItems.fldTotalPrice>
        <cfif local.displayOrderedItems.recordCount GT 0>
            <cfset local.orderTotal = local.displayOrderedItems.fldTotalPrice>
            <cfset local.orderTax = local.displayOrderedItems.fldTotalTax>
            <cfset local.emailBody = "<h2>Thank you for your purchase!</h2>">
            <cfset local.emailBody &= "<p>Order Date: <strong>#local.displayOrderedItems.fldOrderDate#</strong></p>">
            <cfset local.emailBody &= "<p>Your Order ID: <strong>#local.displayOrderedItems.fldOrderId#</strong></p>">
            <cfset local.emailBody &= "<p>Your Shipping Address: #local.displayOrderedItems.fldAddressLine1#, #local.displayOrderedItems.fldAddressLine2#, #local.displayOrderedItems.fldCity#, #local.displayOrderedItems.fldState#, #local.displayOrderedItems.fldPincode#</p>">
            <cfset local.emailBody &= "<p>Your Account Details: <strong>********#local.displayOrderedItems.fldCardPart#</strong></p>">
            <cfset local.emailBody &= "<table border='1' cellpadding='5' cellspacing='0' style='border-collapse: collapse; width: 100%;'>
                                            <tr>
                                                <th>Product Name</th>
                                                <th>Quantity</th>
                                                <th>Price</th>
                                                <th>Tax</th>
                                            </tr>">
            <cfloop query="local.displayOrderedItems">
                <cfset local.emailBody &= "<tr>
                                            <td>#local.displayOrderedItems.fldProductName#</td>
                                            <td>#local.displayOrderedItems.fldQuantity#</td>
                                            <td>#local.displayOrderedItems.fldPrice#</td>
                                            <td>#local.displayOrderedItems.fldTax#</td>
                                        </tr>">
            </cfloop>
            <cfset local.emailBody &= "</table>">
            <cfset local.emailBody &= "<p><strong>Payable Amount:</strong> #local.payableAmount#</p>">
            <cfset local.emailBody &= "<p>We appreciate your business!</p>">
            <cfmail to="#local.userMail#" from="eevaparayil7@gmail.com" subject="Your Order Confirmation - #local.displayOrderedItems.fldOrderId#" type="html">
                #local.emailBody#
            </cfmail>
    </cfif>
    </cffunction>

    <cffunction name="getOrderHistory" access="public" returntype="array">
        <cfquery name="local.qryOrderHistory" datasource="#application.datasource#">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                OI.fldOrderId,
                OI.fldQuantity,
                P.fldPrice,
                P.fldTax,
                O.fldTotalPrice,
                O.fldTotalTax,
                A.fldAddressLine1,
                A.fldAddressLine2,
                A.fldCity,
                A.fldState,
                A.fldPincode,
                A.fldPhonenumber,
                A.fldFirstName,
                O.fldOrderDate,
                O.fldCardPart,
                I.fldImageFileName
            FROM 
                tblorderitems AS OI
            INNER JOIN tblproduct AS P ON P.fldProduct_ID = OI.fldProductId
            INNER JOIN tblOrder AS O  ON O.fldOrder_ID = OI.fldOrderId
            INNER JOIN tblAddress AS A ON A.fldAddress_ID = O.fldAddressId
            INNER JOIN tblproductimages AS I ON I.fldProductId = OI.fldProductId
            WHERE
                O.fldOrderId = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                AND I.fldDefaultImage = 1
                AND I.fldActive = 1
            ORDER BY 
                O.fldOrderDate DESC
        </cfquery>
        <cfset orderData = []>
        <cfloop query="local.qryOrderHistory" group="fldOrderId">
            <cfset productList = []> 
            <cfloop>
                <cfset productData = {
                    "productName" = local.qryOrderHistory.fldProductName,
                    "productId" = local.qryOrderHistory.idProduct,
                    "quantity" = local.qryOrderHistory.fldQuantity,
                    "price" = local.qryOrderHistory.fldPrice,
                    "tax" = local.qryOrderHistory.fldTax,
                    "productImage" = local.qryOrderHistory.fldImageFileName,
                    "quantity" =  local.qryOrderHistory.fldQuantity
                }>
                <cfset arrayAppend(productList, productData)>
            </cfloop>
            <cfset orderDetails = {
                "orderId" = fldOrderId,
                "orderDate" = fldOrderDate,
                "totalPrice" = fldTotalPrice,
                "totalTax" = fldTotalTax,
                "address" = {
                    "fname" = fldFirstName,
                    "line1" = fldAddressLine1,
                    "line2" = fldAddressLine2,
                    "city" = fldCity,
                    "state" = fldState,
                    "pincode" = fldPincode,
                    "phone" = fldPhonenumber
                },
                "products" = productList
            }>
            <cfset arrayAppend(orderData, orderDetails)>
        </cfloop>
        <cfreturn orderData>
    </cffunction>
</cfcomponent>