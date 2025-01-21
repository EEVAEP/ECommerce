<cfcomponent>

    <cffunction  name="getNavCategories" access="public" returntype="any">
        <cfquery name="local.qryCategoryAndSubCategory">
            SELECT 
                C.fldCategoryName, SC.fldSubCategoryName
            FROM 
                tblcategory AS C
            LEFT JOIN 
                tblsubcategory AS SC
            ON 
                SC.fldCategoryId = C.fldCategory_ID
            WHERE 
                C.fldActive = 1
            AND 
                SC.fldActive = 1
            ORDER BY 
                C.fldCategoryName
        </cfquery>

       
        <cfreturn local.qryCategoryAndSubCategory>
    </cffunction>

</cfcomponent>