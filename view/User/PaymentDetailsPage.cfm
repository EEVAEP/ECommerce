<cfinclude template = "Header.cfm">
<cfif structKeyExists(url, "productId") AND structKeyExists(url, "addressId")>
    <cfset variables.displayOrderAddress = application.modelUserPage.getUserAddress(url.addressId)>
    <cfset variables.displayOrderedProducts = application.modelAdminCtg.getProductsList(productId = url.productId)>
</cfif>
<cfif structKeyExists(url, "addressId") AND NOT structKeyExists(url, "productId")>
    <cfset variables.displayOrderedCartProducts = application.modelUserPage.getCartProductsList()>
    <cfset variables.displayOrderCartAddress = application.modelUserPage.getUserAddress(url.addressId)>
</cfif>
<div class="orderContainer">
    <div class="order-summary">
        <div class="order-header">ORDER SUMMARY</div>
            <div class="order-card">
                <cfif structKeyExists(variables, "displayOrderAddress")>
                    <cfoutput query="variables.displayOrderAddress">
                        <div class="order-section">
                            <p><span class="bold">Selected Address</span></p>
                            <p>#variables.displayOrderAddress.fullname#</p>
                            <p>#variables.displayOrderAddress.fldPhonenumber#</p>
                            <p>#variables.displayOrderAddress.fldAddressLine1#</p>
                            <p>#variables.displayOrderAddress.fldAddressLine2#</p>
                            <p>#variables.displayOrderAddress.fldCity#, #variables.displayOrderAddress.fldState#</p>
                            <p>#variables.displayOrderAddress.fldPincode#</p>
                        </div>
                    </cfoutput>
                <cfelseif structKeyExists(variables, "displayOrderCartAddress")>
                    <cfoutput query="variables.displayOrderCartAddress">
                        <div class="order-section">
                            <p><span class="bold">Selected Address</span></p>
                            <p>#variables.displayOrderCartAddress.fullname#</p>
                            <p>#variables.displayOrderCartAddress.fldPhonenumber#</p>
                            <p>#variables.displayOrderCartAddress.fldAddressLine1#</p>
                            <p>#variables.displayOrderCartAddress.fldAddressLine2#</p>
                            <p>#variables.displayOrderCartAddress.fldCity#, #variables.displayOrderCartAddress.fldState#</p>
                            <p>#variables.displayOrderCartAddress.fldPincode#</p>
                        </div>
                    </cfoutput>
                </cfif>
            </div>
            <cfif structKeyExists(variables, "displayOrderAddress")>
                <div class="order-card">
                    <cfoutput query="variables.displayOrderedProducts">
                        <div class="section OrderProduct">
                            <img src="/uploads/#variables.displayOrderedProducts.fldImageFileName#" alt="Product Image">
                            <div>
                                <p class="bold">#variables.displayOrderedProducts.fldProductName#</p>
                                <p>Brand: #variables.displayOrderedProducts.fldBrandName#</p>
                                <p>Actual Price: #variables.displayOrderedProducts.fldPrice#</p>
                                <p>Tax: #variables.displayOrderedProducts.fldTax#%</p>
                            </div>
                        </div>
                        <cfset variables.ActualPrice = variables.displayOrderedProducts.fldPrice +(variables.displayOrderedProducts.fldPrice * (variables.displayOrderedProducts.fldTax / 100))>
                        <cfset variables.ActualTax = (variables.displayOrderedProducts.fldPrice * (variables.displayOrderedProducts.fldTax / 100))>
                        <div class="section OrderQuantity">
                            <button class="OrderDecrease">-</button>
                                <span class="quantity">1</span>  
                            <button class="OrderIncrease">+</button>
                            <input type="hidden" class="productPrice" value="#variables.displayOrderedProducts.fldPrice#">
                            <input type="hidden" class="actualPrice" value="#variables.ActualPrice#">
                            <input type="hidden" class="actualTax" value="#variables.ActualTax#">
                            <input type="hidden" class="unitTax" value="#variables.displayOrderedProducts.fldTax#">
                        </div>
                        <cfset variables.OrderTotalPrice = 0>
                        <cfset variables.OrderTotalPrice = variables.displayOrderedProducts.fldPrice +(variables.displayOrderedProducts.fldPrice * (variables.displayOrderedProducts.fldTax / 100))>
                        <p class="OrderAmount">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i><span class="payableAmount">#variables.OrderTotalPrice#</p>
                    </cfoutput>
                </div>
            </cfif>
            <!---------------------------------------------------Cart Bought Together----------------------- --->
            <cfif structKeyExists(variables, "displayOrderCartAddress")>
                <div class="order-container">
                    <cfoutput query="variables.displayOrderedCartProducts">
                        <div class="CartOrder-card">
                            <div class="section cartOrderProduct">
                                <img src="/uploads/#variables.displayOrderedCartProducts.fldImageFileName#" alt="Product Image">
                                <div class="CartOrderProduct-details">
                                    <p class="Cartbold">#variables.displayOrderedCartProducts.fldProductName#</p>
                                    <p>Brand: #variables.displayOrderedCartProducts.fldBrandName#</p>
                                    <p>Actual Price: #variables.displayOrderedCartProducts.fldPrice#</p>
                                    <p>Tax: #variables.displayOrderedCartProducts.fldTax#%</p>
                                    <p>Quantity Selected: #variables.displayOrderedCartProducts.fldQuantity#</p>
                                </div>
                            </div>
                        </div>
                    </cfoutput>  
                    <cfset variables.cartActualPrice = 0>
                    <cfset variables.cartTotalTax = 0>
                    <cfset variables.cartTotalPrice = 0>
                    <cfoutput query="variables.displayOrderedCartProducts">
                        <cfset variables.itemActualPrice =variables.displayOrderedCartProducts.fldPrice *variables.displayOrderedCartProducts.fldQuantity>
                        <cfset variables.itemTotalTax = (variables.displayOrderedCartProducts.fldPrice * (variables.displayOrderedCartProducts.fldTax / 100)) *variables.displayOrderedCartProducts.fldQuantity>
                        <cfset variables.itemTotalPrice = variables.itemActualPrice + variables.itemTotalTax>
                        <cfset variables.cartTotalPrice += variables.itemTotalPrice>
                    </cfoutput>
                    <cfoutput>
                        <p class="CartOrderAmount">Payable amount: <i class="fa-solid fa-indian-rupee-sign"></i>#variables.cartTotalPrice#</p>
                    </cfoutput>
                </div>
            </cfif>
            <button class="place-order"
                id="createPaymentBtn"
                data-bs-toggle="modal" 
                data-bs-target="#createPaymentModal">
                Place Order
            </button>
        </div>
    </div>
    <div class="modal fade" 
        id="createPaymentModal"
        data-bs-backdrop="static" 
        data-bs-keyboard="false" 
        tabindex="-1" 
        aria-labelledby="createPaymentLabel" 
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title mx-auto d-block" id="createPaymentLabel">Payment Details</h5>
                    </div>
                    <div class="modal-body">
                        <h6 class="fw-bold text-center">Card Details</h6>
                        <form method="post" id="paymentForm" action="">
                            <div id="errorMessages"></div>
                            <div class="border p-3 rounded">
                                <div class="mb-3">
                                    <label for="cardNumber" class="form-label">Card Number</label>
                                    <input type="number" name= "cardNumber" class="form-control" id="cardNumber" placeholder="000-000-000-00">
                                </div>
                                <div class="mb-3">
                                    <label for="cvv" class="form-label">CVV</label>
                                    <input type="password" name= "cvv" class="form-control" id="cvv" placeholder="000">
                                </div>
                            </div>
                            <div class="form-group pt-1 mt-3">
                                <button type="button" class="btn btn-secondary mb-3" data-bs-dismiss="modal">Cancel</button>
                                <button type="submit" name="payButton" class="btn btn-success mb-3" id="payButton">Pay</button>
                            </div>
                            <cfoutput>
                                <input type="hidden" name="addressId" value="#url.addressId#" id="addressId">
                                <cfif structKeyExists(url, "productId")>
                                    <input type="hidden" name="productId" value="#url.productId#" id="productId">
                                </cfif>
                            </cfoutput>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<cfinclude template="footer.cfm">


