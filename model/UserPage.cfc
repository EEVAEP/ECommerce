<cfcomponent>

    <cffunction  name="getRandomProducts" access="public" returntype="query">
       <cfquery name="local.qryRandomProducts" datasource = "#application.datasource#">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                SC.fldSubCategoryName,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName
            FROM 
                tblproduct AS P
            INNER JOIN 
                tblsubcategory AS SC
             ON 
                SC.fldSubCategory_ID =  P.fldSubCategoryId
            INNER JOIN 
                tblbrands AS B
            ON 
               B.fldBrand_ID =  P.fldBrandId
            INNER JOIN 
                tblproductImages AS I
            ON 
                I.fldProductId = P.fldProduct_ID
            WHERE 
                P.fldActive = 1
            AND
	            I.fldDefaultImage = 1

            ORDER BY RAND()
            LIMIT 4
        </cfquery>
        <cfreturn local.qryRandomProducts>
    </cffunction>


    <cffunction name="createCartProducts" access="public" returntype="any">
        <cfargument name="productId" type="string" required="true">

        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
         <cfquery name="local.qryCheckProduct" datasource="#application.datasource#">
            SELECT 
                COUNT(*) AS ProductCount
            FROM 
                tblcart
            WHERE 
                fldUserId = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
            AND 
                fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar">
        </cfquery>
        <cfif local.qryCheckProduct.ProductCount EQ 0>
            <cfquery name="local.qryInsertProductIntoCart" result="local.insertProductIntoCart" datasource = "#application.datasource#">
                INSERT INTO tblcart
                    (fldUserId, fldProductId, fldQuantity, fldCreatedDate)
                VALUES 
                    (
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">,
                        <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    )
            </cfquery>
        </cfif>
        <cfreturn "success">
    </cffunction>


    <cffunction name="getCartProductsCount" access="public" returntype="any">
       <cfquery name="local.qryCartCount" datasource = "#application.datasource#">
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
       <cfquery name="local.qryDisplayCartProducts" datasource = "#application.datasource#">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName,
                C.fldQuantity,
                ((P.fldPrice + (P.fldPrice * (P.fldTax / 100))) * C.fldQuantity) AS priceWithTax,
                SUM(P.fldPrice * C.fldQuantity) AS actualPrice,
                SUM((fldPrice * (fldTax / 100)) * C.fldQuantity) AS totalTax,
                SUM((P.fldPrice + (P.fldPrice * (P.fldTax / 100))) * C.fldQuantity) AS totalPrice
            FROM 
                tblproduct AS P
            INNER JOIN 
                tblcart AS C
             ON 
                C.fldProductId =  P.fldProduct_ID
            INNER JOIN 
                tblbrands AS B
            ON 
               B.fldBrand_ID =  P.fldBrandId
            INNER JOIN 
                tblproductImages AS I
            ON 
                I.fldProductId = P.fldProduct_ID
            WHERE 
               P.fldActive = 1
            AND 
                I.fldActive = 1
            AND
	            I.fldDefaultImage = 1
            AND
	            C.fldQuantity >= 1
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
			<cfquery datasource = "#application.datasource#">
        			DELETE 
				    FROM 
                        tblCart
                    WHERE
                        fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
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
                    <cfquery datasource="#application.datasource#" >
                        DELETE 
                        FROM 
                            tblCart
                        WHERE fldProductId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
                    </cfquery>
                    <cfset local.response = {status="success", message="Product removed from the cart."}>
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

</cfcomponent>