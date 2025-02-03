
$(document).ready(function () {
    $(".OrderIncrease, .OrderDecrease").click(function () {
        let quantitySpan = $(this).siblings(".quantity");
        let currentQuantity = parseInt(quantitySpan.text());

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
        let totalAmount = quantity * productPrice;
        console.log(quantity);
        console.log(productPrice);
        console.log(totalAmount);

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
        var formData = new FormData();
		formData.append('cardNumber', cardNumber.val());
        formData.append('cvv', cvv.val());
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






