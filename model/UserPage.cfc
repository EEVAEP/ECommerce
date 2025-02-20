<cfcomponent>
    <cffunction name="createCartProducts" access="public" returntype="any">
        <cfargument name="productId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
        <cfif structKeyExists(arguments, "productId")>
            <cfif NOT isNumeric(local.decryptedId) OR local.decryptedId LTE 0>
                <cflocation url="searchResults.cfm">
            </cfif>
        </cfif>
        <cfquery name="local.qryCheckProduct" datasource="#application.datasource#">
            SELECT 
                COUNT(*) AS ProductCount
            FROM 
                tblcart
            WHERE 
                fldUserId = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                AND fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif local.qryCheckProduct.ProductCount EQ 0>
            <cfquery name="local.qryInsertProductIntoCart" result="local.insertProductIntoCart" datasource="#application.datasource#">
                INSERT INTO 
                    tblcart(
                            fldUserId,
                            fldProductId,
                            fldQuantity,
                            fldCreatedDate
                    )
                VALUES 
                    (
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar" >,
                        1,
                        <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    )
            </cfquery>
        <cfelse>
            <cfset arguments['mode'] = "1">
            <cfset local.addCatogory=increaseOrDecreaseCartProduct(argumentCollection=arguments)>
        </cfif>
        <cfreturn "success">
    </cffunction>

    <cffunction name="getCartProductsCount" access="public" returntype="any">
       <cfquery name="local.qryCartCount" datasource="#application.datasource#">
            SELECT 
                fldCart_ID
            FROM 
                tblcart
            WHERE
                fldUserId = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
        </cfquery>
        <cfif local.qryCartCount.recordCount GT 0>
            <cfreturn local.qryCartCount.recordCount>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>

    <cffunction  name="getCartProductsList" access="public" returntype="query">
       <cfquery name="local.qryDisplayCartProducts" datasource="#application.datasource#">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName,
                C.fldQuantity,
                (P.fldPrice + (P.fldPrice * (P.fldTax / 100))) * C.fldQuantity AS priceWithTax,
                SUM(P.fldPrice * C.fldQuantity) AS actualPrice,
                fldPrice * (fldTax / 100) * C.fldQuantity AS totalTax,
                P.fldPrice + (P.fldPrice * (P.fldTax / 100)) * C.fldQuantity AS totalPrice
            FROM 
                tblproduct AS P
                INNER JOIN tblcart AS C ON C.fldProductId =  P.fldProduct_ID
                INNER JOIN tblbrands AS B ON B.fldBrand_ID =  P.fldBrandId
                INNER JOIN tblproductImages AS I ON I.fldProductId = P.fldProduct_ID
            WHERE 
                P.fldActive = 1
                AND I.fldActive = 1
                AND I.fldDefaultImage = 1
                AND C.fldQuantity >= 1
                AND C.fldUserId = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
            GROUP BY
                P.fldProductName,
                P.fldProduct_ID,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName,
                C.fldQuantity
        </cfquery>
        <cfreturn local.qryDisplayCartProducts>
    </cffunction>

    <cffunction name="deleteCartProduct" access="remote" returnformat = "JSON">
        <cfargument name="productId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                DELETE 
                FROM 
                    tblCart
                WHERE
                    fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
                    AND fldUserId = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfset local.response = {status="success", message="Product deleted from cart successfully."}>
            <cfreturn local.response>
            <cfcatch>
                <cfset local.response = {status="error", message="An error occurred while deleting the product."}>
                <cfreturn local.response>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="increaseOrDecreaseCartProduct" access="remote" returnformat = "JSON">
    	<cfargument name="productId" type="string" required="true">
        <cfargument name="mode" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
        <cftry>
            <cfquery name="local.qryGetProductQuantity" datasource="#application.datasource#">
                SELECT 
                    fldQuantity
                FROM 
                    tblCart
                WHERE 
                    fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfif local.qryGetProductQuantity.recordCount GTE 1>
                <cfif arguments.mode EQ "1">
                    <cfset local.newQuantity = local.qryGetProductQuantity.fldQuantity + 1>
                <cfelseif arguments.mode EQ "0">
                    <cfset local.newQuantity = local.qryGetProductQuantity.fldQuantity - 1>
                </cfif>
                <cfif local.newQuantity EQ 0>
                    <cfset local.response = {status="error", message="Product cannot removed from the cart"}>
                    <cfreturn local.response>
                <cfelse>
                    <cfquery datasource = "#application.datasource#" result="local.updateProductQuantity">
                        UPDATE tblCart
                        SET 
                            fldQuantity = <cfqueryparam value="#local.newQuantity#" cfsqltype="cf_sql_integer">
                        WHERE
                            fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset local.response = {status="success", message="Product updated successfully."}>
                    <cfreturn local.response>
                </cfif>
            <cfelse>
                <cfset local.response = {status="failed", message="Product not updated."}>
                <cfreturn local.response>
            </cfif>  
            <cfcatch>
                <cfset local.response = {status="error", message="An error occurred while deleting the product."}>
                <cfreturn local.response>
            </cfcatch>
        </cftry>
    </cffunction>
