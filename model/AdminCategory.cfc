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
			<cfset local.addCatogory=createOrAddCategory(argumentCollection=arguments)>
			<cfreturn local.errors>
		<cfelse>
			<cfreturn local.errors>
		</cfif>
    </cffunction>


    <cffunction name="createOrAddCategory" access="public">
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
                fldCreatedById = <cfqueryparam value="#session.userid#" cfsqltype="cf_sql_integer">
            AND
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
			
       		<cfset local.response = {status="success", message="Contact deleted successfully."}>
        	<cfreturn local.response>
    		<cfcatch>
				<cfset local.response = {status="error", message="An error occurred while deleting the contact."}>
        		<cfreturn local.response>
    		</cfcatch>
		</cftry>
        
	</cffunction>

    <!--------------------------- Admin Dashboard SubCategories functions ------------------------------------------------>
    <!---------------------------------------------------------------------------------------------------------------- --->
    
    
    
    <cffunction name="getCategoryName" access="public" returntype="query">
        	<cfquery name="local.categoryName">
            		SELECT 
				        fldCategory_ID,
                        fldCategoryName
			        FROM 
				        tblcategory
                    WHERE
                        fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        	</cfquery>
        	<cfreturn local.categoryName>
    </cffunction>


    


    <cffunction  name= "validateSubCategoryDetails" access= "remote" returnformat="JSON">
        <cfargument name="categoryName" type="numeric" required="true">
        <cfargument name="subCategoryName" type="string" required="true">
        <cfargument name="subCategoryId" type="string" required="false">

        <cfset local.errors = []>

        <cfset local.validCategories = []>
    	<cfset local.categoryQuery = getCategoryName()>
    		<cfloop query="local.categoryQuery">
        		<cfset arrayAppend(local.validCategories, local.categoryQuery.fldCategory_ID)>
    		</cfloop>
		<cfif NOT arrayContains(local.validCategories, arguments.categoryName)>
        	<cfset arrayAppend(local.errors, "*Enter a valid category")>
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
			<cfset local.addCatogory=createOrAddSubCategory(argumentCollection=arguments)>
			<cfreturn local.errors>
		<cfelse>
		    <cfreturn local.errors>
		</cfif>
        <cfreturn local.errors>
    </cffunction>


    <cffunction name="createOrAddSubCategory" access="public">
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
                sub.fldSubCategoryName,
                sub.fldSubCategory_ID AS idSubCategory,
                cat.fldCategoryName
            FROM 
                tblsubCategory AS sub
            INNER JOIN 
                tblcategory AS cat
             ON 
                sub.fldCategoryId = cat.fldCategory_ID
            WHERE 
                fldCategoryId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            AND
                sub.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfreturn local.getSubCategoriesList>

    </cffunction>


    <cffunction name="getSubCategoryById" access="remote" returntype="any" returnformat="JSON">	
		<cfargument name="subCategoryById" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.subCategoryById)>
        
        <cfquery name="local.getEachSubCategoryId">
            SELECT 
                sub.fldSubCategory_ID,
                sub.fldSubCategoryName,
                cat.fldCategoryName,
                cat.fldCategory_ID
            FROM 
                tblsubcategory AS sub
            INNER JOIN 
                tblcategory AS cat
             ON 
                sub.fldCategoryId = cat.fldCategory_ID
            WHERE 
                fldSubCategory_ID= <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
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
                    WHERE
                        fldSubCategory_ID = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">

            </cfquery>
			
       		<cfset local.response = {status="success", message="Contact deleted successfully."}>
        	<cfreturn local.response>
    		<cfcatch>
				<cfset local.response = {status="error", message="An error occurred while deleting the contact."}>
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
        <cfargument name="productPrice" type="string" required="true">
        <cfargument name="productTax" type="string" required="true">
        <cfargument name="productImg" type="any" required="false">
        <cfargument name="productId" type="string" required="false">
        
        
        
        <cfset local.errors = []>

        <!--- CategoryId validation--->
        <cfset local.validCategories = []>
    	<cfset local.categoryQuery = getCategoryName()>
    		<cfloop query="local.categoryQuery">
        		<cfset arrayAppend(local.validCategories, local.categoryQuery.fldCategory_ID)>
    		</cfloop>
		<cfif NOT arrayContains(local.validCategories, arguments.categoryId)>
        	<cfset arrayAppend(local.errors, "*Enter a valid category")>
    	</cfif>

        <!--- SubCategoryId validation--->
        <cfset local.validSubCategories = []>
    	<cfset local.subCategoryQuery = getSubCategoryName()>
    		<cfloop query="local.subCategoryQuery">
        		<cfset arrayAppend(local.validSubCategories, local.subCategoryQuery.fldSubCategory_ID)>
    		</cfloop>
		<cfif NOT arrayContains(local.validSubCategories, arguments.subCategoryId)>
        	<cfset arrayAppend(local.errors, "*Enter a valid SubCategory")>
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

        <!--- Product Brand validation--->
        <cfset local.validBrandNames = []>
    	<cfset local.brandNameQuery = getProductBrandName()>
    		<cfloop query="local.brandNameQuery">
        		<cfset arrayAppend(local.validBrandNames, local.brandNameQuery.fldBrand_ID)>
    		</cfloop>
		<cfif NOT arrayContains(local.validBrandNames, arguments.productBrand)>
        	<cfset arrayAppend(local.errors, "*Enter a valid Product Brand")>
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
			<cfset local.addCatogory=createOrAddProduct(argumentCollection=arguments)>
			<cfreturn local.errors>
		<cfelse>
		    <cfreturn local.errors>
		</cfif>
        <cfreturn local.errors>
    </cffunction>

    
    <cffunction name="createOrAddProduct" access="public">
        <cfargument name="categoryId" type="numeric" required="true">
        <cfargument name="subCategoryId" type="numeric" required="true">
        <cfargument name="productName" type="string" required="true">
        <cfargument name="productBrand" type="numeric" required="true">
        <cfargument name="productDescription" type="string" required="true">
        <cfargument name="productPrice" type="string" required="true">
        <cfargument name="productTax" type="string" required="true">
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
                                            fldCreatedById
                                            
                                        )
                    VALUES(
                            <cfqueryparam value = "#arguments.productId#" cfsqltype = "cf_sql_integer">,
                            <cfqueryparam value = "#image#" cfsqltype = "cf_sql_varchar">,
                            <cfif i EQ 1 AND local.productImageCount LT 3>
                                <cfqueryparam value = "1" cfsqltype = "cf_sql_tinyint">,
                            <cfelse>
                                <cfqueryparam value = "0" cfsqltype = "cf_sql_tinyint">,
                            </cfif>
                            <cfqueryparam value = "#session.userid#" cfsqltype = "cf_sql_integer">
                            
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

        <cfset local.decryptedId = decryptId(arguments.subCategoryId)>
        <cfquery name="local.getProductList">
            SELECT 
                prd.fldProductName,
                prd.fldProduct_ID AS idProduct,
                sub.fldSubCategoryName,
                br.fldBrandName,
                prd.fldPrice,
                prd.fldTax,
                img.fldDefaultImage,
                img.fldImageFileName
            FROM 
                tblproduct AS prd
            INNER JOIN 
                tblsubcategory AS sub
             ON 
                prd.fldSubCategoryId = sub.fldSubCategory_ID
            INNER JOIN 
                tblbrands AS br
            ON 
               prd.fldBrandId = br.fldBrand_ID
            INNER JOIN 
                tblproductImages AS img
            ON 
                prd.fldProduct_ID = img.fldProductId
            WHERE 
                prd.fldSubCategoryId = <cfqueryparam value="#local.decryptedId#" cfsqltype="cf_sql_integer">
            AND
                prd.fldActive = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
            AND
	            img.fldDefaultImage = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
        </cfquery>
        
        <cfreturn local.getProductList>

    </cffunction>


    <cffunction name="getProductById" access="public" returntype="query">	
		<cfargument name="productId" type="string" required="true">
		<cfset local.decryptedId = decryptId(arguments.productId)>
        
        <cfquery name="local.getEachProductId">
            SELECT 
                prd.fldProduct_ID,
                sub.fldCategoryId,
                sub.fldSubCategory_ID,
                prd.fldProductName,
                prd.fldBrandId,
                prd.fldDescription,
                prd.fldPrice,
                prd.fldTax
            FROM 
                tblproduct AS prd
            INNER JOIN 
                tblSubCategory AS sub
             ON 
                prd.fldSubCategoryId = sub.fldSubCategory_ID
            WHERE 
                fldProduct_ID= <cfqueryparam value=#local.decryptedId#  cfsqltype="cf_sql_integer">
        </cfquery>
        <cfreturn local.getEachProductId> 
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





</cfcomponent>