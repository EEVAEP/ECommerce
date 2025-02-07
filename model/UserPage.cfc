<cfcomponent>

    <cffunction name="decryptId" access="public" returntype="string" output="false">
    	<cfargument name="encryptedId" type="string" required="true">
    	<cfset local.decryptedId = decrypt(arguments.encryptedId, application.encryptionKey, "AES", "Hex")>
    	<cfreturn local.decryptedId>
	</cffunction>

    <cffunction  name="getRandomProducts" access="public" returntype="query">
       
        <cfquery name="local.qryRandomProducts">
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

    

</cfcomponent>