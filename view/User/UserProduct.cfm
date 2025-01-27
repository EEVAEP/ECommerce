<cfinclude template="header.cfm">

<cfparam name="url.productId" default="">
<cfif structKeyExists(url, "productId")>
    <cfset variables.displaySingleProductQry = application.modelAdminCtg.getProductById(productId = url.productId)>
    <cfset variables.displayProductImages = application.modelAdminCtg.getProductImages(productId = url.productId)>
    
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
                        <div id = "productImageCarousel" class = "carousel slide" data-bs-ride = "carousel">
                            <div class="carousel-indicators">
                                <cfset count = 0>
                                <cfloop query = "variables.displayProductImages">
                                    <button type="button" data-bs-target="##productImageCarousel" data-bs-slide-to="#count#" 
                                        <cfif variables.displayProductImages.fldDefaultImage EQ 1 >class = "active" </cfif>
                                            aria-current="true" aria-label="Slide #count#">
                                    </button>
                                    <cfset count = count +1 >
                                </cfloop>
                            </div>
                            <div class="carousel-inner">
                                <cfloop query = "variables.displayProductImages">
                                    <div class="carousel-item product-img-container <cfif variables.displayProductImages.fldDefaultImage EQ 1 >active</cfif> ">
                                        <img src="../../uploads/#variables.displayProductImages.fldImageFileName#" class="d-block product-image" alt="...">
                                    </div>
                                </cfloop>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="##productImageCarousel" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Previous</span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="##productImageCarousel" data-bs-slide="next">
                                <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                <span class="visually-hidden">Next</span>
                            </button>
                        </div>
                    </div>
                    <div class="product-info ml-5 w-100">
                        <h6 class="font-weight-bold mb-1">#variables.displaySingleProductQry.fldProductName#</h6>
                        <p class="text-brand mb-2">#variables.displaySingleProductQry.fldBrandName#</p>
                        <p class="text-description mb-2">#variables.displaySingleProductQry.fldDescription#</p>
                        <p class="font-weight-bold text-danger mb-3"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.displaySingleProductQry.fldPrice#</p>
                    </div>
                    <div class="product-item d-flex gap-2">
                        <a href="UserCart.cfm?productId=#variables.displaySingleProductQry.fldProduct_ID#" class="btn btn-info btn-sm">Add To Cart</a>
                        <a href="Order.cfm?productId=#variables.displaySingleProductQry.fldProduct_ID#" class="btn btn-success btn-sm">Order Now</a>
                    </div>
                </div>
            </cfoutput>
        </div>
    </div>


            
    <footer class="text-white text-center">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>  
    

    <script src="../../assets/js/jquery.js"></script>
    <script src="../../assets/js/bootstrap.min.js"></script>
	
    
        
    

</body>
</html>