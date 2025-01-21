$(document).ready(function() {
	var productId;
    
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
        
		var formData = new FormData();
		formData.append('categoryId', categoryId.val());
        formData.append('subCategoryId', subCategoryId.val());
        formData.append('productName', productName.val());
        formData.append('productBrand', productBrand.val());
        formData.append('productDescription', productDescription.val());
        formData.append('productPrice', productPrice.val());
        formData.append('productTax', productTax.val());
        
		let productImg = $('#productImg')[0].files;
        if(productImg.length < 3){
            alert('Please select atleast 3 images for products');
        }
        else{
            for(i=0 ; i<productImg.length;i++){
                formData.append('productImg',productImg[i]);
            }          
        }       
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
			 		$('#createProductModal').modal('hide');
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
		document.getElementById('saveProductButton').style.display="none";
		document.getElementById("createProductLabel").innerText = "Edit Product";
		$('#editProductBtn').show();
		$('#errorMessages').empty();

		productId = $(this).data('id');
		console.log(productId);

		$.ajax({
			url:'../../controller/AdminProduct.cfc?method=getProductById',
			type:'POST',
			data:{
				productId:productId
			},
			success:function(response){
				let data = JSON.parse(response);
				console.log(data);

				var categoryName = $('#categoryName');
				var subCategoryName = $('#subCategoryName');
				var productName = $('#productName');
        		var productBrand = $('#productBrand');
        		var productDescription = $('#productDescription');
        		var productPrice = $('#productPrice');
        		var productTax = $('#productTax');


				categoryName.val(data[data.length - 1].categoryId);
				subCategoryName.val(data[data.length - 1].subCategoryId);
				productName.val(data[data.length - 1].productName);
            	productBrand.val(data[data.length - 1].productBrand);
            	productDescription.val(data[data.length - 1].productDescription);
            	productPrice.val(data[data.length - 1].productPrice);
            	productTax.val(data[data.length - 1].productTax);
            	
				let imgList = $('#img-list');
            	imgList.css({
            		display: 'flex',
            		flexDirection: 'column',
            		gap: '10px'   
           		 });
            	for (let i = 0 ;i<data.length - 1; i++){                       
                	var liItem = $('<li>').css({
                    	display: 'flex',
                    	justifyContent: 'space-between', 
                    	alignItems: 'center',
                	});
                        
					var spanImg = $('<span>', { class: 'image-container' }).append(
                    	$('<img>', { 
                        	src: `../../uploads/${data[i].imageFile}`, 
                        	alt: 'prodimg' ,
                        	width : 30,
                        	height : 30
                    		}
                   		 ),
                    	$('<span>', {  
                        	text: data[i].imageFile,
                        	class: [`image_${i}_name`, 'image_names'].join(' ')  
                        	})
                	);
                	var spanClose = $('<button>',{class : 'img-dlt-btn',img_id : data[i].imageId,type : 'button'}).append(
						$('<i>', { class: 'fa-solid fa-x'})
					);
            		liItem.append(spanImg).append(spanClose);
            		imgList.append(liItem);
           	 	}
       		},
		 	error:function(){
				console.log("Request Failed");
			}
		});

	});


	$('#editProductButton').on('click',function(event){	
		event.preventDefault();

		var categoryName = $('#categoryName');
		var subCategoryName = $('#subCategoryName');
		var productName = $('#productName');
        var productBrand = $('#productBrand');
        var productDescription = $('#productDescription');
        var productPrice = $('#productPrice');
        var productTax = $('#productTax');


		var formData = new FormData();
		
		formData.append('categoryId', categoryName.val());
        formData.append('subCategoryId', subCategoryName.val());
		formData.append('productName', productName.val());
		formData.append('productBrand', productBrand.val());
		formData.append('productDescription', productDescription.val());
		formData.append('productPrice', productPrice.val());
		formData.append('productTax', productTax.val());
		formData.append('productId', productId);

		let productImages = $('#productImg')[0].files;
        if(productImages.length > 0){
            for(i=0 ; i<productImages.length;i++){
                formData.append('productImg',productImages[i]);
            }            
        }
		
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
			 		$('#createProductModal').modal('hide');
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


	// Product Image Delete //
	$('#img-list').on('click','.img-dlt-btn',function(){
        imageId = $(this).attr('img_id');
		let button = $(this);
        let formData = new FormData();
        formData.append('imageId',imageId);
		formData.append('productId',productId);
        console.log(imageId);
		for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
        $.ajax({
            url : "../../controller/AdminProduct.cfc?method=deleteImage",
            method : 'POST' ,
            data : formData ,
            processData : false,
            contentType : false,
            success : function(response){
                    console.log("Success");
                    let data = JSON.parse(response);
                    if(data === "Success"){
                        button.closest('li').remove();
                    }
                    else{
                        addError(data);
                    }
            },
            error : function(){
                console.log("Request failed") ;
            }           
        })
    });

	$(document).on('click', '.view', function() {
		
		productId = $(this).data('id');
		console.log(productId);
		$.ajax({
			url:'../../model/AdminCategory.cfc?method=getProductDetails',
			type:'POST',
			data:{
				productId:productId
			},
			success:function(response){
				const data=JSON.parse(response);
				console.log(data);
				
				
            	let viewProductName= data.DATA[0][0];
				let viewProductBrand= data.DATA[0][3];
				let viewProductPrice= data.DATA[0][4];
				let viewProductTax= data.DATA[0][5];
				let viewProductDescription= data.DATA[0][8];
				
				
				let basePath = "../../uploads/";
				let viewPhotoSrc = basePath + data.DATA[0][7];
				$('#viewPhoto').attr('src', viewPhotoSrc);

				$('#viewProductName').text(viewProductName);
				$('#viewProductBrand').text(viewProductBrand);
				$('#viewProductPrice').text(viewProductPrice);
				$('#viewProductTax').text(viewProductTax);
				$('#viewProductDescription').text(viewProductDescription);

				

				
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
				alert("Error: No SubCategory ID available for deletion.");
				return;
		}

		$.ajax({
			type: "POST",
			url: "../../model/AdminCategory.cfc?method=deleteproduct",
    		data: {productId: productId },
			dataType: "json",

			success: function (response) {
				console.log("AJAX response:", response);
				if (response.STATUS == "success") {	
					console.log("Deleting contact...");
		
				
					const deleteModalElement = document.getElementById("deleteProductConfirmModal");
					const deleteModal = bootstrap.Modal.getInstance(deleteModalElement);
					if (deleteModal) {
							deleteModal.hide();
					}
					document.body.classList.remove('modal-open');
					const backdrop = document.querySelector('.modal-backdrop');
					if (backdrop) {
						backdrop.remove();
					}
					const rowToDelete = document.querySelector(`tr[data-id="${productId}"]`);
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
