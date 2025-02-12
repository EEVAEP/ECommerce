document.addEventListener("DOMContentLoaded", function () {
	document.querySelectorAll(".deleteProduct").forEach(function (button) {
		button.addEventListener("click", function () {
			var productId = this.getAttribute("data-id");
			if (productId) {
				document.getElementById("confirmDeleteButton").setAttribute("data-product-id", productId);
			} else {
				alert("Error: Product ID is missing or undefined.");
			}
		});
	});
	document.getElementById("confirmDeleteButton").addEventListener("click", function () {
		const productId = this.getAttribute("data-product-id");
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
						location.reload();
					} else {
						console.log("Cart item not found for deletion");
					}
				}
			}
		});
	});
});

$(document).ready(function () {
	var addressId;
	var editUserId;
	$(document).on('click', '.increase', function () {
		productId = $(this).data('id');
		$.ajax({
			url: '../../model/UserPage.cfc?method=increaseOrDecreaseCartProduct',
			type: 'POST',
			data: {
				productId: productId,
				mode: "1"
			},
			dataType: "json",
			success: function (response) {
				console.log(response);
				if (response.STATUS == "success") {
					location.reload();
				}
				else {
					console.log("error");
				}
			},
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	$(document).on('click', '.decrease', function () {
		productId = $(this).data('id');
		$.ajax({
			url: '../../model/UserPage.cfc?method=increaseOrDecreaseCartProduct',
			type: 'POST',
			data: {
				productId: productId,
				mode: "0"
			},
			dataType: "json",
			success: function (response) {
				console.log(response);
				if (response.STATUS == "success") {
					location.reload();
				}
				else {
					console.log("error");
				}
			},
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	$('#createUserAddressBtn').on('click', function () {
		document.getElementById("createUserAddressLabel").innerText = "Add New Address";
		$('#userAddressForm').trigger('reset');
		$('#saveCategoryButton').show();
		$('#editUserAddressButton').hide();
		$('#errorAddressMessages').empty();
	});
	$('#saveUserAddressButton').click(function (event) {
		event.preventDefault();
		$.ajax({
			url: '../../model/UserPage.cfc?method=validateUserProfileDetails',
			type: 'POST',
			data: {
				firstName: $('#firstName').val(),
				lastName: $('#lastName').val(),
				addressLine1: $('#addressLine1').val(),
				addressLine2: $('#addressLine2').val(),
				city: $('#city').val(),
				state: $('#state').val(),
				pincode: $('#pincode').val(),
				phoneNumber: $('#phoneNumber').val()
			},
			success: function (response) {
				console.log(response);
				let data = JSON.parse(response);
				console.log(data);
				if (data.length === 0) {
					$('#createUserAddressModal').modal('hide');
					location.reload();
				}
				else {
					addOnError(data);
				}
			},
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	/* Populate User Details in Edit modal */
	$(document).on('click', '.editUser', function () {
		$('#errorMessages1').empty();
		editUserId = $(this).data('id');
		console.log(editUserId);
		$.ajax({
			url: '../../model/UserPage.cfc?method=getUserDetailsById',
			type: 'POST',
			data: {
				editUserId: editUserId
			},
			success: function (response) {
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
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	/* Edit User Details */
	$('#editUserDetailsButton').on('click', function (event) {
		event.preventDefault();
		$.ajax({
			url: '../../model/UserPage.cfc?method=validateUserDetails',
			type: 'POST',
			data: {
				firstName: $('#fname').val(),
				lastName: $('#lname').val(),
				email: $('#email').val(),
				phone: $('#phone').val(),
				editUserId: editUserId
			},
			success: function (response) {
				console.log(response);
				let data = JSON.parse(response);
				console.log(data);
				if (data.length === 0) {
					$('#editUserdetailsModal').modal('hide');
					location.reload();
				}
				else {
					addOnErrorUser(data);
				}
			},
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	function addOnErrorUser(errors) {
		let errorContainer = $('#errorMessages1');
		errorContainer.empty();
		if (errors.length > 0) {
			let errorHTML = '<div class="alert alert-danger">';
			errors.forEach(function (error) {
				errorHTML += '<div>' + error + '</div>';
			});
			errorHTML += '</div>';
			errorContainer.append(errorHTML);
		}
	}
	function addOnError(errors) {
		console.log("entered");
		let errorContainer = $('#errorAddressMessages');
		errorContainer.empty();
		if (errors.length > 0) {
			let errorHTML = '<div class="alert alert-danger">';
			errors.forEach(function (error) {
				errorHTML += '<div>' + error + '</div>';
			});
			errorHTML += '</div>';
			errorContainer.append(errorHTML);
		}
	}
});

document.querySelectorAll(".deleteAddress").forEach(function (button) {
	button.addEventListener("click", function () {
		var addressId = this.getAttribute("data-id");
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
