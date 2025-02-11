<cfinclude template="header.cfm">
<cfparam name="url.categoryId" default="">

<!DOCTYPE html>
<html lang="en">

<body>

    <cfset variables.displaySubCategoryQry = application.modelAdminCtg.listSubCategories(categoryId = url.categoryId)>
    <div class="container mt-4">
        <h4 class="custom-SubCatHeading">Category List Page</h4>
        <cfoutput query="variables.displaySubCategoryQry">
            <div class="subcategory mb-4">
                <h5 class="subcategory-title">#variables.displaySubCategoryQry.fldSubCategoryName#</h5>
                <div class="row">
                    <cfset encryptedId = encrypt(variables.displaySubCategoryQry.idSubCategory, application.encryptionKey, "AES", "Hex")>
                    <cfset variables.products = application.modelAdminCtg.getProductsList(subCategoryId = encryptedId)>
                    <cfloop query="variables.products"  endrow="4">
                        <cfset encryptedPrdId = encrypt(variables.products.idProduct, application.encryptionKey, "AES", "Hex")>
                        <div class="col-md-3">
                            <a href="UserProduct.cfm?productId=#encryptedPrdId#" class="product-link">
                                <div class="card product-card">
                                    <img src="/uploads/#variables.products.fldImageFileName#" class="card-img-top" alt="Product">
                                    <div class="card-body text-center">
                                        <h6 class="product-name">#variables.products.fldProductName#</h6>
                                        <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.products.fldPrice#</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </cfloop>
                </div>
            </div>
        </cfoutput>
    </div>
    
    <cfinclude template="footer.cfm">
	
</body>
</html>