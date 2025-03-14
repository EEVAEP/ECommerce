<cfif structKeyExists(url, "logOut")>
    <cfset structClear(session)>
</cfif>
<cftry>
    <cfif structKeyExists(form, "submit")>
        <cfif structKeyExists(form, "username") AND structKeyExists(form, "password")>
            <cfset user = application.userLoginService.validateUserLogin(form.username,
                                                                        form.password)>
            <cfif structKeyExists(user, "username")>
                <cfset session.username = user.username>
                <cfset session.userid = user.userid>
                <cfset session.roleid = user.role>
                <cfif session.roleid EQ "1">
                    <cflocation url="../view/Admin/dashboard.cfm" addtoken="false">
                <cfelseif session.roleid EQ "2">
                    <cfif structKeyExists(url, "productId") AND len(url.productId) NEQ 0>
                        <cfset variables.decryptedProductId = application.modelAdminCtg.decryptId(url.productId)>
                        <cfif NOT isNumeric(variables.decryptedProductId) OR variables.decryptedProductId LTE 0>
                            <div class="alert alert-warning text-center mt-6">
                                No results found. Please try another search.
                            </div>
                        <cfelseif structKeyExists(session, "action") AND session.action EQ "buyToCart">
                            <cfset structDelete(session, "action")>
                            <cflocation url="../view/User/UserCart.cfm?productId=#url.productId#" addtoken="false">
                        <cfelseif NOT structKeyExists(session, "action")>
                            <cflocation url="../view/User/UserProduct.cfm?productId=#url.productId#" addtoken="false">
                        </cfif>
                    <cfelse>
                        <cflocation url="../view/User/UserHome.cfm" addtoken="false">
                    </cfif>
                </cfif>
            <cfelse>
                <cfset errorMessage = "Invalid Username or Password">
            </cfif>
        <cfelse>
            <cfset errorMessage = "Please enter username and password">
        </cfif>
    </cfif>
    <cfcatch>
        <cfdump var="#cfcatch#">
    </cfcatch>
</cftry>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Shopping Cart</title>
    <link href="https://fonts.googleapis.com/css2?family=Pacifico&amp;display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../assets/css/bootstrap.min.css">
    <link rel="stylesheet" href="../assets/css/LoginStyle.css">
</head>
<body>
    <header class="d-flex align-items-center text-white py-3 px-4">
        <i class="fas fa-shopping-cart logo-icon"></i>
        <span class="brand">QuickCart</span>
    </header>
    <div class="container my-4">
        <h2 class="text-center custom-title">LOGIN</h2>
    </div>
    <div class="container d-flex justify-content-center">
        <div class="card shadow-lg p-4" style="width: 30rem;">
            <form method="POST" action="">
                <div class="mb-2">
                    <label for="fname" class="form-label">Username</label>
                    <input type="text" class="form-control" name="username" id="fname" placeholder="Enter your first name" required>
                </div>
                <div class="mb-2">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Enter your password" required>
                </div>
                <button type="submit" name="submit" class="btn w-100 custom-btn">Login</button>
                <cfif structKeyExists(variables, "errorMessage")>
                    <span class="error">
                        <cfoutput>#errorMessage#</cfoutput>
                    </span>
                </cfif>
            </form>
            <div class="register-link">
                <p>Don't have an account? <a href="./SignUp.cfm">SignUp</a></p>
            </div>
        </div>
    </div>
    <footer class="text-white text-center ">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>
    <script src="../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
