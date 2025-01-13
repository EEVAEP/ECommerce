<cfcomponent>
    
	<cffunction name="hashPassword" access="private">
		<cfargument name="pass" type="string" required="true">
		<cfargument name="salt" type="string" required="true">
		<cfset local.saltedPass = arguments.pass & arguments.salt>
		<cfset local.hashedPass = hash(local.saltedPass,"SHA-256","UTF-8")>	
		<cfreturn local.hashedPass>
	</cffunction>
	
	<cffunction name="getRoleName" access="public" returntype="query">
        	<cfquery name="local.RoleName">
            		SELECT 
				            fldRole_ID,
                            fldRoleName
			        FROM 
				            tblroles
        	</cfquery>
        	<cfreturn local.RoleName>
    </cffunction>


	<cffunction name="validateRegisterInput" access="public" returntype="array">
        
        	<cfargument name="fname" required="true" type="string">
            <cfargument name="lname" required="true" type="string">
            <cfargument name="email" required="true" type="string">
            <cfargument name="phone" required="true" type="string">
    		<cfargument name="password" required="true" type="string">
			<cfargument name="roleId" required="true" type="numeric">

			<cfset local.errors = []>

        
        	<cfif len(trim(arguments.fname)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Fullname is required")>
        	<cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.fname)>
				<cfset arrayAppend(local.errors, "*Enter a valid FirstName")>
        	</cfif>

			<cfif len(trim(arguments.lname)) EQ 0>
            		<cfset arrayAppend(local.errors, "*Fullname is required")>
        	<cfelseif NOT reFindNoCase("^[A-Za-z]+(\s[A-Za-z]+)*$", arguments.lname)>
				<cfset arrayAppend(local.errors, "*Enter a valid LastName")>
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


	


	


    
		
	
</cfcomponent>