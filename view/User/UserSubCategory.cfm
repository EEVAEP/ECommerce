
<cfinclude template="header.cfm">
<cfparam name="url.SubCategoryId" default="">
<cftry>
    <cfset variables.subCategoryQry = application.modelAdminCtg.listProducts(subCategoryId = url.SubCategoryId)>
    
<cfcatch>
    <cfdump  var="#cfcatch#">
</cfcatch>
</cftry>


<!DOCTYPE html>
<html lang="en">
<body>

    <div class="container mt-4">
        <h4 class="custom-SubCatHeading">SubCategory List Page</h4>
        <h5 class="subcategory-title"><cfoutput>#variables.subcategoryQry.fldSubCategoryName#</cfoutput></h5>
         <div class="product-grid">
            <cfoutput query="variables.subcategoryQry">
                <cfset encryptedId = encrypt(variables.subcategoryQry.idProduct, application.encryptionKey, "AES", "Hex")>
                <div class="product-item">
                    <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                        <div class="card product-card">
                            <img src="../../uploads/#variables.subcategoryQry.fldImageFileName#" class="card-img-top" alt="Product">
                            <div class="card-body text-center">
                                <h6 class="product-name">#variables.subcategoryQry.fldProductName#</h6>
                                <p class="product-price">#variables.subcategoryQry.fldPrice#</p>
                            </div>
                        </div>
                    </a>
                </div>
            </cfoutput>
        </div>
    </div>
    
    <footer class="text-white text-center py-5 mt-5">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>  
    

    <script src="../../assets/js/jquery.js"></script>
    
    <script src="../../assets/js/bootstrap.min.js"></script>
	
    
        
    

</body>
</html>