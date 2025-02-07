<cfparam name="url.subCategoryId" default="">
<cftry>
    <cfset productListQuery = application.modelAdminCtg.getProductsList(url.subCategoryId)>
    
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
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" 
            integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" 
            crossorigin="anonymous" referrerpolicy="no-referrer"/>
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
                <a href="Login.cfm?logOut" class="btn btn-light">LogOut</a> 
            </div>
        </header>
        <div class="container mt-1">
            <h3 class="text-center custom-title">Admin Dashboard</h3>
        </div>
        <div class="container d-flex justify-content-center">
            <div class="card shadow-lg p-4 mb-5 mt-1" style="width: 50rem;">
                <div class="d-flex justify-content-between align-items-center mb-1">
                    <h4>Product</h4>
                    <button class="btn btn-success text-white add"
                        id="createProductBtn"
                        data-bs-toggle="modal" 
                        data-bs-target="#createProductModal">
                        <i class="bi bi-plus-circle"></i>
                    </button>
                    <div class="modal fade" 
				        id="createProductModal"
                        data-bs-backdrop="static" 
				        data-bs-keyboard="false" 
				        tabindex="-1" 
				        aria-labelledby="createProductLabel" 
				        aria-hidden="true">
    				    <div class="modal-dialog">
        				    <div class="modal-content">
            					<div class="modal-header">
                					<h5 class="modal-title mx-auto d-block" id="createProductLabel">Add Product</h5>
                                </div>
                                <div class="modal-body">
                                    <form method="post" id="productForm" action="" enctype="multipart/form-data">
                                        <div class="form-group pt-1 ">
                                            <cfset categoryNameQuery = application.modelAdminCtg.getCategoryList()>
                                            <label for="categoryName">Category Name</label>
                        				    <select class="form-control" id="categoryName" name="categoryName">
                                            
                            				    <cfoutput query="categoryNameQuery">
                        						    <option value="#categoryNameQuery.idCategory#">#categoryNameQuery.fldCategoryName#</option>
											    </cfoutput>
                        				    </select>
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <cfset subCategoryNameQuery = application.modelAdminCtg.getSubCategoryName()>
                                            <label for="subCategoryName" class="form-label">SubCategory Name</label>
                        					<select class="form-control" id="subCategoryName" name="subCategoryName">
                                                <cfoutput query="subCategoryNameQuery">
                        						    <option value="#subCategoryNameQuery.fldSubCategory_ID#">#subCategoryNameQuery.fldSubCategoryName#</option>
											    </cfoutput>
                        				    </select>
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <label for="productName" class="form-label">Product Name</label>
                        					<input type="text" class="form-control" id="productName" name="productName" placeholder="ProductName">
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <cfset brandNameQuery = application.modelAdminCtg.getProductBrandName ()>
                                            <label for="productBrand" class="form-label">productBrand</label>
                        					<select class="form-control" id="productBrand" name="productBrand">
                                                <cfoutput query="brandNameQuery">
                        						    <option value="#brandNameQuery.fldBrand_ID#">#brandNameQuery.fldBrandName#</option>
											    </cfoutput>
                        				    </select>
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <label for="productDescription" class="form-label">Product Description</label>
                        					<input type="text" class="form-control" id="productDescription" name="productDescription" placeholder="productDescription">
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <label for="productPrice" class="form-label">Product Price</label>
                        					<input type="number" class="form-control" id="productPrice" name="productPrice" placeholder="productPrice">
                                        </div>
                                        <div class="form-group pt-1 ">
                                            <label for="productPrice" class="form-label">Product Tax</label>
                        					<input type="number" class="form-control" id="productTax" name="productTax" placeholder="productTax">
                                        </div>
                                        <div class="form-group col-md-6 pt-2">
                        					<label for="productImg">Product Image</label>
                        					<input type="file" class="form-control-file" id="productImg" name="productImg[]" multiple>
                    					</div>
                                        <div class = "row mb-3 mt-3" id = "product-img-container">
                                            <ul class ='product-image-list' id = "img-list"></ul>
                                            
                                        </div>
                                        <div class="form-group pt-1 mt-3">
                                            <button type="button" class="btn btn-secondary mb-3" data-bs-dismiss="modal">Cancel</button>
                                            <button type="button" name="saveProductButton" class="btn btn-success mb-3" id="saveProductButton">Submit</button>
                                            <button type="button" name="editProductButton" class="btn btn-success mb-3" id="editProductButton">Update</button>
                                        </div>
                                        <div id="errorMessages"></div>
                                    </form>
                                </div>
            				</div>
                        </div>
                    </div>
                </div>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
								<cfoutput><th style="border: none;">#productListQuery.fldSubCategoryName#</th></cfoutput>
                            </tr>
                        </thead>
                        <tbody>
                            <cfoutput query="productListQuery">
                                <cfset encryptedId = encrypt(productListQuery.idProduct, application.encryptionKey, "AES", "Hex")>
                                <tr data-id="#encryptedId#">
                                    <td>
            					        <img src="/uploads/#productListQuery.fldImageFileName#" 
									        alt="Photo"		
									        width="30" height="30">
        					        </td>
                                    <td>#productListQuery.fldProductName#</td>
                                    <td>#productListQuery.fldBrandName#</td>
                                    <td>#productListQuery.fldPrice#</td>
                                    <td>
                                        <button 
                                            class="btn btn-sm btn-outline-primary me-2 edit"
                                            id="editProductBtn"
                                            data-bs-toggle="modal" 
                                            data-bs-target="##createProductModal"
                                            data-id="#encryptedId#">
                                            <i class="bi bi-pencil-fill"></i> 
                                        </button>
                                        <button class="btn btn-sm btn-outline-danger me-2 delete"
                                            id="deleteProductBtn"
                                            data-bs-toggle="modal" 
                                            data-bs-target="##deleteProductConfirmModal"
                                            data-id="#encryptedId#">
                                            <i class="bi bi-trash-fill"></i> 
                                        </button>
                                        <button class="btn btn-sm btn-outline-info view"
                                            id="viewProductBtn"
                                            data-bs-toggle="modal" 
                    				        data-bs-target="##viewProductModal"
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
			        id="deleteProductConfirmModal" 
                    data-bs-backdrop="static" 
			        data-bs-keyboard="false"
			        tabindex="-1" 
			        aria-labelledby="deleteProductConfirmLabel" 
			        aria-hidden="true">
    		        <div class="modal-dialog">
        		        <div class="modal-content">
            		        <div class="modal-header">
                		        <h5 class="modal-title mx-auto d-block" id="deleteProductConfirmLabel">CONFIRM DELETION</h5>
                		        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            		        </div>
            		        <div class="modal-body">
                		        Are you sure you want to delete this Product?
            		        </div>
            		    <div class="modal-footer">
                		    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteButton">Delete</button>
            		    </div>
        		    </div>
    		    </div>
            </div>
		    <div class="modal fade" 
                id="viewProductModal"
     	        data-bs-backdrop="static" 
                data-bs-keyboard="false" 
     	        tabindex="-1" 
     	        aria-labelledby="viewProductModalLabel" 
                aria-hidden="true">
                <div class="modal-dialog modal-lg"> 
                    <div class="modal-content">
                        <div class="modal-header bg-success text-white"> 
                            <h5 class="modal-title mx-auto d-block" id="viewContactModalLabel">VIEW PRODUCT DETAILS</h5>
                            <button type="button" class="btn-close btn-close-white"
                                data-bs-dismiss="modal" aria-label="Close">
                            </button>
                        </div>
            	        <div class="modal-body">
                	        <div class="row">
                    	        <div class="col-md-4 text-center">
                        	        <img id="viewPhoto" src="" alt="Profile Picture" class="img-fluid rounded">
                    	        </div>
                    			<div class="col-md-8">
									<div class="row">
                            			<div class="col-6 text-end label">Product Name:</div>
                            			<div class="col-6 value" id="viewProductName"></div>
                        			</div>
                                    <div class="row">
                            			<div class="col-6 text-end label">Product Brand:</div>
                            			<div class="col-6 value" id="viewProductBrand"></div>
                        			</div>
                                    <div class="row">
                            			<div class="col-6 text-end label">Product Description:</div>
                            			<div class="col-6 value" id="viewProductDescription"></div>
                        			</div>
                                    <div class="row">
                            			<div class="col-6 text-end label">Product Price:</div>
                            			<div class="col-6 value" id="viewProductPrice"></div>
                        			</div>
                                    <div class="row">
                            			<div class="col-6 text-end label">Product Tax:</div>
                            			<div class="col-6 value" id="viewProductTax"></div>
                        			</div>	
                				</div>
            				</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="../../assets/js/jquery.js"></script>
        <script src="../../assets/js/bootstrap.min.js"></script>
	    <script src="../../assets/js/bootstrap.bundle.min.js"></script>
        <script src="../../assets/js/AdminProduct.js"></script>
</body>
</html>