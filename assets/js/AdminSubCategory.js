$(document).ready(function () {
	var subCategoryId;
	$('#createSubCategoryBtn').on('click', function () {
		document.getElementById("createSubCategoryLabel").innerText = "Add SubCategories";
		$('#subCategoryForm').trigger('reset');
		$('#saveSubCategoryButton').show();
		$('#editSubCategoryButton').hide();
		$('#errorMessages').empty();

	});
	$('#saveSubCategoryButton').click(function (event) {
		event.preventDefault();
		var categoryName = $('#categoryName');
		var subCategoryName = $('#subCategoryName');
		var formData = new FormData();
		formData.append('categoryName', categoryName.val());
		formData.append('subCategoryName', subCategoryName.val());
		for (let [key, value] of formData.entries()) {
			console.log(key + ':', value);
		}
		$.ajax({
			url: '../../model/AdminCategory.cfc?method=validateSubCategoryDetails',
			type: 'POST',
			data: formData,
			processData: false,
			contentType: false,
			success: function (response) {
				console.log(response);
				let data = JSON.parse(response);
				console.log(data);
				if (data.length === 0) {
					$('#createCategoryModal').modal('hide');
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
	$(document).on('click', '.edit', function () {
		document.getElementById('saveSubCategoryButton').style.display = "none";
		document.getElementById("createSubCategoryLabel").innerText = "Edit SubCategory";
		$('#editSubCategoryButton').show();
		$('#errorMessages').empty();
		subCategoryId = $(this).data('id');
		console.log(subCategoryId);
		$.ajax({
			url: '../../model/AdminCategory.cfc?method=getSubCategoryById',
			type: 'POST',
			data: {
				subCategoryById: subCategoryId
			},
			success: function (response) {
				let data = JSON.parse(response);
				console.log(data);
				let subCategoryName = data.DATA[0][1];
				let categoryName = data.DATA[0][3];
				$('#categoryName').val(categoryName);
				$('#subCategoryName').val(subCategoryName);
			},
			error: function () {
				console.log("Request Failed");
			}
		});
	});
	$('#editSubCategoryButton').on('click', function (event) {
		event.preventDefault();
		var categoryName = $('#categoryName');
		var subCategoryName = $('#subCategoryName');
		var formData = new FormData();
		formData.append('categoryName', categoryName.val());
		formData.append('subCategoryName', subCategoryName.val());
		formData.append('subCategoryId', subCategoryId);
		for (let [key, value] of formData.entries()) {
			console.log(key + ':', value);
		}
		$.ajax({
			url: '../../model/AdminCategory.cfc?method=validateSubCategoryDetails',
			type: 'POST',
			data: formData,
			processData: false,
			contentType: false,
			success: function (response) {
				console.log(response);
				let data = JSON.parse(response);
				console.log(data);
				if (data.length === 0) {
					$('#createCategoryModal').modal('hide');
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
});
function addOnError(errors) {
	$('#errorMessages').empty();

	errors.forEach(function (error) {
		$('#errorMessages').append('<div class="alert alert-danger">' + error + '</div>');
	});
}
document.addEventListener("DOMContentLoaded", function () {
	document.querySelectorAll(".delete").forEach(function (button) {
		button.addEventListener("click", function () {
			var subCategoryId = this.getAttribute("data-id");
			console.log("SubCategory ID to delete:", subCategoryId);
			if (subCategoryId) {
				document.getElementById("confirmDeleteButton").setAttribute("data-SubCategory-id", subCategoryId);
			} else {
				alert("Error: SubCategory ID is missing or undefined.");
			}
		});
	});
	document.getElementById("confirmDeleteButton").addEventListener("click", function () {
		const subCategoryId = this.getAttribute("data-SubCategory-id");
		console.log("Category ID from confirm button:", subCategoryId);
		if (!subCategoryId) {
			alert("Error: No SubCategory ID available for deletion.");
			return;
		}
		$.ajax({
			type: "POST",
			url: "../../model/AdminCategory.cfc?method=deleteSubCategory",
			data: { subCategoryId: subCategoryId },
			dataType: "json",
			success: function (response) {
				console.log("AJAX response:", response);
				if (response.STATUS == "success") {
					console.log("Deleting contact...");
					const deleteModalElement = document.getElementById("deleteSubConfirmModal");
					const deleteModal = bootstrap.Modal.getInstance(deleteModalElement);
					if (deleteModal) {
						deleteModal.hide();
					}
					document.body.classList.remove('modal-open');
					const backdrop = document.querySelector('.modal-backdrop');
					if (backdrop) {
						backdrop.remove();
					}
					const rowToDelete = document.querySelector(`tr[data-id="${subCategoryId}"]`);
					if (rowToDelete) {
						rowToDelete.remove();
						console.log("Row deleted:", rowToDelete);
					} else {
						console.log("Row not found for deletion");
					}
				}
			}
		});
	});
});
$(document).on("click", ".view", function () {
	const subCategoryId = $(this).data("id");

	if (subCategoryId) {
		window.location.href = `ProductPage.cfm?subCategoryId=${encodeURIComponent(subCategoryId)}`;
	} else {
		alert("Category ID is missing.");
	}
});

