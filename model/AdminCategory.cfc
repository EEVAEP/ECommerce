<cfcomponent>
    
    <cffunction name="decryptId" access="public" returntype="string" output="false">
    		<cfargument name="encryptedId" type="string" required="true">
    		<cfset local.decryptedId = decrypt(arguments.encryptedId, application.encryptionKey, "AES", "Hex")>
    		<cfreturn local.decryptedId>
	</cffunction>


    <cffunction  name= "validateCategoryDetails" access= "remote" returnformat="JSON">
        <cfargument name="categoryName" type="string" required="true">
        <cfargument name="categoryId" type="string" required="false">

        <cfset local.errors = []>

        <cfif trim(arguments.categoryName) EQ "">
            <cfset arrayAppend(local.errors, "*The category Name should not be empty")>
        </cfif>

        <cfquery name="local.checkCategoryName">
            SELECT 
                fldCategoryName 
            FROM 
                tblcategory 
            WHERE 
                fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">
            AND
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfif local.checkCategoryName.recordcount GT 0>
            <cfset arrayAppend(local.errors, "*This category already exists")>
        </cfif>

        <cfif arrayLen(local.errors) EQ 0>
			<cfset local.addCatogory = createOrUpdateCategory(argumentCollection = arguments)>
			<cfreturn local.errors>
		<cfelse>
			<cfreturn local.errors>
		</cfif>
    </cffunction>


    <cffunction name="createOrUpdateCategory" access="public">
        <cfargument name="categoryName" type="string" required="true">
        <cfargument name="categoryId" type="string" required="false">
        
        <cfif StructKeyExists(arguments, "categoryId") AND arguments.categoryId NEQ "">
            <cfset local.decryptedId = decryptId(arguments.categoryId)>
            <cfquery>
        			UPDATE tblcategory
				SET 
					fldCategoryName = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar">,
                    fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                    fldUpdatedDate = NOW()
                WHERE
                    fldCategory_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

            </cfquery>
        <cfelse>
            <cfquery name="local.insertCategory">
                INSERT INTO tblcategory 
                    (fldCategoryName, fldCreatedById)
                VALUES 
                    (
                        <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    )
            </cfquery>
        </cfif>
    </cffunction>


    <cffunction name="getCategoryList" access="public" returntype="query">
        <cfquery name="local.categoryList">
            SELECT 
                fldCategoryName, 
                fldCategory_ID AS idCategory
            FROM 
                tblcategory
            WHERE 
                fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn local.categoryList>
    </cffunction>


    <cffunction name="getCategoryById" access="remote" returntype="any" returnformat="JSON">	
		<cfargument name="categoryById" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.categoryById)>
        
        <cfquery name="local.getEachCategoryId">
            SELECT 
                fldCategory_ID, fldCategoryName 
            FROM 
                tblcategory
            WHERE 
                fldCategory_ID= <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.getEachCategoryId> 
    </cffunction>



    <cffunction name="deleteCategory" access="remote" returnformat = "JSON">
    	<cfargument name="categoryId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.categoryId)>
    
    	<cftry>
			
			<cfquery>
        		UPDATE tblcategory
				SET 
                    fldActive = <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
                    fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                    fldUpdatedDate = NOW()
                WHERE
                    fldCategory_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

            </cfquery>
			
       		<cfset local.response = {status="success", message="Category deleted successfully."}>
        	<cfreturn local.response>
    		<cfcatch>
				<cfset local.response = {status="error", message="An error occurred while deleting the category"}>
        		<cfreturn local.response>
    		</cfcatch>
		</cftry>
        
	</cffunction>

    <!--------------------------- Admin Dashboard SubCategories functions ------------------------------------------------>
    <!---------------------------------------------------------------------------------------------------------------- --->
    
    
    <cffunction  name= "validateSubCategoryDetails" access= "remote" returnformat="JSON">
        <cfargument name="categoryName" type="numeric" required="true">
        <cfargument name="subCategoryName" type="string" required="true">
        <cfargument name="subCategoryId" type="string" required="false">

        <cfset local.errors = []>

        <cfif NOT len(arguments.categoryName)>
            <cfset arrayAppend(local.errors, "*Please select a category")>
        </cfif>

        <cfif trim(arguments.subCategoryName) EQ "">
            <cfset arrayAppend(local.errors, "*The SubCategory Name should not be empty")>
        </cfif>

        <cfif NOT structKeyExists(arguments, 'subCategoryId')>
            <cfquery name="local.checkSubCategoryName">
                SELECT 
                    fldSubCategoryName 
                FROM 
                    tblsubcategory 
                WHERE 
                    fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">
                AND
                    fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfif local.checkSubCategoryName.recordcount GT 0>
                <cfset arrayAppend(local.errors, "*This SubCategory already exists")>
            </cfif>
        </cfif>

        <cfif arrayLen(local.errors) EQ 0>
			<cfset local.addCatogory=createOrUpdateSubCategory(argumentCollection=arguments)>
			<cfreturn local.errors>
		<cfelse>
		    <cfreturn local.errors>
		</cfif>
        <cfreturn local.errors>
    </cffunction>


    <cffunction name="createOrUpdateSubCategory" access="public">
        <cfargument name="categoryName" type="numeric" required="true">
        <cfargument name="subCategoryName" type="string" required="false">
        <cfargument name="subCategoryId" type="string" required="false">
        
        <cfif StructKeyExists(arguments, "subCategoryId") AND arguments.subCategoryId NEQ "">
            <cfset local.decryptedId = decryptId(arguments.subCategoryId)>
            <cfquery>
        			UPDATE tblsubcategory
				SET 
                    fldCategoryId = <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_integer">,
					fldSubCategoryName = <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar">,
                    fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                    fldUpdatedDate = NOW()
                WHERE
                    fldSubCategory_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

            </cfquery>
        <cfelse>
            <cfquery name="local.insertSubCategory">
            INSERT INTO tblsubcategory 
                (fldCategoryId, fldSubCategoryName, fldCreatedById)
            VALUES 
                (
                    <cfqueryparam value="#arguments.categoryName#" cfsqltype="cf_sql_integer" >,
                    <cfqueryparam value="#arguments.subCategoryName#" cfsqltype="cf_sql_varchar" >,
                    <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                )
        </cfquery>
       </cfif>
    </cffunction>


    <cffunction  name="listSubCategories" access="public">
        <cfargument name="categoryId" type="string" required="true">

        <cfset local.decryptedId = decryptId(arguments.categoryId)>
        <cfquery name="local.getSubCategoriesList">
            SELECT 
                SC.fldSubCategoryName,
                SC.fldSubCategory_ID AS idSubCategory,
                C.fldCategoryName
            FROM 
                tblsubCategory AS SC
            INNER JOIN 
                tblcategory AS C
             ON 
                C.fldCategory_ID = SC.fldCategoryId
            WHERE 
                SC.fldCategoryId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            AND
                SC.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
                C.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfreturn local.getSubCategoriesList>

    </cffunction>


    <cffunction name="getSubCategoryById" access="remote" returntype="any" returnformat="JSON">	
		<cfargument name="subCategoryById" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.subCategoryById)>
        
        <cfquery name="local.getEachSubCategoryId">
            SELECT 
                SC.fldSubCategory_ID,
                SC.fldSubCategoryName,
                C.fldCategoryName,
                C.fldCategory_ID
            FROM 
                tblsubcategory AS SC
            INNER JOIN 
                tblcategory AS C
            ON 
                C.fldCategory_ID = SC.fldCategoryId
            WHERE 
                SC.fldSubCategory_ID = <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.getEachSubCategoryId> 
    </cffunction>



    <cffunction name="deleteSubCategory" access="remote" returnformat = "JSON">
    	<cfargument name="subCategoryId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.subCategoryId)>
    
    	<cftry>
			
			<cfquery>
        			UPDATE tblsubcategory
				    SET 
                        fldActive = <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
                        fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        fldUpdatedDate = NOW()
            </cfquery>
			
       		<cfset local.response = {status="success", message="SubCategory deleted successfully."}>
        	<cfreturn local.response>
    		<cfcatch>
				<cfset local.response = {status="error", message="An error occurred while deleting the SubCategory."}>
        		<cfreturn local.response>
    		</cfcatch>
		</cftry>
        
	</cffunction>

