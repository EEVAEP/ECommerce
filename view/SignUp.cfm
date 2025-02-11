<cftry>
    <cfif structKeyExists(form, "submit")>
        <cfset variables.validationErrors = application.userLogin.validateRegisterInput(fname=form.fname,
 												lname=form.lname,
                                                email=form.email,
												phone=form.phone, 
												password=form.password)>
	    <cfif structKeyExists(variables, "validationErrors") AND arrayLen(validationErrors) EQ 0>
		    <cfset result = application.userLoginService.registerUser(form.fname,
 												form.lname,
                                                form.email,
												form.phone, 
												form.password)>
		    <cfif result.success>
            	    <cfset successMessage = result.message>
		    <cfelse>
			    <cfset errorMessage = result.message>
		    </cfif>
        </cfif>
    </cfif>     
    <cfcatch>
        <cfdump  var="#cfcatch#">
    </cfcatch>
</cftry>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SignUp - Shopping Cart</title>
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
    <div class="container my-3">
        <h2 class="text-center custom-title">SignUp</h2>
    </div>
    <div class="container d-flex justify-content-center">
        <div class="card shadow-lg p-4" style="width: 30rem;">
            <cfif structKeyExists(variables, "validationErrors") AND arrayLen(validationErrors) GT 0>
                <cfoutput>
                    <div id="signUpError" class="alert alert-danger">
                        <cfloop array="#variables.validationErrors#" index="error">
                            <div>#error#</div>
                        </cfloop>
                    </div>
                </cfoutput>
            </cfif>
            <form method="POST" action="">
                <div class="mb-2">
                    <label for="fname" class="form-label">First Name</label>
                    <input type="text" class="form-control" name="fname" id="fname" placeholder="Enter your first name">
                </div>
                <div class="mb-2">
                    <label for="lname" class="form-label">Last Name</label>
                    <input type="text" class="form-control" name="lname" id="lname" placeholder="Enter your last name">
                </div>
                <div class="mb-2">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" class="form-control" name="email" id="email" placeholder="Enter your email">
                </div>
                <div class="mb-2">
                    <label for="phone" class="form-label">Phone</label>
                    <input type="tel" class="form-control" name="phone" id="phone" placeholder="Enter your phone number">
                </div>
                <div class="mb-2">
                    <label for="password" class="form-label">Password</label>
                    <input type="password" class="form-control" name="password" id="password" placeholder="Enter your password">
                </div>
                <button type="submit" name="submit" class="btn w-100 custom-btn">SignUp</button>
                <cfif structKeyExists(variables, "errorMessage")>
                    <span class="error">
                        <cfoutput>#errorMessage#</cfoutput>
                    </span>
                </cfif>
				<cfif structKeyExists(variables, "successMessage")>
                    <span class="success">
                        <cfoutput>#successMessage#</cfoutput>
                    </span>
                </cfif>
            </form>
            <div class="register-link">
                <p>LoginHere: <a href="./Login.cfm">Login</a></p>
            </div>
        </div>
    </div>
    <footer class="text-white text-center py-3 mt-4">
        <p>&copy; 2025 Shopping Cart. All Rights Reserved.</p>
    </footer>
    <script src="../assets/js/bootstrap.bundle.min.js"></script>
</body>
</html>
