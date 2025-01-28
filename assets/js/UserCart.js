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

	});
});