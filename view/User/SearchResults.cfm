<cfinclude template="header.cfm">

<cfparam name="url.query" default="">

<!DOCTYPE html>
<html lang="en">

<body>
    <cfif len(trim(url.query))>
        <cftry>
        <cfset variables.getSearchResult = application.modelAdminCtg.getProductsList(searchText = url.query)>
        

        <div class="container mt-4">
            <h4 class="custom-SubCatHeading">Search Results...</h4>
            <cfif variables.getSearchResult.recordCount gt 0>
                <div class="product-grid">
                    <cfoutput query="variables.getSearchResult">
                        <cfset encryptedId = encrypt(variables.getSearchResult.idProduct, application.encryptionKey, "AES", "Hex")>
                        <div class="product-item">
                            <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                                <div class="card product-card">
                                    <img src="../../uploads/#variables.getSearchResult.fldImageFileName#" class="card-img-top" alt="Product">
                                    <div class="card-body text-center">
                                        <h6 class="product-name">#variables.getSearchResult.fldProductName#</h6>
                                        <p class="product-price">#variables.getSearchResult.fldPrice#</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </cfoutput>
                </div>
            <cfelse>
                <div class="alert alert-warning text-center mt-4">
                    No results found for "<strong><cfoutput>#url.query#</cfoutput></strong>". Please try another search.
                </div>
            </cfif>
        </div>
        <cfcatch>
            <cfdump  var="#cfcatch#">
        </cfcatch>
        </cftry>
    </cfif>
    
    <cfinclude template="footer.cfm">
	
</body>
</html>