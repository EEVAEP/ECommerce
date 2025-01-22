<cfcomponent>

    <cffunction name="decryptId" access="public" returntype="string" output="false">
    	<cfargument name="encryptedId" type="string" required="true">
    	<cfset local.decryptedId = decrypt(arguments.encryptedId, application.encryptionKey, "AES", "Hex")>
    	<cfreturn local.decryptedId>
	</cffunction>

    <cffunction  name="getNavCategories" access="public" returntype="any">
        <cfargument name="categoryId" type="string" required="false">
        <cfquery name="local.qryCategory">
            SELECT 
                    fldCategory_ID,
                    fldCategoryName
                FROM 
                    tblCategory
                WHERE 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">  
                <cfif structKeyExists(arguments, "categoryId")>
                    AND fldCategory_ID = <cfqueryparam value = "#arguments.categoryId#" cfsqltype = "cf_sql_integer">               
                </cfif>
        </cfquery>

        <cfreturn local.qryCategory>
    </cffunction>

    <cffunction  name="getNavSubCategories" access="public" returntype="any">
        <cfargument name="categoryId" type="string" required="true">
        <cfargument name="subCategoryId" type="string" required="false">

        <cfset local.decryptedId = decryptId(arguments.categoryId)>
        <cfquery name="local.qrySubCategory">
            SELECT 
                    fldSubCategory_ID,
                    fldSubCategoryName
                FROM 
                    tblSubCategory
                WHERE 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer"> 
                AND 
                    fldCategoryId = <cfqueryparam value = "#local.decryptedId#" cfsqltype = "cf_sql_integer"> 
                
        </cfquery>

       <cfreturn local.qrySubCategory>
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