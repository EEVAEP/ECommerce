
<cftry>
    <cfset displayNavCategory = application.modelUserPage.getNavCategories()>
     
    <cfset categories = {}>
    <cfloop query="displayNavCategory">
        <cfif NOT structKeyExists(categories, displayNavCategory.fldCategoryName)>
            <cfset categories[displayNavCategory.fldCategoryName] = []>
        </cfif>
        <cfif len(displayNavCategory.fldSubCategoryName)>
            <cfset arrayAppend(categories[displayNavCategory.fldCategoryName], displayNavCategory.fldSubCategoryName)>
        </cfif>
    </cfloop>
    
    <cfcatch>
        <cfdump  var="#cfcatch#">
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

    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/css/LoginStyle.css">
    <link rel="stylesheet" href="../../assets/css/UserHomeStyle.css">
</head>
<body>

    <header class="d-flex align-items-center bg-dark text-white py-3 px-3">
        <i class="fas fa-shopping-cart logo-icon me-2"></i>
        <span class="brand fs-4">QuickCart</span>

        <div class="ms-3 flex-grow-1">
        <div class="input-group">
            <input class="form-control search-input" type="search" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-light" type="submit">
                <i class="fas fa-search"></i> 
            </button>
        </div>
    </div>
    </div>

        <div class="ms-auto">
            <a href="../Login.cfm?logOut" class="btn btn-light">LogOut</a> 
        </div>
    </header>

    <nav class="navbar navbar-expand-lg navbar-custom py-1 px-1">
        <div class="container-fluid">
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav d-flex justify-content-between w-100">
                    <cfloop collection="#categories#" item="categoryName">
                        <cfif arrayLen(categories[categoryName])>
                            <li class="nav-item dropdown">
                                <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown">
                                    <cfoutput>#htmlEditFormat(categoryName)#</cfoutput>
                                </a>
                                <ul class="dropdown-menu">
                                    <cfloop array="#categories[categoryName]#" item="subCategoryName">
                                        <li><a class="dropdown-item" href="#"><cfoutput>#htmlEditFormat(subCategoryName)#</cfoutput></a></li>
                                    </cfloop>
                                </ul>
                            </li>
                        <cfelse>
                            <li class="nav-item">
                                <a class="nav-link" href="#"><cfoutput>#htmlEditFormat(categoryName)#</cfoutput></a>
                            </li>
                        </cfif>
                    </cfloop>
                </ul>
            </div>
        </div>
    </nav>

    <section class = "app-section">
    <div class="container">
        <img src="../../assets/img/cartImage" class="banner-img" alt = "banner">
    </div>
    </section>









    <!---<div class="container mt-4">
        <h4>Random Products</h4>
        <div class="row random-products mt-3">
            <div class="col-md-3">
                <div class="product-card">
                    <img src="https://via.placeholder.com/100" alt="Product">
                    <p>Product</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="product-card">
                    <img src="https://via.placeholder.com/100" alt="Product">
                    <p>Product</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="product-card">
                    <img src="https://via.placeholder.com/100" alt="Product">
                    <p>Product</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="product-card">
                    <img src="https://via.placeholder.com/100" alt="Product">
                    <p>Product</p>
                </div>
            </div>
        </div>
    </div>--->
    
       
    

    <script src="../../assets/js/jquery.js"></script>
    
    <script src="../../assets/js/bootstrap.min.js"></script>
	
    
        
    

</body>
</html>