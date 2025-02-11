
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