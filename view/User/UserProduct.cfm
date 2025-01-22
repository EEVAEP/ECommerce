
<cfset variables.NavCategory = application.modelUserPage.getNavCategories()>

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
                    <cfset count = 1>
                    <cfoutput query = "variables.NavCategory">
                        <div class="dropdown">
                            <button class="btn category-list-btn dropdown-toggle" type="button" id="dropdownMenuButton#count#"
                                data-bs-toggle="dropdown" aria-expanded="false" 
                                data-id = "#variables.NavCategory.fldCategory_ID#">
                                #variables.NavCategory.fldCategoryName#
                            </button>
                            <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
                                <cfset encryptedId = encrypt(variables.NavCategory.fldCategory_ID, application.encryptionKey, "AES", "Hex")>
                                <cfset variables.getSubCategory = application.modelUserPage.getNavSubCategories(categoryId = encryptedId)>
                                <cfloop query = "variables.getSubCategory">
                                    <li>
                                        <a class="dropdown-item subcategory-link"
                                            href = "userCategory.cfm?CategoryId=#encryptedId#">
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


            

  
    
    <footer class="text-white text-center py-5 mt-5">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>  
    

    <script src="../../assets/js/jquery.js"></script>
    
    <script src="../../assets/js/bootstrap.min.js"></script>
	
    
        
    

</body>
</html>