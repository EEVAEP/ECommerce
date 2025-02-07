document.addEventListener("DOMContentLoaded", function () {
	document.querySelectorAll(".deleteProduct").forEach(function(button) {
		button.addEventListener("click", function() {
				var productId = this.getAttribute("data-id");
				console.log("Product ID to delete:", productId);

				if (productId) {
					document.getElementById("confirmDeleteButton").setAttribute("data-product-id", productId);
				} else {
					alert("Error: Product ID is missing or undefined.");
				}
		});
	});
	document.getElementById("confirmDeleteButton").addEventListener("click", function () {
		const productId = this.getAttribute("data-product-id");
		console.log("Product ID from confirm button:", productId);

		if (!productId) {
				alert("Error: No product ID available for deletion.");
				return;
		}
		$.ajax({
			type: "POST",
			url: "../../model/UserPage.cfc?method=deleteCartProduct",
    		data: { productId: productId },
			dataType: "json",
			success: function (response) {
				console.log("AJAX response:", response);
				if (response.STATUS == "success") {	
					console.log("Deleting contact...");
					const deleteModalElement = document.getElementById("deleteConfirmModal");
					const deleteModal = bootstrap.Modal.getInstance(deleteModalElement);
					if (deleteModal) {
							deleteModal.hide();
					}
					document.body.classList.remove('modal-open');
					const backdrop = document.querySelector('.modal-backdrop');
					if (backdrop) {
						backdrop.remove();
					}
					const cartItemToDelete = document.querySelector(`.cart-item .btn-remove[data-id="${productId}"]`).closest('.cart-item');
            		if (cartItemToDelete) {
                		cartItemToDelete.remove();
                		console.log("Cart item deleted:", cartItemToDelete);
						location.reload();
            		} else {
                		console.log("Cart item not found for deletion");
            		}
				} 
			}
		});
	});
});
$(document).ready(function() {
	var addressId;
	var editUserId;
	$(document).on('click', '.increase', function() {
		productId = $(this).data('id');
		console.log(productId);
		var formData = new FormData();
		
		formData.append('productId',productId);
		formData.append('mode', "1");
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
		$.ajax({
			url:'../../model/UserPage.cfc?method=increaseOrDecreaseCartProduct',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			dataType: "json",
			success:function(response){
                console.log(response);
				if (response.STATUS == "success") {	
					console.log("Updated quantity...");
					location.reload();
				}
			 	else{
			 		console.log("error");
			 	}
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});

	});

	$(document).on('click', '.decrease', function() {
		productId = $(this).data('id');
		console.log(productId);
		var formData = new FormData();
		
		formData.append('productId',productId);
		formData.append('mode', "0");
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
		$.ajax({
			url:'../../model/UserPage.cfc?method=increaseOrDecreaseCartProduct',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			dataType: "json",
			success:function(response){
                console.log(response);
				if (response.STATUS == "success") {	
					console.log("Updated quantity...");
					location.reload();
				}
			 	else{
			 		console.log("error");
			 	}
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});
	});
	$('#createUserAddressBtn').on('click',function(){
		document.getElementById("createUserAddressLabel").innerText = "Add New Address";
		$('#userAddressForm').trigger('reset');
		$('#saveCategoryButton').show();
		$('#editUserAddressButton').hide();
		$('#errorMessages').empty();
		
	});

	$('#saveUserAddressButton').click(function(event) {
        event.preventDefault();
        let firstName = $('#firstName');
		let lastName = $('#lastName');
		let addressLine1 = $('#addressLine1');
		let addressLine2 = $('#addressLine2');
		let city = $('#city');
		let state = $('#state');
		let pincode = $('#pincode');
		let phoneNumber = $('#phoneNumber');
        
        let formData = new FormData();
		formData.append('firstName', firstName.val());
		formData.append('lastName', lastName.val());
		formData.append('addressLine1', addressLine1.val());
		formData.append('addressLine2', addressLine2.val());
		formData.append('city', city.val());
		formData.append('state', state.val());
		formData.append('pincode', pincode.val());
		formData.append('phoneNumber', phoneNumber.val());
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
		$.ajax({
			url:'../../model/UserPage.cfc?method=validateUserProfileDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#createUserAddressModal').modal('hide');
			 		location.reload();
			 	}
			 	else{
			 		addOnError(data);
			 	}
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});
	});
	/* Populate User Profle in Edit modal */
	$(document).on('click', '.editAddress', function() {
		document.getElementById('saveUserAddressButton').style.display="none";
		document.getElementById("createUserAddressLabel").innerText = "Edit Address";
		$('#editUserAddressButton').show();
		$('#errorMessages').empty();
		addressId = $(this).data('id');
		console.log(addressId);
		$.ajax({
			url:'../../model/UserPage.cfc?method=getUserAddressById',
			type:'POST',
			data:{
				addressId:addressId
			},
			success:function(response){
                let data = JSON.parse(response);
				console.log(data);	
				let firstName = data.DATA[0][1];
				let lastName = data.DATA[0][2];
				let addressLine1 = data.DATA[0][3];
				let addressLine2 = data.DATA[0][4];
				let city = data.DATA[0][5];
				let state = data.DATA[0][6];
				let pincode = data.DATA[0][7];
				let phoneNumber = data.DATA[0][8];

			 	$('#firstName').val(firstName);
				$('#lastName').val(lastName);
				$('#addressLine1').val(addressLine1);
				$('#addressLine2').val(addressLine2);
				$('#city').val(city);
				$('#state').val(state);
				$('#pincode').val(pincode);
				$('#phoneNumber').val(phoneNumber);
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});

	});
	/* Edit User Profile */
	$('#editUserAddressButton').on('click',function(event){	
		event.preventDefault();
		var firstName = $('#firstName');
		var lastName = $('#lastName');
		var addressLine1 = $('#addressLine1');
		var addressLine2 = $('#addressLine2');
		var city = $('#city');
		var state = $('#state');
		var pincode = $('#pincode');
		var phoneNumber = $('#phoneNumber');

		var formData = new FormData();
		formData.append('firstName', firstName.val());
		formData.append('lastName', lastName.val());
		formData.append('addressLine1', addressLine1.val());
		formData.append('addressLine2', addressLine2.val());
		formData.append('city', city.val());
		formData.append('state', state.val());
		formData.append('pincode', pincode.val());
		formData.append('phoneNumber', phoneNumber.val());
		formData.append('addressId', addressId);
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
        $.ajax({
			url:'../../model/UserPage.cfc?method=validateUserProfileDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#createUserAddressModal').modal('hide');
			 		location.reload();
			 	}
			 	else{
			 		addOnError(data);
			 	}
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});
	});

	/* Populate User Details in Edit modal */
	$(document).on('click', '.editUser', function() {
		$('#errorMessages').empty();
		editUserId = $(this).data('id');
		console.log(editUserId);
		$.ajax({
			url:'../../model/UserPage.cfc?method=getUserDetailsById',
			type:'POST',
			data:{
				editUserId:editUserId
			},
			success:function(response){
                let data = JSON.parse(response);
				console.log(data);	
				let firstName = data.DATA[0][1];
				let lastName = data.DATA[0][2];
				let email = data.DATA[0][3]
				let phone = data.DATA[0][4];

			 	$('#fname').val(firstName);
				$('#lname').val(lastName);
				$('#email').val(email);
				$('#phone').val(phone);
			},
			 error:function(){
			 	console.log("Request Failed");
			}
		});

	});
	/* Edit User Details */
	$('#editUserDetailsButton').on('click',function(event){	
		event.preventDefault();
		var firstName = $('#fname');
		var lastName = $('#lname');
		var email = $('#email');
		var phoneNumber = $('#phone');

		var formData = new FormData();
		formData.append('firstName', firstName.val());
		formData.append('lastName', lastName.val());
		formData.append('email', email.val());
		formData.append('phone', phoneNumber.val());
		formData.append('editUserId', editUserId);
		
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
        
		$.ajax({
			url:'../../model/UserPage.cfc?method=validateUserDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#editUserdetailsModal').modal('hide');
			 		location.reload();
			 	}
			 	else{
			 		addOnError(data);
			 	}
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});

	});
});

