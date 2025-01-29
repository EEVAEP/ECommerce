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
});

