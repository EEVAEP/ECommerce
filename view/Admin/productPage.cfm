
<cfparam name="url.productId" default="">
<!---<cfset productListQuery = application.modelAdminCtg.listProducts(url.productId)>--->
 

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
            <a href="Login.cfm?logOut" class="btn btn-light">LogOut</a> 
        </div>
    </header>
    <div class="container mt-1">
        <h3 class="text-center custom-title">Admin Dashboard</h3>
    </div>

    <div class="container d-flex justify-content-center">
        <div class="card shadow-lg p-4 mt-1" style="width: 30rem;">
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
                                    <form method="post" id="productForm" action="">
                                        <div class="form-group pt-1 ">
                                            <cfset categoryNameQuery = application.modelAdminCtg.getCategoryName()>
                                            <label for="categoryName">Category Name</label>
                        				    <select class="form-control" id="categoryName" name="categoryName">
                                            
                            				    <cfoutput query="categoryNameQuery">
                        						    <option value="#categoryNameQuery.fldCategory_ID#">#categoryNameQuery.fldCategoryName#</option>
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
                        					<input type="file" class="form-control-file" id="productImg" name="productImg">
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


           <!--- <div class="products">
    <!-- Start CF Loop -->
    <cfoutput query="subCategoryListQuery">
      <cfset encryptedId = encrypt(subCategoryListQuery.idSubCategory, application.encryptionKey, "AES", "Hex")>
      
      <div class="card" data-id="#encryptedId#">
        <!-- Placeholder for product image -->
        <img src="https://via.placeholder.com/60" alt="Product Image">
        <!-- Product Details -->
        <h2>#subCategoryListQuery.fldSubCategoryName#</h2>
        <p>#subCategoryListQuery.fldCategoryName#</p>
        <div class="price">₹#NumberFormat(subCategoryListQuery.price, "999,999.00")#</div>
        
        <!-- Actions -->
        <div class="actions">
          <!-- Edit Button -->
          <button 
            class="btn btn-sm btn-outline-primary edit"
            id="createSubCategoryBtn"
            data-bs-toggle="modal" 
            data-bs-target="##createSubCategoryModal"
            data-id="#encryptedId#">
            <i class="bi bi-pencil-fill"></i> Edit
          </button>
          
          <!-- Delete Button -->
          <button 
            class="btn btn-sm btn-outline-danger delete"
            id="deleteSubCategoryBtn"
            data-bs-toggle="modal" 
            data-bs-target="##deleteSubConfirmModal"
            data-id="#encryptedId#">
            <i class="bi bi-trash-fill"></i> Delete
          </button>
          
          <!-- View Button -->
          <button 
            class="btn btn-sm btn-outline-info view"
            id="viewCategoryBtn"
            data-id="#encryptedId#">
            <i class="bi bi-chevron-right"></i> View
          </button>
        </div>
      </div>
    </cfoutput>
    <!-- End CF Loop -->
  </div>
</div>--->

        
        <!---<div class="table-responsive">
            <table class="table table-striped">
                <thead>
                    <tr>
									
                        <cfoutput><th style="border: none;">#subCategoryListQuery.fldCategoryName#</th></cfoutput>
                    </tr>
                </thead>
                <tbody>
                    <cfoutput query="subCategoryListQuery">
                    <cfset encryptedId = encrypt(subCategoryListQuery.idSubCategory, application.encryptionKey, "AES", "Hex")>

                        <tr data-id="#encryptedId#">
                            <td>#subCategoryListQuery.fldSubCategoryName#</td>
                            <td>
                                <button 
                                    class="btn btn-sm btn-outline-primary me-2 edit"
                                    id="createSubCategoryBtn"
                                    data-bs-toggle="modal" 
                                    data-bs-target="##createSubCategoryModal"
                                    data-id="#encryptedId#">
                                    <i class="bi bi-pencil-fill"></i> 
                                </button>
                                <button class="btn btn-sm btn-outline-danger me-2 delete"
                                    id="deleteSubCategoryBtn"
                                    data-bs-toggle="modal" 
                                    data-bs-target="##deleteSubConfirmModal"
                                    data-id="#encryptedId#">
                                    <i class="bi bi-trash-fill"></i> 
                                </button>
                                <button class="btn btn-sm btn-outline-info view"
                                    id="deleteCategoryBtn"
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
			id="deleteSubConfirmModal" 
            data-bs-backdrop="static" 
			data-bs-keyboard="false"
			tabindex="-1" 
			aria-labelledby="deleteSubConfirmLabel" 
			aria-hidden="true">
    		<div class="modal-dialog">
        		<div class="modal-content">
            		<div class="modal-header">
                		<h5 class="modal-title mx-auto d-block" id="deleteSubConfirmLabel">CONFIRM DELETION</h5>
                		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            		</div>
            		<div class="modal-body">
                		Are you sure you want to delete this Subcategory?
            		</div>
            		<div class="modal-footer">
                		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="confirmDeleteButton">Delete</button>
            		</div>
        		</div>
    		</div>
		</div>--->


    </div>
    
       
    

    <script src="../../assets/js/jquery.js"></script>
    
    <script src="../../assets/js/bootstrap.min.js"></script>
	<script src="../../assets/js/bootstrap.bundle.min.js"></script>
    <script src="../../assets/js/AdminProduct.js"></script>
        
    

</body>
</html>