function addOnError(errors) {
	$('#errorMessages').empty();

	 errors.forEach(function(error) {
        	$('#errorMessages').append('<div class="alert alert-danger">' + error + '</div>');
 	});
}
document.querySelectorAll(".deleteAddress").forEach(function(button) {
	button.addEventListener("click", function() {
			var addressId = this.getAttribute("data-id");
			console.log("Address ID to delete:", addressId);

			if (addressId) {
				document.getElementById("confirmAddressDeleteButton").setAttribute("data-address-id", addressId);
			} else {
				alert("Error: Address ID is missing or undefined.");
			}
	});
});
document.addEventListener("DOMContentLoaded", function () {
	document.getElementById("confirmAddressDeleteButton").addEventListener("click", function () {
		const addressId = this.getAttribute("data-address-id");
		console.log("Address ID from confirm button:", addressId);
		if (!addressId) {
				alert("Error: No Address ID available for deletion.");
				return;
		}
		$.ajax({
			type: "POST",
			url: "../../model/UserPage.cfc?method=deleteUserAddress",
			data: { addressId: addressId },
			dataType: "json",

			success: function (response) {
				console.log("AJAX response:", response);
				if (response.STATUS == "success") {	
					console.log("Deleting contact...");
					const deleteModalElement = document.getElementById("deleteAddressConfirmModal");
					const deleteModal = bootstrap.Modal.getInstance(deleteModalElement);
					if (deleteModal) {
							deleteModal.hide();
					}
					document.body.classList.remove('modal-open');
					const backdrop = document.querySelector('.modal-backdrop');
					if (backdrop) {
						backdrop.remove();
					}
					const AddressItemToDelete = document.querySelector(`.address-card .deleteAddress[data-id="${addressId}"]`).closest('.address-card');
					if (AddressItemToDelete) {
						AddressItemToDelete.remove();
						console.log("Address item deleted:", AddressItemToDelete);
					} else {
							console.log("Address item not found for deletion");
					}
				
				} 
			
			}
		});
	});

});
