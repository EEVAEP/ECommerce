$(document).ready(function() {
	var categoryId;
	
	$('#createCategoryBtn').on('click',function(){
		document.getElementById("createCategoryLabel").innerText = "Add Categories";
		$('#categoryForm').trigger('reset');
		$('#saveCategoryButton').show();
		$('#editCategoryButton').hide();
		$('#errorMessages').empty();
		
	});


    $('#saveCategoryButton').click(function(event) {
        event.preventDefault();
        
        var categoryName = $('#categoryName');
        
        var formData = new FormData();
		formData.append('categoryName', categoryName.val());
        for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }

        $.ajax({
			url:'../../model/AdminCategory.cfc?method=validateCategoryDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#createCategoryModal').modal('hide');
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

	$(document).on('click', '.edit', function() {
		document.getElementById('saveCategoryButton').style.display="none";
		document.getElementById("createCategoryLabel").innerText = "Edit Category";
		$('#editCategoryButton').show();
		$('#errorMessages').empty();

		categoryId = $(this).data('id');
		console.log(categoryId);

		$('#categoryId').val(categoryId);

		$.ajax({
			url:'../../model/AdminCategory.cfc?method=getCategoryById',
			type:'POST',
			data:{
				categoryById:categoryId
			},
			success:function(response){
                
				let data = JSON.parse(response);
				console.log(data);	
				let categoryName = data.DATA[0][1];
			 	$('#categoryName').val(categoryName);
				
			 },
			 error:function(){
			 	console.log("Request Failed");
			}
		});

	});


	$('#editCategoryButton').on('click',function(event){	
		event.preventDefault();
		var categoryName=$('#categoryName');

		var formData = new FormData();
		formData.append('categoryName', categoryName.val());
		formData.append('categoryId',categoryId);
		
        
		$.ajax({
			url:'../../model/AdminCategory.cfc?method=validateCategoryDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#createCategoryModal').modal('hide');
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

document.addEventListener("DOMContentLoaded", function () {
	document.querySelectorAll(".delete").forEach(function(button) {
		button.addEventListener("click", function() {
				var categoryId = this.getAttribute("data-id");
				console.log("Category ID to delete:", categoryId);

				if (categoryId) {
					document.getElementById("confirmDeleteButton").setAttribute("data-category-id", categoryId);
				} else {
					alert("Error: Category ID is missing or undefined.");
				}
		});
	});

	document.getElementById("confirmDeleteButton").addEventListener("click", function () {
		const categoryId = this.getAttribute("data-category-id");
		console.log("Contact ID from confirm button:", categoryId);

		if (!categoryId) {
				alert("Error: No category ID available for deletion.");
				return;
		}

		$.ajax({
			type: "POST",
			url: "../../model/AdminCategory.cfc?method=deleteCategory",
    		data: { categoryId: categoryId },
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
					const rowToDelete = document.querySelector(`tr[data-id="${categoryId}"]`);
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
    const categoryId = $(this).data("id");
    
    if (categoryId) {
        window.location.href = `SubCategory.cfm?categoryId=${encodeURIComponent(categoryId)}`;
    } else {
        alert("Category ID is missing.");
    }
});


