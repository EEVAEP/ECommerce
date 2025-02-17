
<cfset variables.NavCategory = application.modelAdminCtg.listSubCategories()>
<cfif structKeyExists(session, "userid") AND structKeyExists(session, "roleid")>
    <cfset variables.getCartcountQuery = application.modelUserPage.getCartProductsCount()>
</cfif>
<cfset variables.categories = structNew()>
<cfoutput query="variables.NavCategory">
    <cfset catId = variables.NavCategory.idCategory>
    <cfif NOT structKeyExists(variables.categories, catId)>
        <cfset variables.categories[catId] = {
            "name" = variables.NavCategory.fldCategoryName,
            "subcategories" = []
        }>
    </cfif>
    <cfif len(variables.NavCategory.idSubCategory)>
        <cfset arrayAppend(variables.categories[catId].subcategories,
            {
                "id" = variables.NavCategory.idSubCategory,
                "name" = variables.NavCategory.fldSubCategoryName
            })>
    </cfif>
</cfoutput>


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
     <link rel="stylesheet" href="../../assets/css/PaymentAndMail.css">
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
        <div class="d-flex align-items-center gap-2 profile">
            <cfif structKeyExists(session, "userid") AND structKeyExists(session, "roleid")>
                <cfif session.roleid EQ 1>
                    <a href="../Admin/dashboard.cfm" class="btn btn-outline-light">Admin</a>
                </cfif>
                <a href="UserProfile.cfm"><i class="fa-solid fa-user profile-icon"></i></a>
                <a href = "UserCart.cfm" class="cartNameAnchor"><p class="cartName">
                    Cart <span id="cart-count" class="count"><cfoutput>
                        <cfif structKeyExists(variables, "getCartcountQuery")>
                            #variables.getCartcountQuery#
                        </cfif>
                    </cfoutput></span>
                </p></a>
                <a href="../Login.cfm?logOut" class="btn btn-light">LogOut</a>
            <cfelseif NOT structKeyExists(session, "userid") AND NOT structKeyExists(session, "roleid")>
                <a href="../Login.cfm?logOut" class="btn btn-light">LogIn</a>
            </cfif>
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
                            <cfoutput>
                                <cfloop collection="#variables.categories#" item="catId">
                                    <cfset encryptedCategoryId_1 = encrypt(catId, application.encryptionKey, "AES", "Hex")>
                                    <li>
                                        <a class="dropdown-item subcategory-link" 
                                            href="UserCategory.cfm?categoryId=#encryptedCategoryId_1#">
                                            #variables.categories[catId].name#
                                        </a>                                   
                                    </li>
                                </cfloop>
                            </cfoutput>
                        </ul>
                    </div>
                    <cfset count = 1>
                    <cfoutput>
                        <cfloop collection="#variables.categories#" item="catId">
                            <div class="dropdown">
                                <button class="btn category-list-btn dropdown-toggle" type="button" id="dropdownMenuButton#count#"
                                    data-bs-toggle="dropdown" aria-expanded="false" 
                                    data-id = "#catId#">
                                    #variables.categories[catId].name#
                                </button>
                                <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton#count#">
                                    <cfloop array="#variables.categories[catId].subcategories#" index="subCategory">
                                        <cfset encryptedSubId = encrypt(subCategory.id, application.encryptionKey, "AES", "Hex")>
                                        <li>
                                            <a class="dropdown-item subcategory-link"
                                                href="UserSubCategory.cfm?SubCategoryId=#encryptedSubId#">
                                                #subCategory.name#
                                            </a>
                                        </li>
                                    </cfloop>
                                </ul>
                            </div> 
                            <cfset count  = count + 1 >
                        </cfloop>
                    </cfoutput>
                </ul>
            </div>
        </div>
    </nav>
</body>
</html>