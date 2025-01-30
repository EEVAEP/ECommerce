<cfinclude template="Header.cfm">
<cfset variables.displayUserDetailsQry = application.modelUserPage.getUserProfileDetails()>
<cfset variables.displayUserAddressQry = application.modelUserPage.getUserAddress()>


<!DOCTYPE html>
<html lang="en">

<body>

    <div class="user-container">
        <div class="user-header">
            <div class="user-icon">
                <i class="fa-solid fa-user"></i>
            </div>
            <div class="user-details">
                <cfoutput>
                    <p class="user-name">Hello, #variables.displayUserDetailsQry.fullname#</p>
                    <p class="user-email">#variables.displayUserDetailsQry.fldEmail#</p>
                </cfoutput>
            </div>
        </div>
    </div>

    <div class="user-container">
        <div class="profile-section">  
            <h3>Profile Informations</h3>
            <div class="profile-addresses">
                <cfoutput query="variables.displayUserAddressQry">
                    <cfset encryptedId = encrypt(variables.displayUserAddressQry.fldAddress_ID, application.encryptionKey, "AES", "Hex")>
                    <div class="address-card">
                        <div class="address-line">
                            <strong>#variables.displayUserAddressQry.fldFirstName#</strong>, 
                            <span>#variables.displayUserAddressQry.fldPhonenumber#</span>
                        </div>
                
                        <div class="address-line">
                            #variables.displayUserAddressQry.fldAddressLine1#,
                            #variables.displayUserAddressQry.fldAddressLine2#,
                            #variables.displayUserAddressQry.fldCity#
                        </div>
                
                        <div class="address-line">
                            #variables.displayUserAddressQry.fldState# - #variables.displayUserAddressQry.fldPincode#
                        </div>
                        <div class="address-buttons">
                            <button 
                                class="btn btn-sm btn-outline-primary me-2 editAddress"
                                id="editAddressBtn"
                                data-bs-toggle="modal" 
                                data-bs-target="##createUserAddressModal"
                                data-id="#encryptedId#">
                                <i class="bi bi-pencil-fill"></i> 
                            </button>
                            <button class="btn btn-sm btn-outline-danger me-2 deleteAddress"
                                id="deleteAddressBtn"
                                data-bs-toggle="modal" 
                                data-bs-target="##deleteAddressConfirmModal"
                                data-id="#encryptedId#">
                                <i class="bi bi-trash-fill"></i> 
                            </button>
                        </div>
                    </div>
                </cfoutput>
            </div>
        </div>

    
        <div class="profile-actions">
            <button class="btn btn-outline-success addAdress"
                id="createUserAddressBtn"
                data-bs-toggle="modal" 
                data-bs-target="#createUserAddressModal">
                Add New Address
            </button>

             <button class="btn btn-outline-primary">Order Details</button>
        </div>

        <div class="modal fade" 
			id="createUserAddressModal"
            data-bs-backdrop="static" 
			data-bs-keyboard="false" 
			tabindex="-1" 
			aria-labelledby="createUserAddressLabel" 
			aria-hidden="true">
    		<div class="modal-dialog">
        	    <div class="modal-content">
            		<div class="modal-header">
                		<h5 class="modal-title mx-auto d-block" id="createUserAddressLabel">Add New Address</h5>
                    </div>

                    <div class="modal-body">
                        <form method="post" id="userAddressForm" action="">
                            <div class="form-group pt-1">
                        		<label for="firstName">First Name</label>
                        		<input type="text" class="form-control" id="firstName" name="firstName" placeholder="Enter First Name">
                    		</div>
                    		<div class="form-group pt-2">
                        		<label for="lastName">Last Name</label>
                        		<input type="text" class="form-control" id="lastName" name="lastName" placeholder="Enter Last Name">
                    		</div>  
                            <div class="form-group pt-2">
                        		<label for="addressLine1">Address Line1</label>
                        		<input type="text" class="form-control" id="addressLine1" name="addressLine1" placeholder="Enter Address Line1">
                    		</div>   
                            <div class="form-group pt-2">
                        		<label for="addressLine2">Address Line2</label>
                        		<input type="text" class="form-control" id="addressLine2" name="addressLine2" placeholder="Enter Address Line2">
                    		</div> 
                            <div class="form-group pt-2">
                        		<label for="city">City</label>
                        		<input type="text" class="form-control" id="city" name="city" placeholder="Enter City">
                    		</div> 
                            <div class="form-group pt-2">
                        		<label for="city">State</label>
                        		<input type="text" class="form-control" id="state" name="state" placeholder="Enter State">
                    		</div>
                            <div class="form-group pt-2">
                        		<label for="city">Pincode</label>
                        		<input type="number" class="form-control" id="pincode" name="pincode" placeholder="Enter pincode">
                    		</div>
                            <div class="form-group pt-2">
                        		<label for="phoneNumber">Phone Number</label>
                        		<input type="text" class="form-control" id="phoneNumber" name="phoneNumber" placeholder="Enter Phone Number">
                    		</div>

                            <div class="form-group pt-1 mt-3">
                                <button type="button" class="btn btn-secondary mb-3" data-bs-dismiss="modal">Cancel</button>
                                <button type="button" name="saveUserAddressButton" class="btn btn-success mb-3" id="saveUserAddressButton">Submit</button>
                                <button type="button" name="editUserAddressButton" class="btn btn-success mb-3" id="editUserAddressButton">Update</button>
                            </div>
                                        
                            <div id="errorMessages"></div>
                        </form>
                    </div>
            	</div>
            </div>
        </div>

        
        <div class="modal fade" 
			id="deleteAddressConfirmModal" 
            data-bs-backdrop="static" 
			data-bs-keyboard="false"
			tabindex="-1" 
			aria-labelledby="deleteAddressConfirmLabel" 
			aria-hidden="true">
    		<div class="modal-dialog">
        		<div class="modal-content">
            		<div class="modal-header">
                		<h5 class="modal-title mx-auto d-block" id="deleteAddressConfirmLabel">CONFIRM DELETION</h5>
                		<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            		</div>
            		<div class="modal-body">
                		Are you sure you want to delete this Address?
            		</div>
            		<div class="modal-footer">
                		<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-danger" id="confirmAddressDeleteButton">Delete</button>
            		</div>
        		</div>
    		</div>
		</div>
    </div>
    


           
        
    


    <cfinclude template="footer.cfm">
</body>
</html>