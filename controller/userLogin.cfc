<cfcomponent>
    <cffunction name="hashPassword" access="private">
        <cfargument name="password" type="string" required="true">
        <cfargument name="salt" type="string" required="true">
        <cfset local.saltedPass = arguments.password & arguments.salt>
        <cfset local.hashedPass = hash(local.saltedPass,"SHA-256","UTF-8")>	
        <cfreturn local.hashedPass>
    </cffunction>

    <cffunction name="validateRegisterInput" access="public" returntype="array">
        <cfargument name="fname" required="true" type="string">
        <cfargument name="lname" required="true" type="string">
        <cfargument name="email" required="true" type="string">
        <cfargument name="phone" required="true" type="string">
        <cfargument name="password" required="true" type="string">
        <cfset local.errors = []>
        <cfif len(trim(arguments.fname)) EQ 0>
            <cfset arrayAppend(local.errors, "*First Name is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.fname)>
            <cfset arrayAppend(local.errors, "*Enter a valid First Name")>
        <cfelseif len(trim(arguments.fname)) GT 20>
            <cfset arrayAppend(local.errors, "*First Name should not exceed 20 characters")>
        </cfif>
        <cfif len(trim(arguments.lname)) EQ 0>
            <cfset arrayAppend(local.errors, "*Last Name is required")>
        <cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.lname)>
            <cfset arrayAppend(local.errors, "*Enter a valid Last Name")>
        <cfelseif len(trim(arguments.lname)) GT 20>
            <cfset arrayAppend(local.errors, "*Last Name should not exceed 20 characters")>
        </cfif>
        <cfif len(trim(arguments.email)) EQ 0>
            <cfset arrayAppend(local.errors, "*Email is required")>
        <cfelseif NOT reFindNoCase("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$", arguments.email)>
            <cfset arrayAppend(local.errors, "*Enter a valid email")>
        </cfif>
        <cfif trim(arguments.phone) EQ "" OR not reFind("^\d{10}$", arguments.phone)>
            <cfset arrayAppend(local.errors, "*Phone number must contain exactly 10 digits.")>
        </cfif>
        <cfif len(trim(arguments.password)) EQ 0>
            <cfset arrayAppend(local.errors, "*Please enter the password")>
        <cfelseif NOT reFindNoCase("^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$", arguments.password)>
            <cfset arrayAppend(local.errors, "*Please enter a valid password (minimum 8 characters, 1 lowercase, 1 uppercase, 1 special character)")>
        </cfif>
        <cfreturn local.errors>
    </cffunction>

    <cffunction name="validateFilterInput" access="public" returntype="array">
        <cfargument name="minPrice" required="true" type="string">
        <cfargument name="maxPrice" required="true" type="string">
        <cfset var errors = []> 
        <cfif NOT isNumeric(arguments.minPrice) OR arguments.minPrice LTE 1>
            <cfset arrayAppend(errors, "Minimum price must be greater than 0.")>
        </cfif>
        <cfif NOT isNumeric(arguments.maxPrice) OR arguments.maxPrice LTE 1>
            <cfset arrayAppend(errors, "Maximum price must be greater than 0.")>
        </cfif>
        <cfif isNumeric(arguments.minPrice) AND isNumeric(arguments.maxPrice) AND arguments.minPrice GT arguments.maxPrice>
            <cfset arrayAppend(errors, "Maximum price must be greater than or equal to the minimum price.")>
        </cfif>
        <cfreturn errors>
    </cffunction>
</cfcomponent>