<cfinclude template="header.cfm">
<cfset variables.displayRandomProducts = application.modelUserPage.getRandomProducts()>

<!DOCTYPE html>
<html lang="en">
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
</head>
<body>
    <section class = "app-section">
        <div class="container">
            <img src="../../assets/img/cartImage" class="banner-img" alt = "banner">
        </div>
    </section>
    <div class="container mt-4">
        <h4 class="custom-heading">Random Products</h4>
        <div class="row random-products mt-4">
            <cfoutput query="variables.displayRandomProducts">
                <cfset encryptedId = encrypt(variables.displayRandomProducts.idProduct, application.encryptionKey, "AES", "Hex")>
                <div class="col-md-3">
                    <a href="UserProduct.cfm?productId=#encryptedId#" class="product-link">
                        <div class="product-card" data-aos="fade-up">
                            <img src="/uploads/#variables.displayRandomProducts.fldImageFileName#" class = "randomImg" alt="Product">
                            <div class="product-info">
                                <h5 class="product-name">#variables.displayRandomProducts.fldProductName#</h5>
                                <p class="product-price"><i class="fa-solid fa-indian-rupee-sign"></i>#variables.displayRandomProducts.fldPrice#</p>
                            </div>
                        </div>
                    </a>
                </div>
            </cfoutput>
        </div>
    </div>
    <cfinclude template="footer.cfm">
</body>
</html>