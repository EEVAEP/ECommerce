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
                P.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
	            I.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">

            ORDER BY RAND()
            LIMIT 4
        </cfquery>
        <cfreturn local.qryRandomProducts>
    </cffunction>


    <cffunction name="createCartProducts" access="public" returntype="any">
        <cfargument name="productId" type="string" required="true">

        <cfset local.decryptedId = application.modelAdminCtg.decryptId(arguments.productId)>
        <cfquery name="local.insertProductIntoCart" result="local.insertProductIntoCart" datasource = "#application.datasource#">
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
                (P.fldPrice + (P.fldPrice * (P.fldTax / 100))) AS priceWithTax,
                SUM(P.fldPrice) AS actualPrice,
                SUM(fldPrice * (fldTax / 100)) AS totalTax,
                SUM(P.fldPrice + (P.fldPrice * (P.fldTax / 100))) AS totalPrice
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
               P.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND 
                I.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
	            I.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
             GROUP BY
                P.fldProductName,
                P.fldProduct_ID,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName
        </cfquery>
        <cfreturn local.qryDisplayCartProducts>
    </cffunction>

</cfcomponent>