<!---------------------------------User Profile Page functions------------------------------------------------------------- --->
    
    <!------ Stored Procedure ------>
    <cffunction name="getUserProfileDetails" access="public" returntype="any">
        <cfquery name="local.qryGetUserDetails" datasource="#application.datasource#">
            CALL spGetUserProfileDetails(
                <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
            )
        </cfquery>
        <cfreturn local.qryGetUserDetails>
    </cffunction>

    <cffunction  name= "validateUserProfileDetails" access= "remote" returnformat="JSON">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="addressLine1" type="string" required="true">
        <cfargument name="addressLine2" type="string" required="true">
        <cfargument name="city" type="string" required="true">
        <cfargument name="state" type="string" required="true">
        <cfargument name="pincode" type="string" required="true">
        <cfargument name="phoneNumber" type="string" required="true">
        <cfargument name="addressId" type="string" required="false">
        <cfset local.errors = []>
        <!------- First Name ------->
        <cfif trim(arguments.firstName) EQ "">
            <cfset arrayAppend(local.errors, "*First Name is required.")>
        <cfelseif not reFind("^[A-Za-z]+$", trim(arguments.firstName))>
            <cfset arrayAppend(local.errors, "*First Name cannot contain numbers or special characters.")>
        </cfif>
        <!------- Last Name -------->
        <cfif trim(arguments.lastName) EQ "">
            <cfset arrayAppend(local.errors, "*Last Name is required.")>
        <cfelseif not reFind("^[A-Za-z]+(\s[A-Za-z]+)*$", trim(arguments.lastName))>
            <cfset arrayAppend(local.errors, "*Last Name cannot contain numbers or special characters.")>
        </cfif>
        <!-----   Address Line1      ---->
        <cfif trim(arguments.addressLine1) EQ "">
            <cfset arrayAppend(local.errors, "*AddressLine1 is required.")>
        </cfif>
        <!-----   Address Line2      ---->
        <cfif trim(arguments.addressLine2) EQ "">
            <cfset arrayAppend(local.errors, "*AddressLine2 is required.")>
        </cfif>
        <!-----   City      ---->
        <cfif trim(arguments.city) EQ "">
            <cfset arrayAppend(local.errors, "*City is required.")>
        </cfif>
        <!-----   State      ---->
        <cfif trim(arguments.state) EQ "">
            <cfset arrayAppend(local.errors, "*State is required.")>
        </cfif>
        <!-----   Pincode     ---->
        <cfif trim(arguments.pincode) EQ "" OR (NOT isNumeric(arguments.pincode))>
            <cfset arrayAppend(local.errors, "*pincode must be numeric")>
        <cfelseif len(arguments.pincode) GT 8>
            <cfset arrayAppend(local.errors, "*pincode length must be less than 9")>
        </cfif>
        <!-----   PhoneNumber    ---->
        <cfif trim(arguments.phoneNumber) EQ "" OR not reFind("^\d{10}$", arguments.phoneNumber)>
            <cfset arrayAppend(local.errors, "*Phone number must contain exactly 10 digits.")>
        </cfif>
        <cfif arrayLen(local.errors) EQ 0>
            <cfset local.addCatogory=createOrUpdateProfileDetails(argumentCollection=arguments)>
            <cfreturn local.errors>
        <cfelse>
            <cfreturn local.errors>
        </cfif>
    </cffunction>

    <cffunction name="createOrUpdateProfileDetails" access="public">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="addressLine1" type="string" required="true">
        <cfargument name="addressLine2" type="string" required="true">
        <cfargument name="city" type="string" required="true">
        <cfargument name="state" type="string" required="true">
        <cfargument name="pincode" type="string" required="true">
        <cfargument name="phoneNumber" type="string" required="true">
        <cfargument name="addressId" type="string" required="false">
        <cfif StructKeyExists(arguments, "addressId") AND arguments.addressId NEQ "">
            <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.addressId)>
            <cfquery datasource="#application.datasource#">
                UPDATE 
                    tblAddress
                SET 
                    fldFirstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                    fldLastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">,
                    fldAddressLine1 = <cfqueryparam value="#arguments.addressLine1#" cfsqltype="cf_sql_varchar">,
                    fldAddressLine2 = <cfqueryparam value="#arguments.addressLine2#" cfsqltype="cf_sql_varchar">,
                    fldCity = <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar">,
                    fldState = <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar">,
                    fldPincode = <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_varchar">,
                    fldPhonenumber = <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar">,
                    fldCreatedDate  = NOW()
                WHERE
                    fldAddress_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            </cfquery>
        <cfelse>
            <cfquery name="local.qryInsertUserDetails" datasource="#application.datasource#">
                INSERT INTO
                    tbladdress(
                                fldUserId,
                                fldFirstName,
                                fldLastName, 
                                fldAddressLine1,
                                fldAddressLine2,
                                fldCity,
                                fldState,
                                fldPincode,
                                fldPhoneNumber,
                                fldActive
                    )
                VALUES 
                    (
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.addressLine1#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.addressLine2#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.city#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.state#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.pincode#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.phoneNumber#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="1" cfsqltype="cf_sql_integer">
                    )
            </cfquery>
        </cfif>
    </cffunction>

    <cffunction name="getUserAddress" access="public" returntype="any">
        <cfargument name="addressId" type="string" required="false">
        <cfif structKeyExists(arguments, "addressId")>
            <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.addressId)>
        </cfif>
        <cfquery name="local.qryGetAddress" datasource="#application.datasource#">
            SELECT 
                fldAddress_ID,
                fldFirstName,
                fldLastName, 
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhonenumber,
                CONCAT(fldFirstname, ' ', fldLastname) AS fullname
            FROM 
                tblAddress
            WHERE 
                fldActive = 1
                <cfif structKeyExists(session, "userid")>
                    AND  fldUserId = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                </cfif>
                <cfif structKeyExists(arguments, "addressId")>
                    AND fldAddress_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
                </cfif>
        </cfquery>
        <cfreturn local.qryGetAddress>
    </cffunction>

    <cffunction name="getUserAddressById" access="remote" returntype="any" returnformat="JSON">	
		<cfargument name="addressId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.addressId)>
        <cfquery name="local.qryGetEachAddress" datasource="#application.datasource#">
            SELECT 
                fldAddress_ID,
                fldFirstName,
                fldLastName, 
                fldAddressLine1,
                fldAddressLine2,
                fldCity,
                fldState,
                fldPincode,
                fldPhonenumber
            FROM 
                tblAddress
            WHERE 
                fldAddress_ID= <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.qryGetEachAddress> 
    </cffunction>

    <cffunction name="deleteUserAddress" access="remote" returnformat = "JSON">
    	<cfargument name="addressId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.addressId)>
        <cftry>
            <cfquery datasource="#application.datasource#">
                UPDATE tblAddress
                SET 
                    fldActive = <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
                    fldDeactivatedDate = NOW()
                WHERE
                    fldAddress_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfset local.response = {status="success", message="Category deleted successfully."}>
            <cfreturn local.response>
            <cfcatch>
                <cfset local.response = {status="error", message="An error occurred while deleting the category"}>
                <cfreturn local.response>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getUserDetailsById" access="remote" returntype="any" returnformat="JSON">	
        <cfargument name="editUserId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.editUserId)>
        <cfquery name="local.qryGetEachUserDetails" datasource="#application.datasource#">
            SELECT 
                fldUser_ID,
                fldFirstName,
                fldLastName, 
                fldEmail,
                fldPhone
            FROM 
                tblUser
            WHERE 
                fldUser_ID= <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.qryGetEachUserDetails> 
    </cffunction>

    <cffunction  name= "validateUserDetails" access= "remote" returnformat="JSON">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="email" type="string" required="true">
        <cfargument name="phone" type="string" required="true">
        <cfargument name="editUserId" type="string" required="true">
        <cfset local.errors = []>
        <!------- First Name ------->
        <cfif trim(arguments.firstName) EQ "">
            <cfset arrayAppend(local.errors, "*First Name is required.")>
        <cfelseif not reFind("^[A-Za-z]+$", trim(arguments.firstName))>
            <cfset arrayAppend(local.errors, "*First Name cannot contain numbers or special characters.")>
        </cfif>
        <!------- Last Name -------->
        <cfif trim(arguments.lastName) EQ "">
            <cfset arrayAppend(local.errors, "*Last Name is required.")>
		<cfelseif not reFind("^[A-Za-z]+(\s[A-Za-z]+)*$", trim(arguments.lastName))>
            <cfset arrayAppend(local.errors, "*Last Name cannot contain numbers or special characters.")>
        </cfif>
        <!------- Email -------->
        <cfquery name="local.qryCheckUserEmail" datasource="#application.datasource#">
            SELECT *
            FROM 
                tblUser
        	WHERE 
                fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
            AND 
                fldUser_ID <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif len(trim(arguments.email)) EQ 0>
            <cfset arrayAppend(local.errors, "*Email is required")>
        <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            <cfset arrayAppend(local.errors, "*Enter a valid email")>
        <cfelseif local.qryCheckUserEmail.recordCount GT 0>
            <cfset arrayAppend(local.errors, "*Email is already registered.")>
        </cfif>
        <!-----   PhoneNumber    ---->
        <cfquery name="local.qryCheckUserPhone" datasource="#application.datasource#">
            SELECT *
            FROM 
                tblUser
            WHERE
                fldPhone  = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
            AND
                fldUser_ID <> <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif trim(arguments.phone) EQ "" OR not reFind("^\d{10}$", arguments.phone)>
            <cfset arrayAppend(local.errors, "*Phone number must contain exactly 10 digits.")>
        <cfelseif local.qryCheckUserPhone.recordCount GT 0>
            <cfset arrayAppend(local.errors, "*Phone Number is already registered.")>
        </cfif>
        <cfif arrayLen(local.errors) EQ 0>
            <cfset local.addCatogory=UpdateUserDetails(argumentCollection=arguments)>
            <cfreturn local.errors>
        <cfelse>
            <cfreturn local.errors>
        </cfif>
    </cffunction>

    <cffunction name="UpdateUserDetails" access="public">
        <cfargument name="firstName" type="string" required="true">
        <cfargument name="lastName" type="string" required="true">
        <cfargument name="email" type="string" required="true">
        <cfargument name="phone" type="string" required="true">
        <cfargument name="editUserId" type="string" required="true">
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.editUserId)>
        <cfquery datasource="#application.datasource#">
            UPDATE 
                tblUser
            SET 
                fldFirstName = <cfqueryparam value="#arguments.firstName#" cfsqltype="cf_sql_varchar">,
                fldLastName = <cfqueryparam value="#arguments.lastName#" cfsqltype="cf_sql_varchar">,
                fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
                fldPhone = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">,
                fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_varchar">,
                fldUpdatedDate  = NOW()
            WHERE
                fldUser_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cffunction>
