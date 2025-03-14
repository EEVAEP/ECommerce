<cfcomponent>
    <cffunction name="getProductById" access="remote" returntype="any" returnformat="JSON">	
        <cfargument name="productId" type="string" required="true">
         <cfset local.decryptedProductId = application.modelAdminCtg.decryptId(url.productId)>
        <cfset local.productData = application.modelAdminCtg.getProductsList(productId = local.decryptedProductId)>
        <cfset local.productImages = application.modelAdminCtg.getProductImages(productId = arguments.productId)>
        <cfset local.productArr = []>
        <cfloop query = "local.productImages" >
            <cfset local.imgData = {
                'imageId' : local.productImages.fldProductImage_ID,
                'imageFile' : local.productImages.fldImageFileName,
                'defaultValue' : local.productImages.fldDefaultImage
            }>
            <cfset arrayAppend(local.productArr, local.imgData)>
        </cfloop> 
        <cfset local.productDataById = {
            'categoryId': local.productData.fldCategoryId,
            'subCategoryId': local.productData.fldSubCategory_ID,
            'productName' : local.productData.fldProductName,
            'productBrand' : local.productData.fldBrandId,
            'productDescription' : local.productData.fldDescription,
            'productPrice' : local.productData.fldPrice,
            'productTax' : local.productData.fldTax
        }>
        <cfset arrayAppend(local.productArr, local.productDataById)>
        <cfreturn local.productArr>
    </cffunction>

    <cffunction  name="deleteImage" access = "remote" returntype = "any" returnformat = "json">
        <cfargument  name="imageId" type = "integer" required = "true">
        <cfargument  name="productId" type = "string" required = "true">
        <cfset local.errors = []>
        <cfset local.deleteImageResult = application.modelAdminCtg.deleteImage(
                                                                                imageId = arguments.imageId,
                                                                                productId = arguments.productId
                                                                            )>
        <cfif local.deleteImageResult EQ "Success">
            <cfreturn "Success">
        <cfelse>
            <cfset arrayAppend(local.errors, local.deleteImageResult)>
            <cfreturn local.errors>
        </cfif>
    </cffunction>
</cfcomponent>