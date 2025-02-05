
$(document).ready(function () {
    var totalAmount = parseFloat($(".actualPrice").val()) || 0; 
    var totalTax = parseFloat($(".actualTax").val()) || 0;
    var unitTax = parseFloat($(".unitTax").val()) || 0;
    var unitPrice = parseFloat($(".productPrice").val()) || 0;
    var currentQuantity = 1;
    
    $(".OrderIncrease, .OrderDecrease").click(function () {
        let quantitySpan = $(this).siblings(".quantity");
        currentQuantity = parseInt(quantitySpan.text());

        if ($(this).hasClass("OrderIncrease")) {
            currentQuantity++;
        } else if ($(this).hasClass("OrderDecrease") && currentQuantity > 1) {
            currentQuantity--;
        } 
        quantitySpan.text(currentQuantity); 
        updatePayableAmount($(this)); 
    });

    function updatePayableAmount(button) {
        let quantity = parseInt(button.siblings(".quantity").text());
        let productPrice = parseFloat(button.closest(".section").find(".productPrice").val());
        let actualPrice = parseFloat(button.closest(".section").find(".actualPrice").val());
        let actualTax = parseFloat(button.closest(".section").find(".actualTax").val());
        totalTax = quantity * actualTax;
        totalAmount = quantity * actualPrice;
        console.log(quantity);
        console.log(productPrice);
        console.log(totalAmount);
        console.log(actualPrice);
        console.log(totalTax);
        button.closest(".section").siblings(".OrderAmount").find(".payableAmount").text(totalAmount.toFixed(2)); 
    }
    $('#createPaymentBtn').on('click',function(){
		document.getElementById("createPaymentLabel").innerText = "Payment Details";
		$('#paymentForm').trigger('reset');
		$('#errorMessages').empty();
		
	});

    $('#payButton').click(function(event) {
        event.preventDefault();
        var cardNumber = $('#cardNumber');
        var cvv = $('#cvv');
        var addressId = $('#addressId');
        var productId = $('#productId');
        var formData = new FormData();
		formData.append('cardNumber', cardNumber.val());
        formData.append('cvv', cvv.val());
        formData.append('totalPrice', totalAmount);
        formData.append('totalTax', totalTax);
        formData.append('unitTax', unitTax);
        formData.append('unitPrice', unitPrice);
        formData.append('quantity', currentQuantity);
        formData.append('addressId', addressId.val());
        formData.append('productId', productId.val());
        for (let [key, value] of formData.entries()) {
            console.log(key + ':', value);
        }
        $.ajax({
			url:'../../model/UserPage.cfc?method=validateCardDetails',
			type:'POST',
			data:formData,
			processData:false,
			contentType:false,
			success:function(response){
                console.log(response);
				let data = JSON.parse(response);
				console.log(data);	
			 	if(data.length === 0){
			 		$('#createPaymentModal').modal('hide');
                    window.location.href = "PaymentSuccessful.cfm"
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






