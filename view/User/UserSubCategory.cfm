
<cfinclude template="header.cfm">
<cfparam name="url.SubCategoryId" default="">
<cftry>
    <cfif structKeyExists(url, "SubCategoryId") OR structKeyExists(form, "applyFilterBtn")
        OR structKeyExists(url, "sortOrder")>
        <cfset variables.subCatSortFilterQry = application.modelAdminCtg.getProductsList(subCategoryId = url.SubCategoryId,
                                                                                        sortOrder = (structKeyExists(url, "sortOrder") ? url.sortOrder : ""),
                                                                                        minPrice = (structKeyExists(form, "minPrice") ? form.minPrice : ""),
                                                                                        maxPrice = (structKeyExists(form, "maxPrice") ? form.maxPrice : ""))>
    </cfif>
<cfcatch>
    <cfdump  var="#cfcatch#">
</cfcatch>
</cftry>

<!DOCTYPE html>
<html lang="en">
<head>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h4 class="custom-SubCatHeading">SubCategory List Page</h4>
        <cfif structKeyExists(variables, "subcategoryQry")>
            <h5 class="subcategory-title"><cfoutput>#variables.subcategoryQry.fldSubCategoryName#</cfoutput></h5>
        </cfif>
        <div class="d-flex justify-content gap-1 mb-3">
            <cfoutput>
                <a href="UserSubCategory.cfm?subCategoryId=#url.SubCategoryId#&sortOrder=asc" class="btn btn-outline-success btn-sm mr-2">Low to High</a>
                <a href="UserSubCategory.cfm?subCategoryId=#url.SubCategoryId#&sortOrder=desc" class="btn btn-outline-success btn-sm">High to Low</a>
               <button type="button" 
                    id="createfilterProductBtn"
                    class="btn btn-outline-success" 
                    data-id = "#url.SubCategoryId#"
                    data-bs-toggle="modal" 
                    data-bs-target="##filterModal">
                    Filter <i class="fa-solid fa-filter"></i>
                </button>
                <div class="modal fade" 
                    id="filterModal" 
                    data-bs-backdrop="static" 
				    data-bs-keyboard="false"
                    tabindex="-1" 
                    aria-labelledby="filterModalLabel" 
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title mx-auto d-block" id="filterModalLabel">Filter by Price</h5>
                            </div>
                            <div class="modal-body">
                                <form method="POST" action="" id="filterForm" >
                                    <div class="form-group pt-1">
                                        <label for="minPrice">Minimum Price</label>
                                        <input type="number" id="minPrice" name="minPrice" class="form-control" placeholder="Enter minimum price" required>
                                    </div>
                                    <div class="form-group pt-1">
                                        <label for="maxPrice">Maximum Price</label>
                                        <input type="number" id="maxPrice" name="maxPrice" class="form-control" placeholder="Enter maximum price" required>
                                    </div>
                                    <div class="form-group pt-1 mt-3">
                                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                        <button type="submit" class="btn btn-success" name="applyFilterBtn" id="applyFilterBtn">Apply Filter</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </cfoutput>
        </div>
        <cfif structKeyExists(variables, "subCatSortFilterQry") AND NOT structKeyExists(url, "sortOrder") AND NOT structKeyExists(form, "applyFilterBtn")>
            <div class="product-grid">
                <cfoutput query="variables.subCatSortFilterQry">
                    <cfset encryptedId = encrypt(variables.subCatSortFilterQry.idProduct, application.encryptionKey, "AES", "Hex")>
                    <div class="product-item">
                        <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                            <div class="card product-card">
                                <img src="/uploads/#variables.subCatSortFilterQry.fldImageFileName#" class="card-img-top" alt="Product">
                                <div class="card-body text-center">
                                    <h6 class="product-name">#variables.subCatSortFilterQry.fldProductName#</h6>
                                    <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.subCatSortFilterQry.fldPrice#</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </cfoutput>
            </div>
        <cfelseif structKeyExists(variables, "subCatSortFilterQry") AND structKeyExists(url, "sortOrder")  AND NOT structKeyExists(form, "applyFilterBtn")>
            <div class="product-grid">
                <cfoutput query="variables.subCatSortFilterQry">
                    <cfset encryptedId = encrypt(variables.subCatSortFilterQry.idProduct, application.encryptionKey, "AES", "Hex")>
                    <div class="product-item">
                        <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                            <div class="card product-card">
                                <img src="/uploads/#variables.subCatSortFilterQry.fldImageFileName#" class="card-img-top" alt="Product">
                                <div class="card-body text-center">
                                    <h6 class="product-name">#variables.subCatSortFilterQry.fldProductName#</h6>
                                    <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.subCatSortFilterQry.fldPrice#</p>
                                </div>
                            </div>
                        </a>
                    </div>
                </cfoutput>
            </div>
        <cfelseif structKeyExists(form, "applyFilterBtn") AND NOT structKeyExists(url, "sortOrder")>
            <cfif variables.subCatSortFilterQry.recordCount GT 0>
                <div class="product-grid">
                    <cfoutput query="variables.subCatSortFilterQry">
                        <cfset encryptedId = encrypt(variables.subCatSortFilterQry.idProduct, application.encryptionKey, "AES", "Hex")>
                        <div class="product-item">
                            <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                                <div class="card product-card">
                                    <img src="/uploads/#variables.subCatSortFilterQry.fldImageFileName#" class="card-img-top" alt="Product">
                                    <div class="card-body text-center">
                                        <h6 class="product-name">#variables.subCatSortFilterQry.fldProductName#</h6>
                                        <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.subCatSortFilterQry.fldPrice#</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </cfoutput>
                </div>
            <cfelse>
                <div class="alert alert-warning text-center mt-4">
                    No results found. Please try another search.
                </div>
            </cfif>
        </cfif>
    </div>
    <cfinclude template="footer.cfm">
 </body>
</html>