<!--- ----------------------------------------- Product Page functions -------------------------------------------- --->
<!---------------------------------------------------------------------------------------------------------------->

    <cffunction name="getSubCategoryName" access="public" returntype="query">
        	<cfquery name="local.subCategoryName">
            		SELECT 
				        fldSubCategory_ID,
                        fldSubCategoryName
			        FROM 
				        tblsubcategory
                    WHERE
                        fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        	</cfquery>
        	<cfreturn local.SubCategoryName>
    </cffunction>

    <cffunction name="getProductBrandName" access="public" returntype="query">
        	<cfquery name="local.BrandName">
            		SELECT 
				        fldBrand_ID,
                        fldBrandName
			        FROM 
				        tblbrands
                    WHERE
                        fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        	</cfquery>
        	<cfreturn local.BrandName>
    </cffunction>


    <cffunction name="getProductImageCount" access="private" returntype="any">
        <cfargument name="productId" type="string" required="true">
        <cfquery name="local.ProductImgCount">
            SELECT 
                fldProductImage_ID
            FROM 
                tblproductimages
            WHERE
                fldProductId = <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">

        </cfquery>
        <cfif local.ProductImgCount.recordCount GT 0>
            <cfreturn local.ProductImgCount.recordCount>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>

    
    <cffunction  name= "validateProductDetails" access= "remote" returnformat="JSON" >
        <cfargument name="categoryId" type="numeric" required="true">
        <cfargument name="subCategoryId" type="numeric" required="true">
        <cfargument name="productName" type="string" required="true">
        <cfargument name="productBrand" type="numeric" required="true">
        <cfargument name="productDescription" type="string" required="true">
        <cfargument name="productPrice" type="numeric" required="true">
        <cfargument name="productTax" type="numeric" required="true">
        <cfargument name="productImg" type="any" required="false">
        <cfargument name="productId" type="string" required="false">
        
        
        <cfset local.errors = []>

        <cfif NOT len(arguments.categoryId)>
            <cfset arrayAppend(local.errors, "*Please select a category")>
        </cfif>


        <cfif NOT len(arguments.subCategoryId)>
            <cfset arrayAppend(local.errors, "*Please select a SubCategory")>
        </cfif>


        <!--- Product Name validation--->
        <cfif trim(arguments.productName) EQ "">
            <cfset arrayAppend(local.errors, "*The product Name should not be empty")>
        <cfelse>
            <cfif NOT structKeyExists(arguments, "productId")>
                <cfquery name="local.checkProductName">
                    SELECT 
                        fldProductName 
                    FROM 
                        tblproduct 
                    WHERE 
                        fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">
                </cfquery>

                <cfif local.checkProductName.recordcount GT 0>
                    <cfset arrayAppend(local.errors, "*This Product already exists")>
                </cfif>
            </cfif>
        </cfif>


         <cfif NOT len(arguments.productBrand)>
            <cfset arrayAppend(local.errors, "*Please select a Product Brand")>
        </cfif>

       
        <!--- Product Description validation--->
        <cfif trim(arguments.productDescription) EQ "">
            <cfset arrayAppend(local.errors, "*The product Description should not be empty")>
        </cfif>

        <!--- Product Price validation--->
        <cfif trim(arguments.productPrice) EQ "">
            <cfset arrayAppend(local.errors, "*The product Price should not be empty")>
        </cfif>

        <!--- Product Tax validation--->
        <cfif trim(arguments.productTax) EQ "">
            <cfset arrayAppend(local.errors, "*The product Tax should not be empty")>
        </cfif>


        <!--- Product Image validation--->

        <cfif structKeyExists(arguments, "productImg") AND len(arguments.productImg) GT 0 >
       
    
            <cfset local.uploadPath = ExpandPath('../uploads/')>
            <cfset local.allowedFormats = "jpg,jpeg,png,jfif">
            
            <cfset local.uploadedImagePath = []>
            
    
        
            <cffile action="uploadAll" 
                fileField="#arguments.productImg#" 
                destination="#local.uploadPath#"
                nameConflict="makeUnique" 
                result="local.fileUploadResult">

           


            <cfloop array = "#local.fileUploadResult#" index = "i" item = "image">
                <cfset local.maxImgSize = 5*1024*1024>
                <cfif image.fileSize GT local.maxImgSize>
                    <cfset arrayAppend(local.errors, "*The size of  image #i# is greater")>
                </cfif>
                <cfif NOT listFindNoCase(local.allowedFormats,"#image.CLIENTFILEEXT#")>
                    <cfset arrayAppend(local.errors,"*Image #image.CLIENTFILE# should be jpeg or png or gif format")>
                </cfif>
                    <cfset arrayAppend(local.uploadedImagePath, image.SERVERFILE)>
                    
            </cfloop>
            <cfset arguments['productImg'] = local.uploadedImagePath>
            
        

        </cfif>   
        
           
        <cfif arrayLen(local.errors) EQ 0>
			<cfset local.addCatogory=createOrUpdateProduct(argumentCollection=arguments)>
			<cfreturn local.errors>
		<cfelse>
		    <cfreturn local.errors>
		</cfif>
        <cfreturn local.errors>
    </cffunction>

    
    <cffunction name="createOrUpdateProduct" access="public">
        <cfargument name="categoryId" type="numeric" required="true">
        <cfargument name="subCategoryId" type="numeric" required="true">
        <cfargument name="productName" type="string" required="true">
        <cfargument name="productBrand" type="numeric" required="true">
        <cfargument name="productDescription" type="string" required="true">
        <cfargument name="productPrice" type="numeric" required="true">
        <cfargument name="productTax" type="numeric" required="true">
        <cfargument name="productId" type="string" required="false">
        <cfargument name="productImg" type="array" required="false">

        
        <cfif StructKeyExists(arguments, "productId") AND arguments.productId NEQ "">
            <cfset local.decryptedId = decryptId(arguments.productId)>
                <cfquery result = "local.qryEditProduct">
        		    UPDATE tblproduct
				    SET 
                        fldProductName = <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar">,
                        fldSubCategoryId = <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer">,
					    fldBrandId = <cfqueryparam value="#arguments.productBrand#" cfsqltype="cf_sql_integer">,
                        fldDescription = <cfqueryparam value="#arguments.productDescription#" cfsqltype="cf_sql_varchar">,
                        fldPrice = <cfqueryparam value = "#arguments.productPrice#" cfsqltype = "cf_sql_decimal">,
                        fldTax = <cfqueryparam value = "#arguments.productTax#" cfsqltype = "cf_sql_decimal">,
                        fldUpdatedById = <cfqueryparam value = "#session.userid#" cfsqltype ="cf_sql_integer" >,
                        fldUpdatedDate = <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                    WHERE
                        fldProduct_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

                </cfquery>

                <cfif local.qryEditProduct.recordCount EQ 1>
                    <cfif structKeyExists(arguments, 'productImg')>
                        <cfset local.newAddedImg = addImage(
                            productId = local.decryptedId,
                            productImages = arguments.productImg          
                        )>
                    </cfif>
                </cfif>
       <cfelse>
            <cfquery name="local.insertProduct" result="local.insertProductResult">
                INSERT INTO tblproduct
                    (fldSubCategoryId, fldProductName, fldBrandId, fldDescription, fldPrice, fldTax, fldCreatedById)
                VALUES 
                    (
                        <cfqueryparam value="#arguments.subCategoryId#" cfsqltype="cf_sql_integer" >,
                        <cfqueryparam value="#arguments.productName#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.productBrand#" cfsqltype="cf_sql_integer" >,
                        <cfqueryparam value="#arguments.productDescription#" cfsqltype="cf_sql_varchar" >,
                        <cfqueryparam value="#arguments.productPrice#" cfsqltype="cf_sql_decimal" >,
                        <cfqueryparam value="#arguments.productTax#" cfsqltype="cf_sql_decimal" >,
                        <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
                    )
            </cfquery>

            <cfif local.insertProductResult.recordCount EQ 1>
                <cfset local.imageAddResult = addImage(
                    productId = local.insertProductResult.GENERATEDKEY,
                    productImages = arguments.productImg
                )>
            </cfif>

        
       </cfif>
    
    </cffunction>


    <cffunction name = "addImage" access = "private" returntype = "any">
        <cfargument  name = "productId" type = "string" required = "true">
        <cfargument name = "productImages" type = "array" required = "true">
        <cftry>
            <cfset local.productImageCount = getProductImageCount(productId = arguments.productId)>
            <cfloop array = "#arguments.productImages#" index = "i" item = "image">
                <cfquery result = "local.qryAddImage">
                    INSERT INTO
                        tblProductImages(
                                            fldProductId,
                                            fldImageFileName,
                                            fldDefaultImage,
                                            fldCreatedById,
                                            fldDeactivatedById,
                                            fldDeactivatedDate
                                            
                                        )
                    VALUES(
                            <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#image#" cfsqltype = "cf_sql_varchar">,
                            <cfif i EQ 1 AND local.productImageCount LT 3>
                                <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfelse>
                                <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">,
                            </cfif>
                            <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#now()#" cfsqltype = "cf_sql_date" >
                            
                        )
                </cfquery>
            </cfloop>
            
        <cfcatch>
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>


    <cffunction  name="listProducts" access="public">
        <cfargument name="subCategoryId" type="string" required="true">
        <cfargument name="sortOrder" type="string" required="false">
        <cfargument name="minPrice" type="numeric" required="false">
        <cfargument name="maxPrice" type="numeric" required="false">

       <cfset local.decryptedId = decryptId(arguments.subCategoryId)>
        <cfquery name="local.getProductList">
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
                P.fldSubCategoryId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            AND
                P.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
	            I.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">

            <cfif structKeyExists(arguments, "minPrice") AND structKeyExists(arguments, "maxPrice")>
                AND P.fldPrice  BETWEEN <cfqueryparam value="#arguments.minPrice#" cfsqltype="cf_sql_integer">
                AND <cfqueryparam value="#arguments.maxPrice#" cfsqltype="cf_sql_integer"> 
            </cfif>

            <cfif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "asc">
                ORDER By
                    P.fldPrice ASC
            </cfif>

            <cfif structKeyExists(arguments, "sortOrder") AND arguments.sortOrder EQ "desc">
                ORDER By
                    P.fldPrice DESC
            </cfif>
            
        </cfquery>
        
        <cfreturn local.getProductList>

    </cffunction>


    <cffunction name = "getProductImages" access = "public" returntype = "any">
        <cfargument name = "productId" type = "string" required = "true">
        <cfset local.decryptedId = decryptId(arguments.productId)>
        
            <cfquery name = "local.qryGetProductImages">
                SELECT 
                    fldProductImage_ID,
                    fldImageFileName,
                    fldDefaultImage
                FROM 
                    tblproductimages
                WHERE
                    fldProductId = <cfqueryparam value = "#local.decryptedId#" cfsqltype = "cf_sql_integer">
                AND 
                    fldActive = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
            </cfquery>
            <cfif local.qryGetProductImages.recordCount GE 3>
                <cfreturn local.qryGetProductImages>
            <cfelse>
                <cfreturn "Failed">
            </cfif>
            
    </cffunction>

     <cffunction name="getProductById" access="public" returntype="query">	
		<cfargument name="productId" type="string" required="false">
        <cfargument name="searchText" type="string" required="false">

        <cfif structKeyExists(arguments, "productId")>
            <cfset local.decryptedId = decryptId(arguments.productId)>
        </cfif>
		
        
        <cfquery name="local.getEachProductId">
            SELECT 
                P.fldProduct_ID,
                SC.fldCategoryId,
                SC.fldSubCategory_ID,
                P.fldProductName,
                P.fldBrandId,
                P.fldDescription,
                P.fldPrice,
                P.fldTax,
                B.fldBrandName,
                I.fldImageFileName
            FROM 
                tblproduct AS P
            INNER JOIN 
                tblSubCategory AS SC
            ON 
                SC.fldSubCategory_ID = P.fldSubCategoryId
            INNER JOIN 
                tblproductImages AS I
            ON 
                I.fldProductId = P.fldProduct_ID
            INNER JOIN 
                tblbrands AS B
            ON 
               B.fldBrand_ID =  P.fldBrandId
            WHERE
                 P.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            <cfif structKeyExists(arguments, "productId")>
                AND
                    P.fldProduct_ID = <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
            </cfif>
            <cfif structKeyExists(arguments, "searchText") AND len(arguments.searchText)>
                AND (P.fldDescription LIKE "%#arguments.searchText#%" 
                OR B.fldBrandName LIKE "%#arguments.searchText#%" 
                OR P.fldProductName LIKE "%#arguments.searchText#%"
                OR SC.fldSubCategoryName LIKE "%#arguments.searchText#%")
            </cfif>
            
            AND
	            I.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
                I.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.getEachProductId> 
    </cffunction>
    


    <cffunction name="deleteproduct" access="remote" returnformat = "JSON">
    	<cfargument name="productId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.productId)>
    
    	<cftry>
			
			<cfquery>
        			UPDATE tblProduct
				    SET 
                        fldActive = <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
                        fldUpdatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">,
                        fldUpdatedDate = NOW()
                    WHERE
                        fldProduct_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

            </cfquery>
			
       		<cfset local.response = {status="success", message="Product deleted successfully."}>
        	<cfreturn local.response>
    		<cfcatch>
				<cfset local.response = {status="error", message="An error occurred while deleting the product."}>
        		<cfreturn local.response>
    		</cfcatch>
		</cftry>
        
	</cffunction>



    <!--- --------------------------Product Image delete ---------------------------------------------- --->

        <cffunction  name="deleteImage" access = "public" returntype = "string">
        <cfargument  name="imageId" type = "integer" required = "true">
        <cfargument  name="productId" type = "string" required = "true">
        <cftry>

            <cfset local.decryptedId = decryptId(arguments.productId)>
            <cfset local.productImageCount  = getProductImageCount(productId = local.decryptedId )>
            
            <cfif local.productImageCount LE 3 >
                <cfreturn "*Atleast 3 Images required" >
            <cfelse>
                <cfquery name = "local.qryCheckDefaultImg">
                    SELECT
                        fldDefaultImage
                    FROM 
                        tblproductimages
                    WHERE
                        fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_varchar">
                </cfquery>
                
                <cfif local.qryCheckDefaultImg.fldDefaultImage EQ 1>
                   
                    <cfset local.imageDeleteResult = imageDeleteFunction(imageId = arguments.imageId)>
                    
                    <cfif local.imageDeleteResult EQ 1>
                        <cfset local.newDafaultImageId = arguments.imageId + 1 >
                        
                        <cfquery name = "local.qryChangeDefaultImage">
                            UPDATE 
                                tblproductimages
                            SET 
                                fldDefaultImage = <cfqueryparam value = "1" cfsqltype = "cf_sql_integer">
                            WHERE
                                fldProductImage_ID = <cfqueryparam value = "#local.newDafaultImageId#" cfsqltype = "cf_sql_tinyint">
                            AND 
                                fldCreatedById = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
                        </cfquery>  
                        <cfreturn "Success">                    
                    <cfelse>
                        <cfreturn  "Image edit Failed">
                    </cfif>
                <cfelse>
                    <cfset local.imageDeleteResult = imageDeleteFunction(imageId = arguments.imageId )>
                    <cfif local.imageDeleteResult EQ 1>
                        <cfreturn "Success">
                    <cfelse>
                        <cfreturn "Image edit Failed" >
                    </cfif>              
                </cfif>
            </cfif>
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>


    <cffunction  name="imageDeleteFunction" access = "private" returntype = "any">
        <cfargument name = "imageId" type = "integer" required = "true">
        <cftry>
            <cfquery result = "local.qryImageDelete">
                DELETE FROM 
                    tblproductimages
                WHERE
                    fldProductImage_ID = <cfqueryparam value = "#arguments.imageId#" cfsqltype = "cf_sql_integer">
                AND fldCreatedById = <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
            </cfquery> 
            <cfreturn local.qryImageDelete.recordCount >      
        <cfcatch type="exception">
            <cfdump var = "#cfcatch#">
        </cfcatch>
        </cftry>
    </cffunction>


<!--------- --------------------------------Display Product Details----------------------------------->

    <cffunction name="getProductDetails" access="remote" returnformat="JSON">	
		<cfargument name="productId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.productId)>
        
        <cfquery name="local.getDisplayProduct">
            SELECT 
                P.fldProductName,
                P.fldProduct_ID AS idProduct,
                SC.fldSubCategoryName,
                B.fldBrandName,
                P.fldPrice,
                P.fldTax,
                I.fldDefaultImage,
                I.fldImageFileName,
                P.fldDescription
            FROM 
                tblproduct AS P
            INNER JOIN 
                tblsubcategory AS SC
             ON 
                SC.fldSubCategory_ID = P.fldSubCategoryId
            INNER JOIN 
                tblbrands AS B
            ON 
                B.fldBrand_ID = P.fldBrandId
            INNER JOIN 
                tblproductImages AS I
            ON 
                I.fldProductId = P.fldProduct_ID
            WHERE 
                P.fldProduct_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            AND
                P.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
	            I.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            
        </cfquery>
        <cfreturn local.getDisplayProduct> 
    </cffunction>

</cfcomponent>