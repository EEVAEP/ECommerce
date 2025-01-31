
<cfparam name="url.productId" default="">


<cfset variables.NavCategory = application.modelAdminCtg.getCategoryList()>
<cfset variables.displayUserAddress = application.modelUserPage.getUserAddress()>
<cftry>
    <cfif (len(url.productId) EQ 0) AND structKeyExists(session, "userid") AND structKeyExists(session, "roleid")>
        <cfset variables.displayCartDetails = application.modelUserPage.getCartProductsList()>
        <cfset variables.getCartcountQuery = application.modelUserPage.getCartProductsCount()>
    
    <cfelseif structKeyExists(url, "productId") AND (len(url.productId) NEQ 0) AND structKeyExists(session, "userid") AND structKeyExists(session, "roleid")>
        <cfset variables.createCartPrdQuery = application.modelUserPage.createCartProducts(productId = url.productId)>
        <cfif variables.createCartPrdQuery EQ "success">
            <cfset variables.displayCartDetails = application.modelUserPage.getCartProductsList()>
        </cfif>
       <cfset variables.getCartcountQuery = application.modelUserPage.getCartProductsCount()>
    <cfelse>
        <cfset session.productId = url.productId>
        <cflocation  url="../../view/Login.cfm" addtoken="false">
    
    </cfif>
    
    
<cfcatch>
    <cfdump var="#cfcatch#">
</cfcatch>
</cftry>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User - Dashboard</title>

    <link href="https://fonts.googleapis.com/css2?family=Pacifico&amp;display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/css/LoginStyle.css">
    <link rel="stylesheet" href="../../assets/css/UserHomeStyle.css">
    <link href="https://unpkg.com/aos@2.3.1/dist/aos.css" rel="stylesheet">
