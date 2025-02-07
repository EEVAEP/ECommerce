<cftry>
    <cfset categoryList = application.modelAdminCtg.getCategoryList()> 
<cfcatch>
    <cfdump  var="#cfcatch#">
</cfcatch>
</cftry>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&amp;display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../../assets/css/LoginStyle.css">
    <link rel="stylesheet" href="../../assets/css/AdminStyle.css">
    <link rel="stylesheet" href="../../assets/css/AdminDashboard.css">
</head>
<body>
    <header class="d-flex align-items-center bg-dark text-white py-3 px-4">
        <i class="fas fa-shopping-cart logo-icon me-2"></i>
        <span class="brand fs-4">QuickCart</span>
    
        <div class="ms-auto">
            <a href="../../view/Login.cfm?logOut" class="btn btn-light">LogOut</a> 
        </div>
    </header>
    <div class="container mt-1">
        <h3 class="text-center custom-title">Admin Dashboard</h3>
    </div>
    <div class="container d-flex justify-content-center">
        <div class="card shadow-lg p-4 mt-1" style="width: 30rem;">
            <div class="d-flex justify-content-between align-items-center mb-1">
            <h4>Categories</h4>
            <button class="btn btn-success text-white add"
                    id="createCategoryBtn"
                    data-bs-toggle="modal" 
                    data-bs-target="#createCategoryModal">
                    <i class="bi bi-plus-circle"></i>
            </button>
            <div class="modal fade" 
				id="createCategoryModal"
                data-bs-backdrop="static" 
				data-bs-keyboard="false" 
				tabindex="-1" 
				aria-labelledby="createCategoryLabel" 
				aria-hidden="true">
    				<div class="modal-dialog">
        				<div class="modal-content">
            					<div class="modal-header">
                					<h5 class="modal-title mx-auto d-block" id="createCategoryLabel">Add Categories</h5>
                                </div>
                                <div class="modal-body">
                                    <form method="post" id="categoryForm" action="">
                                        <div class="form-group pt-1 ">
                                            <label for="categoryName" class="form-label">Category Name</label>
                        					<input type="text" class="form-control" id="categoryName" name="categoryName" placeholder="categoryName">
                                        </div>

                                        <div class="form-group pt-1 mt-3">
                                            <button type="button" class="btn btn-secondary mb-3" data-bs-dismiss="modal">Cancel</button>
                                            <button type="button" name="saveCategoryButton" class="btn btn-success mb-3" id="saveCategoryButton">Submit</button>
                                            <button type="button" name="editCategoryButton" class="btn btn-success mb-3" id="editCategoryButton">Update</button>
                                        </div>
                                        <input type="hidden" id="categoryId" name="categoryId">
                                        <div id="errorMessages"></div>
                                    </form>
                                </div>
            				</div>
                        </div>
                    </div>
            </div>
            <div class="table-responsive">
                <table class="table table-striped">
                    <tbody>
                        <cfoutput query="categoryList">
                            <cfset encryptedId = encrypt(categoryList.idCategory, application.encryptionKey, "AES", "Hex")>
                            <tr data-id="#encryptedId#">
                                <td>#categoryList.fldCategoryName#</td>
                                <td>
                                    <button 
                                        class="btn btn-sm btn-outline-primary me-2 edit"
                                        id="createCategoryBtn"
                                        data-bs-toggle="modal" 
                                        data-bs-target="##createCategoryModal"
                                        data-id="#encryptedId#">
                                        <i class="bi bi-pencil-fill"></i> 
                                    </button>
                                    <button class="btn btn-sm btn-outline-danger me-2 delete"
                                        id="deleteCategoryBtn"
                                        data-bs-toggle="modal" 
                                        data-bs-target="##deleteConfirmModal"
                                        data-id="#encryptedId#">
                                        <i class="bi bi-trash-fill"></i> 
                                    </button>
                                    <button class="btn btn-sm btn-outline-info view"
                                        id="viewCategoryBtn"
                                        data-id="#encryptedId#">
                                        <i class="bi bi-chevron-right"></i> 
                                    </button>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>
                </table>
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
                		    Are you sure you want to delete this category?
            		    </div>
            		    <div class="modal-footer">
                		    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteButton">Delete</button>
            		    </div>
        		    </div>
    		    </div>
		    </div>
        </div>
    </div>

    <script src="../../assets/js/jquery.js"></script>
    <script src="../../assets/js/bootstrap.min.js"></script>
	<script src="../../assets/js/bootstrap.bundle.min.js"></script>
    <script src="../../assets/js/AdminCategory.js"></script>
</body>
</html>