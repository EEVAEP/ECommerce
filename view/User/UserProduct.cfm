<cfinclude template="header.cfm">
<cfparam name="url.productId" default="">
<cfif structKeyExists(url, "productId")>
    <cfset variables.decryptedProductId = application.modelAdminCtg.decryptId(url.productId)>
    <cfif NOT isNumeric(variables.decryptedProductId) OR variables.decryptedProductId LTE 0>
        <div class="alert alert-warning text-center mt-6">
            No results found. Please try another search.
        </div>
    <cfelse>
        <cfset local.decryptedProductId = application.modelAdminCtg.decryptId(url.productId)>
        <cfset variables.displaySingleProductQry = application.modelAdminCtg.getProductsList(productId = local.decryptedProductId)>
        <cfset variables.displayProductImages = application.modelAdminCtg.getProductImages(productId = url.productId)>
    </cfif>
</cfif>
<cfset variables.displayUserAddress = application.modelUserPage.getUserAddress()>
<cfif structKeyExists(form, "selectPaymentButton")>
    <cflocation url="PaymentDetailsPage.cfm?addressId=#form.selectedAddress#&productId=#form.productId#" addtoken="no">
</cfif>

<!DOCTYPE html>
<html lang="en">
<body>
    <div class="container mt-4">
        <h4 class="text-center mb-4">Product List</h4>
        <div class="row">
            <cfif structKeyExists(variables, "displaySingleProductQry") OR structKeyExists(variables, "displayProductImages")>
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
                                        <cfset count = count +1>
                                    </cfloop>
                                </div>
                                <div class="carousel-inner">
                                    <cfloop query = "variables.displayProductImages">
                                        <div class="carousel-item product-img-container <cfif variables.displayProductImages.fldDefaultImage EQ 1 >active</cfif> ">
                                            <img src="/uploads/#variables.displayProductImages.fldImageFileName#" class="d-block product-image" alt="...">
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
                        <cfset encryptedId = encrypt(variables.displaySingleProductQry.idProduct, application.encryptionKey, "AES", "Hex")>
                        <div class="product-item d-flex gap-2">
                            <a href="UserCart.cfm?action=buyToCart&productId=#encryptedId#" class="btn btn-info btn-sm">Add To Cart</a>
                            <button 
                                class="btn btn-success btn-sm me-2 orderNow"
                                id="orderNowBtn"
                                name="orderNowBtn"
                                data-bs-toggle="modal" 
                                data-bs-target="##selectAddressModal"
                                data-id="#encryptedId#">
                                Order Now
                            </button>
                        </div>
                        <div class="modal fade" 
                            id="selectAddressModal"
                            data-bs-backdrop="static" 
                            data-bs-keyboard="false" 
                            tabindex="-1" 
                            aria-labelledby="selectAddressLabel" 
                            aria-hidden="true">
                            <div class="modal-dialog">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h5 class="modal-title mx-auto d-block" id="selectAddressLabel">Select Addresses</h5>
                                    </div>
                                    <div class="modal-body">
                                        <form method="post" id="selectAddressForm" action="">
                                            <div class="saved-addresses">
                                                <h5>Saved Addresses</h5>
                                                <cfoutput>
                                                    <cfloop query="variables.displayUserAddress">
                                                        <cfset encryptedAddressId = encrypt(variables.displayUserAddress.fldAddress_ID, application.encryptionKey, "AES", "Hex")>
                                                        <div class="address-option">
                                                            <input 
                                                                type="radio" 
                                                                name="selectedAddress" 
                                                                value="#encryptedAddressId#" 
                                                                id="address_#fldAddress_ID#"
                                                                <cfif currentRow EQ 1>checked="checked"</cfif>
                                                            >
                                                            <label for="address_#fldAddress_ID#">
                                                                <strong>#fldFirstName#</strong>  #fldphonenumber#
                                                                <br>
                                                                <span class="address-details">
                                                                    #fldAddressLine1#, #fldAddressLine2#, #fldCity#, #fldState#,
                                                                    <br>
                                                                    #fldPincode#
                                                                </span>
                                                            </label>
                                                        </div>
                                                    </cfloop>
                                                    <input type="hidden" name="productId" value="#encryptedId#">
                                                </cfoutput>
                                            </div>
                                        </form>
                                        <div class="modal-footer form-group pt-1 mt-3">
                                            <button type="button" class="btn btn-secondary mb-3" data-bs-dismiss="modal">Cancel</button> 
                                            <button class="btn btn-success addAdress mb-3"
                                                id="createUserAddressBtn"
                                                
                                                data-bs-toggle="modal" 
                                                data-bs-target="##createUserAddressModal">
                                                Add New Address
                                            </button> 
                                            <button type="submit" 
                                                name="selectPaymentButton" 
                                                form="selectAddressForm" 
                                                class="btn btn-success mb-3" 
                                                id="selectPaymentButton"
                                                data-id="#encryptedId#">
                                                Payment Details
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <cfinclude template= "AddressModal.cfm">
                    </div>
                </cfoutput>
            </cfif>
        </div>
    </div>
    <cfinclude template="footer.cfm">

	<script>
        $(document).ready(function() {
            $("#createUserAddressBtn").click(function() {
                openSecondModal = true;
                $("#selectAddressModal").modal("hide"); 
            });

            $("#selectAddressModal").on("hidden.bs.modal", function () {
                if (openSecondModal) {
                    $("#createUserAddressModal").modal("show");
                    openSecondModal = false;
                }
            });
        });
</script>
</body>
</html>