</head>
<body>

    <header class="d-flex align-items-center bg-dark text-white py-3 px-3">
        <i class="fas fa-shopping-cart logo-icon me-2"></i>
        <a href="UserHome.cfm" class="text-decoration-none">
            <span class="brand fs-4" style="color:rgb(248, 248, 248); cursor: pointer;">QuickCart</span>
        </a>


        <div class="ms-3 flex-grow-1">
            <form action="SearchResults.cfm" method="get">
                <div class="input-group">
                    <input class="form-control search-input" name="query" type="search" placeholder="Search" aria-label="Search">
                    <button class="btn btn-outline-light" type="submit">
                        <i class="fas fa-search"></i> 
                    </button>
                </div>
            </form>
        </div>

        
        <div class="d-flex justify-content gap-2">
            <a href="UserProfile.cfm"><i class="fa-solid fa-user profile-icon"></i></a>
            <a href = "#" class="cartNameAnchor"><p class="cartName">
                Cart <span id="cart-count" class="count"><cfoutput>
                <cfif structKeyExists(url, "productId")>
                    <cfif structKeyExists(variables, "getCartcountQuery")>
                        #variables.getCartcountQuery#
                    </cfif>
                </cfif>
                </cfoutput></span>
            </p></a>
            <a href="../Login.cfm?logOut" class="btn btn-light">LogOut</a>
        </div>

    </header>

    <nav class="navbar navbar-expand-lg navbar-custom py-1 px-1">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav d-flex justify-content-between w-100">
                    <div class="dropdown">
                        <button class="btn category-list-btn dropdown-toggle" type="button" 
                            id="dropdownMenuBtn" data-bs-toggle="dropdown" aria-expanded="false">
                            Menu
                        </button>
                        <ul class="dropdown-menu" aria-labelledby="dropdownMenuBtn">
                            <cfif structKeyExists(variables, "NavCategory")>
                                <cfoutput query = "variables.NavCategory">
                                    <cfset encryptedCategoryId_1 = encrypt(variables.NavCategory.idCategory, application.encryptionKey, "AES","Hex")>
                                        <li>
                                            <a class="dropdown-item subcategory-link" 
                                                href="UserCategory.cfm?categoryId=#encryptedCategoryId_1#">
                                                #variables.NavCategory.fldCategoryName#
                                            </a>                                   
                                        </li>                               
                                </cfoutput>
                            </cfif>
                        </ul>
                    </div>


                    <cfset count = 1>
                    <cfoutput query = "variables.NavCategory">
                        <div class="dropdown">
                            <button class="btn category-list-btn dropdown-toggle" type="button" id="dropdownMenuButton#count#"
                                data-bs-toggle="dropdown" aria-expanded="false" 
                                data-id = "#variables.NavCategory.idCategory#">
                                #variables.NavCategory.fldCategoryName#
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                <cfset encryptedId = encrypt(variables.NavCategory.idCategory, application.encryptionKey, "AES", "Hex")>
                                <cfset variables.getSubCategory = application.modelAdminCtg.listSubCategories(categoryId = encryptedId)>
                                <cfloop query = "variables.getSubCategory">
                                    <cfset encryptedSubId = encrypt(variables.getSubCategory.idSubCategory, application.encryptionKey, "AES", "Hex")>
                                    <li>
                                        <a class="dropdown-item subcategory-link"
                                            href = "UserSubCategory.cfm?SubCategoryId=#encryptedSubId#">
                                            #variables.getSubCategory.fldSubCategoryName#
                                        </a>
                                    </li>
                                </cfloop>
                            </ul>
                        </div> 
                        <cfset count  = count + 1 >
                    </cfoutput>
                </ul>
            </div>
        </div>
    </nav>

    <cfif structKeyExists(variables, "displayCartDetails")>
       <div class="cart-container">
            <h1>Cart</h1>
            <div class="cart-items">
                <cfoutput query="variables.displayCartDetails">
                    <div class="cart-item">
                        <cfset encryptedPrdId = encrypt(variables.displayCartDetails.idProduct, application.encryptionKey, "AES", "Hex")>
                        <div class="product-details">
                            <div class="product-image">
                                <img src="/uploads/#variables.displayCartDetails.fldImageFileName#" alt="Product Image" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                    
                            <div class="product-info">
                                <p><strong>#variables.displayCartDetails.fldProductName#</strong></p>
                                <p>Brand:#variables.displayCartDetails.fldBrandName#</p>
                                <p>
                                    <button class="decrease" 
                                        data-id="#encryptedPrdId#"
                                        id="decreaseCartProductBtn">
                                        -
                                    </button> 
                                       #variables.displayCartDetails.fldQuantity#
                                    <button class="increase" 
                                        data-id="#encryptedPrdId#"
                                        id="increaseCartProductBtn">
                                        +
                                    </button>
                                </p>
                            </div>
                        </div>
                        <div>
                            <p><i class="fa-solid fa-indian-rupee-sign"></i><strong>#NumberFormat(variables.displayCartDetails.priceWithTax, "0.00")#</strong></p>
                            <p>Tax: #variables.displayCartDetails.fldTax#%</p>
                            <p>Actual Price: #variables.displayCartDetails.fldPrice#</p>
                            <button class="btn-remove deleteProduct" 
                                id="deleteCategoryBtn"
                                data-bs-toggle="modal" 
                                data-bs-target="##deleteConfirmModal"
                                data-id="#encryptedPrdId#">
                                Remove 
                            </button>
                        </div>
                    </div>
                </cfoutput>
            </div>
            <div class="modal fade" 
			    id="deleteConfirmModal" 
                data-bs-backdrop="static" 
			    data-bs-keyboard="false"
			    tabindex="-1" 
			    aria-labelledby="deleteConfirmLabel" 
			    aria-hidden="true">
    		    <div class="modal-dialog">
        		    <div class="modal-content">
            		    <div class="modal-header">
                		    <h5 class="modal-title mx-auto d-block" id="deleteConfirmLabel">CONFIRM DELETION</h5>
                		    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            		    </div>
            		    <div class="modal-body">
                		    Are you sure you want to remove this product?
            		    </div>
            		    <div class="modal-footer">
                		    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteButton">Delete</button>
            		    </div>
        		    </div>
    		    </div>
		    </div>

            <cfset variables.cartActualPrice = 0>
            <cfset variables.cartTotalTax = 0>
            <cfset variables.cartTotalPrice = 0>

            <cfoutput query="variables.displayCartDetails">
                <cfset variables.itemActualPrice = variables.displayCartDetails.fldPrice * variables.displayCartDetails.fldQuantity>
                <cfset variables.itemTotalTax = (variables.displayCartDetails.fldPrice * (variables.displayCartDetails.fldTax / 100)) * variables.displayCartDetails.fldQuantity>
                <cfset variables.itemTotalPrice = variables.itemActualPrice + variables.itemTotalTax>

                <!-- Sum calculation -->
                <cfset variables.cartActualPrice += variables.itemActualPrice>
                <cfset variables.cartTotalTax += variables.itemTotalTax>
                <cfset variables.cartTotalPrice += variables.itemTotalPrice>
            </cfoutput>

            <cfoutput>    
                <div class="price-details">
                    <div class="price-row">
                        <span>Actual Price</span>
                        <span>#variables.cartActualPrice#</span>
                    </div>
                    <div class="price-row">
                        <span>Total Tax</span>
                        <span>#variables.cartTotalTax#</span>
                    </div>
                    <div class="price-row">
                        <strong>Total Price</strong>
                        <strong><i class="fa-solid fa-indian-rupee-sign"></i>#variables.cartTotalPrice#</strong>
                    </div>
                   
                    <button 
                        class="btn btn-checkout btn-sm me-2 orderNow"
                        id="orderNowBtn"
                        name="orderNowBtn"
                        data-bs-toggle="modal" 
                        data-bs-target="##selectAddressModal"
                        data-id="#encryptedId#">
                        Bought Together
                    </button>
                </div>
            </cfoutput>
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
                                            <div class="address-option">
                                                <input 
                                                    type="radio" 
                                                    name="selectedAddress" 
                                                    value="#fldAddress_ID#" 
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
                                <button type="button" name="selectPaymentButton" form="selectAddressForm" class="btn btn-success mb-3" id="selectPaymentButton">Payment Details</button>
                            </div>
                            
                        </div>
                    </div>
                </div>
            </div>
            <cfinclude template= "AddressModal.cfm">
        </div> 
    </cfif>

    <cfinclude template="footer.cfm">
	
    <script src="../../assets/js/UserCart.js"></script>
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