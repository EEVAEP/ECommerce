$(document).ready(function() {

    
	
	$('#createProductBtn').on('click',function(){
		document.getElementById("createProductLabel").innerText = "Add Product";
		$('#productForm').trigger('reset');
		$('#saveProductButton').show();
		$('#editProductButton').hide();
		$('#errorMessages').empty();
		
	});


    $('#saveProductButton').click(function(event) {
        event.preventDefault();
        
        var categoryId = $('#categoryName');
        var subCategoryId = $('#subCategoryName');
        var productName = $('#productName');
        var productBrand = $('#productBrand');
        var productDescription = $('#productDescription');
        var productPrice = $('#productPrice');
        var productTax = $('#productTax');
        

        var fileInput = $('#productImg')[0];
		var file=fileInput.files[0];
        
        var formData = new FormData();
		formData.append('categoryId', categoryId.val());
        formData.append('subCategoryId', subCategoryId.val());
        formData.append('productName', productName.val());
        formData.append('productBrand', productBrand.val());
        formData.append('productDescription', productDescription.val());
        formData.append('productPrice', productPrice.val());
        formData.append('productTax', productTax.val());
        formData.append('productImg', file);
        
        for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }

        $.ajax({
			url:'../../model/AdminCategory.cfc?method=validateProductDetails',
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
