<cfinclude template="header.cfm">
<cfparam name="url.categoryId" default="">
<cfif structKeyExists(url, "categoryId")>
    <cfset variables.decryptedCategoryId = application.modelAdminCtg.decryptId(url.categoryId)>
    <cfif NOT isNumeric(variables.decryptedCategoryId) OR variables.decryptedCategoryId LTE 0>
        <div class="alert alert-warning text-center mt-6">
            No results found. Please try another search.
        </div>
    <cfelse>
        <cfset variables.displaySubCategoryQry = application.modelAdminCtg.listSubCategories(categoryId = url.categoryId)>
        <cfset local.decryptedCategoryId = application.modelAdminCtg.decryptId(url.categoryId)>
        <cfset variables.allProducts = application.modelAdminCtg.getProductsList(categoryId = local.decryptedCategoryId)>
    </cfif>
</cfif>
<cfif structKeyExists(variables, "allProducts")>
    <cfset variables.groupedProducts = {}>
    <cfloop query="variables.allProducts">
        <cfset subCategoryKey = variables.allProducts.fldSubCategory_ID>
        <cfif NOT structKeyExists(variables.groupedProducts, subCategoryKey)>
            <cfset variables.groupedProducts[subCategoryKey] = []>
        </cfif>
        <cfif arrayLen(variables.groupedProducts[subCategoryKey]) LT 4>
            <cfset arrayAppend(variables.groupedProducts[subCategoryKey], {
                idProduct = variables.allProducts.idProduct,
                fldProductName = variables.allProducts.fldProductName,
                fldImageFileName = variables.allProducts.fldImageFileName,
                fldPrice = variables.allProducts.fldPrice
            })>
        </cfif>
    </cfloop>
</cfif>

<!DOCTYPE html>
<html lang="en">
<body>
   <div class="container mt-4">
        <h4 class="custom-SubCatHeading">Category List Page</h4>
        <cfif structKeyExists(variables, "displaySubCategoryQry")>
            <cfoutput query="variables.displaySubCategoryQry">
                <div class="subcategory mb-4">
                    <h5 class="subcategory-title">#variables.displaySubCategoryQry.fldSubCategoryName#</h5>
                    <div class="row">
                        <cfset encryptedId = encrypt(variables.displaySubCategoryQry.idSubCategory, application.encryptionKey, "AES", "Hex")>
                        <cfif structKeyExists(variables.groupedProducts, variables.displaySubCategoryQry.idSubCategory)>
                            <cfloop array="#variables.groupedProducts[variables.displaySubCategoryQry.idSubCategory]#" index="product">
                                <cfset encryptedPrdId = encrypt(product.idProduct, application.encryptionKey, "AES", "Hex")>
                                <div class="col-md-3">
                                    <a href="UserProduct.cfm?productId=#encryptedPrdId#" class="product-link">
                                        <div class="card product-card">
                                            <img src="/uploads/#product.fldImageFileName#" class="card-img-top" alt="Product">
                                            <div class="card-body text-center">
                                                <h6 class="product-name">#product.fldProductName#</h6>
                                                <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#product.fldPrice#</p>
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            </cfloop>
                        </cfif>
                    </div>
                </div>
            </cfoutput>
        </cfif>
    </div>
    <cfinclude template="footer.cfm">
</body>
</html>