<!--------------------------------------Payment Details function------------------------------------------------ ---->
    
    <cffunction  name= "validateCardDetails" access= "remote" returnformat="JSON">
        <cfargument name="cardNumber" type="string" required="true">
        <cfargument name="cvv" type="string" required="true">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="productId" type="string" required="false">
        <cfargument name="totalPrice" type="numeric" required="false">
        <cfargument name="totalTax" type="numeric" required="false">
        <cfset local.errors = []>
        <cfset local.cardCode = "12345678912">
        <!-----   CardNumber     ---->
        <cfif trim(arguments.cardNumber) EQ "" OR (NOT isNumeric(arguments.cardNumber))>
            <cfset arrayAppend(local.errors, "*Card Number must be numeric")>
        <cfelseif len(arguments.cardNumber) GT 11 OR len(arguments.cardNumber) LT 11>
            <cfset arrayAppend(local.errors, "*Card Number length must be exact 11")>
        <cfelseif arguments.cardNumber NEQ local.cardCode>
            <cfset arrayAppend(local.errors, "*Enter a valid Card Number")>
        <cfelse>
            <cfset arguments['cardNumber'] = "8912">
        </cfif>
        <!-----   cvv    ---->
        <cfset local.cvvCode = "123">
        <cfif trim(arguments.cvv) EQ "" OR not reFind("^\d{3}$", arguments.cvv)>
            <cfset arrayAppend(local.errors, "*CVV must contain exactly 3 digits.")>
        <cfelseif arguments.cvv NEQ local.cvvcode>
            <cfset arrayAppend(local.errors, "*Enter a valid CVV.")>
        </cfif>
        <cfif arrayLen(local.errors) EQ 0>
            <cfset local.addCatogory=createOrUpdateCardDetails(argumentCollection=arguments)>
            <cfreturn local.errors>
        <cfelse>
            <cfreturn local.errors>
        </cfif>
    </cffunction>

    <cffunction name="createOrUpdateCardDetails" access="public">
        <cfargument name="cardNumber" type="string" required="true">
        <cfargument name="cvv" type="string" required="true">
        <cfargument name="totalPrice" type="numeric" required="false">
        <cfargument name="totalTax" type="numeric" required="false">
        <cfargument name="unitTax" type="numeric" required="false">
        <cfargument name="unitPrice" type="numeric" required="false">
        <cfargument name="quantity" type="numeric" required="false">
        <cfargument name="addressId" type="string" required="true">
        <cfargument name="productId" type="string" required="false">
        <cfset local.addressDetails = application.modelUserPage.getUserAddress(addressId = addressId)>
        <cfset local.phoneNumber = local.addressDetails.fldPhonenumber>
        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.addressId)>
        <cfset local.Order_ID = createUUID()>
        <cfif arguments.productId EQ "undefined">
            <cfset local.getCartProducts = application.modelUserPage.getCartProductsList()>
            <cfset local.totalPrice = 0>
            <cfset local.totalTax = 0>
            <cfloop query="local.getCartProducts">
                <cfset local.totalPrice =  local.totalPrice + local.getCartProducts.totalPrice>
                <cfset local.totalTax = local.totalTax + local.getCartProducts.totalTax>
            </cfloop>
        </cfif>
        <cftry>
            <cftransaction action="begin">
                <cfquery name="local.qryInsertOrderDetails" result="local.createOrderTableResult" datasource="#application.datasource#">
                    INSERT INTO 
                        tblOrder(
                                fldOrder_ID,
                                fldUserId,
                                fldAddressId,
                                fldTotalPrice,
                                fldTotalTax,
                                fldPhonenumber,
                                fldOrderDate,
                                fldCardPart
                        )
                    VALUES 
                        (
                            <cfqueryparam value="#local.Order_ID#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar" >,
                            <cfif structKeyExists(arguments, "productId") AND structKeyExists(arguments, "quantity") AND NOT arguments.productId EQ "undefined">
                                <cfqueryparam value="#arguments.totalPrice#" cfsqltype="cf_sql_varchar" >,
                                <cfqueryparam value="#arguments.totalTax#" cfsqltype="cf_sql_varchar" >,
                            <cfelse>
                                <cfqueryparam value="#local.totalPrice#" cfsqltype="cf_sql_varchar" >,
                                <cfqueryparam value="#local.totalTax#" cfsqltype="cf_sql_varchar" >,
                            </cfif>
                            <cfqueryparam value="#local.phoneNumber#" cfsqltype="cf_sql_varchar" >,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_timestamp" >,
                            <cfqueryparam value="#arguments.cardNumber#" cfsqltype="cf_sql_varchar" >
                        )
                </cfquery>
                <cfif local.createOrderTableResult.recordCount EQ 1>
                    <cfif structKeyExists(arguments, "productId") AND structKeyExists(arguments, "quantity") AND NOT arguments.productId EQ "undefined">
                        <cfset local.orderAddResult = addOrderItems(
                            orderId = local.Order_ID,
                            productId = arguments.productId,
                            quantity = arguments.quantity,
                            unitPrice = arguments.unitPrice,
                            unitTax = arguments.unitTax
                        )>
                    <cfelse>    
                        <cfset local.orderAddResult = addOrderItems(
                            orderId = local.Order_ID
                        )>
                        <cfif local.orderAddResult EQ "success">
                            <cfquery datasource="#application.datasource#">
                                DELETE 
                                FROM tblCart
                                WHERE
                                    fldUserId = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                            </cfquery>
                        </cfif>
                    </cfif>
                    <cfset local.sendMail = application.modelOrderPage.sendMailToUserAddress(orderId = local.Order_ID)>
                </cfif>
            <cftransaction action="commit">
            <cfcatch>
                <cftransaction action="rollback">
                <cfset local.errorMessage = "Error occurred: " & cfcatch.message>
                <cflog file="payment_errors" type="error" text="#local.errorMessage#">
            </cfcatch>
          </cftry>
    </cffunction>

    <cffunction name="addOrderItems" access="public" returntype="any">
        <cfargument name="orderId" type="string" required="true">
        <cfargument name="productId" type="string" required="false">
        <cfargument name="quantity" type="numeric" required="false">
        <cfargument name="unitPrice" type="numeric" required="false">
        <cfargument name="unitTax" type="numeric" required="false">
        <cfif structKeyExists(arguments, "productId") AND structKeyExists(arguments, "quantity") AND NOT arguments.productId EQ "undefined">
            <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
            <cfquery name="local.qryOrderSingleItemsTable" datasource="#application.datasource#">
                INSERT INTO 
                    tblorderItems(
                                fldOrderId,
                                fldProductId,
                                fldQuantity,
                                fldUnitPrice,
                                fldUnitTax
                    )
                VALUES 
                    (
                        <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_varchar">,
                        <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.quantity#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.unitPrice#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.unitTax#" cfsqltype="cf_sql_varchar" >
                    )
            </cfquery>
        <cfelse>
            <cfset local.getCartProducts = application.modelUserPage.getCartProductsList()>
            <cfloop query="local.getCartProducts">
                <cfquery name="local.qryOrderCartItemsTable" datasource = "#application.datasource#" >
                    INSERT INTO 
                        tblorderItems(
                                    fldOrderId,
                                    fldProductId,
                                    fldQuantity,
                                    fldUnitPrice,
                                    fldUnitTax
                        )
                    VALUES 
                        (
                            <cfqueryparam value="#arguments.orderId#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#local.getCartProducts.idProduct#" cfsqltype="cf_sql_integer">,
                            <cfqueryparam value="#local.getCartProducts.fldQuantity#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#local.getCartProducts.fldPrice#" cfsqltype="cf_sql_varchar">,
                            <cfqueryparam value="#local.getCartProducts.fldTax#" cfsqltype="cf_sql_varchar">
                        )
                </cfquery>
            </cfloop>
            <cfreturn "success">
        </cfif>
    </cffunction>
</cfcomponent>