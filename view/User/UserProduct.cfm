<cfinclude template="header.cfm">

<cfparam name="url.productId" default="">
<cfif structKeyExists(url, "productId")>
    <cfset variables.displaySingleProductQry = application.modelAdminCtg.getProductById(productId = url.productId)>
</cfif>


<!DOCTYPE html>
<html lang="en">

<body>

    <div class="container mt-4">
        <h4 class="text-center mb-4">Product List</h4>
        <div class="row">
            <cfoutput query="variables.displaySingleProductQry">
                <div class="product-grid">
                    <div class="card subproduct-card">
                        <img src="../../uploads/#variables.displaySingleProductQry.fldImageFileName#" class="card-img-top product-image mb-3" alt="Product Image">
                        
                    </div>
                    <div class="product-info ml-5 w-100">
                            <h6 class="font-weight-bold mb-1">#variables.displaySingleProductQry.fldProductName#</h6>
                            <p class="text-brand mb-2">#variables.displaySingleProductQry.fldBrandName#</p>
                            <p class="text-description mb-2">#variables.displaySingleProductQry.fldDescription#</p>
                            <p class="font-weight-bold text-danger mb-3">#variables.displaySingleProductQry.fldPrice#</p>
                    </div>
                    <div class="product-item d-flex gap-2">
                        <a href="addToCart.cfm?productId=#variables.displaySingleProductQry.fldProduct_ID#" class="btn btn-info btn-sm">Add To Cart</a>
                         <a href="orderNow.cfm?productId=#variables.displaySingleProductQry.fldProduct_ID#" class="btn btn-success btn-sm">Order Now</a>
                    </div>
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