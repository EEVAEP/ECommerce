
<cfparam name="url.productId" default="">

<cfset variables.NavCategory = application.modelAdminCtg.getCategoryList()>



<cftry>
    <cfif structKeyExists(url, "productId") AND structKeyExists(session, "userid") AND structKeyExists(session, "roleid")>
        <cfset variables.getCartcountQuery = application.modelUserPage.getCartProductsCount()>
        <cfset variables.createCartPrdQuery = application.modelUserPage.createCartProducts(productId = url.productId)>
        <cfif variables.createCartPrdQuery EQ "success">
            <cfset variables.displayCartDetails = application.modelUserPage.getCartProductsList()>
           
        </cfif>
       
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
             <p class="cartName">
                Cart <span id="cart-count" class="count"><cfoutput>
                <cfif structKeyExists(url, "productId")>
                #variables.getCartcountQuery#
                </cfif>
                </cfoutput></span>
            </p>
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
        <!---productId=D524EC46D34CF6BD517D82937944B949--->
        
        <div class="cart-container">
            <h1>Cart</h1>
            <div class="cart-items">
                <cfoutput query="variables.displayCartDetails">
                    <div class="cart-item">
                        <div class="product-details">
                            <div class="product-image">
                                <img src="../../uploads/#variables.displayCartDetails.fldImageFileName#" alt="Product Image" style="width: 100%; height: 100%; object-fit: cover;">
                            </div>
                    
                            <div class="product-info">
                                <p><strong>#variables.displayCartDetails.fldProductName#</strong></p>
                                <p>Brand:#variables.displayCartDetails.fldBrandName#</p>
                                <p>
                                    <button>-</button> 
                                       Quantity:
                                    <button>+</button>
                                </p>
                            </div>
                        </div>
                        <div>
                            <p><strong>#variables.displayCartDetails.priceWithTax#</strong></p>
                            <p>Tax: #variables.displayCartDetails.fldTax#%</p>
                            <p>Actual Price: ₹#variables.displayCartDetails.fldPrice#</p>
                            <button class="btn-remove">Remove</button>
                        </div>
                    </div>
                </cfoutput>
            </div>
        
        
        <!---<div class="price-details">
            <cfquery name="calculateTotal" datasource="your_datasource">
                SELECT 
                    SUM(price * quantity) AS total_price, 
                    SUM((price * quantity) * (tax_rate / 100)) AS total_tax
                FROM cart_table
                WHERE user_id = <cfqueryparam value="#session.user_id#" cfsqltype="cf_sql_integer">
            </cfquery>
            <div class="price-row">
                <span>Actual Price</span>
                <span>₹#calculateTotal.total_price#</span>
            </div>
            <div class="price-row">
                <span>Total Tax</span>
                <span>₹#calculateTotal.total_tax#</span>
            </div>
            <div class="price-row">
                <strong>Total Price</strong>
                <strong>₹#calculateTotal.total_price + calculateTotal.total_tax#</strong>
            </div>
            <button class="btn-checkout">Bought Together</button>
        </div>
    </div> --->  
    </cfif>


    <footer class="text-white text-center">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>  
    

    <script src="../../assets/js/jquery.js"></script>
    <script src="../../assets/js/bootstrap.min.js"></script>
	
    
        
    

</body>
</html>