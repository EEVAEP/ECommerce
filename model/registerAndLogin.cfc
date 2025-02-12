<cfcomponent>
	<cffunction name="getRoleName" access="public" returntype="query">
		<cfquery name="local.RoleName" datasource="#application.datasource#">
			SELECT
				fldRole_ID,
				fldRoleName
			FROM
				tblroles
		</cfquery>
	<cfreturn local.RoleName>
	</cffunction>

	<cffunction name="hashPassword" access="private">
		<cfargument name="pass" type="string" required="true">
		<cfargument name="salt" type="string" required="true">
		<cfset local.saltedPass = arguments.pass & arguments.salt>
		<cfset local.hashedPass = hash(local.saltedPass,"SHA-256","UTF-8")>	
		<cfreturn local.hashedPass>
	</cffunction>

	<cffunction name="registerUser" returntype="struct">
		<cfargument name="fname" required="true" type="string">
		<cfargument name="lname" required="true" type="string">
		<cfargument name="email" required="true" type="string">
		<cfargument name="phone" required="true" type="string">
		<cfargument name="password" required="true" type="string">
		<cfset local ={}>
		<cfquery name="local.qryCheckUser" datasource="#application.datasource#">
			SELECT *
			FROM 
			    tblUser
			WHERE 
				fldFirstname = <cfqueryparam value="#arguments.fname#" cfsqltype="cf_sql_varchar">
				OR fldPhone  = <cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">
				AND fldEmail = <cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif local.qryCheckUser.recordCount EQ 0>
			<cfset local.salt = generateSecretKey("AES")>
			<cfset local.hashedPassword = hashPassword(arguments.password, local.salt)>
			<cfquery datasource="#application.datasource#">
				INSERT INTO 
					tblUser(
							fldFirstname,
							fldLastname,
							fldEmail,
							fldPhone,
							fldRoleId,
							fldHashedPassword,
							fldUserSaltString
					)
				VALUES(
						<cfqueryparam value="#arguments.fname#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.lname#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.email#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#arguments.phone#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="2" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#local.hashedPassword#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#local.salt#" cfsqltype="cf_sql_varchar">
					)
			</cfquery>
			<cfset local.result.success = true>
			<cfset local.result.message = "Registration successful. Please login">
		<cfelse>
			<cfset local.result.success = false>
			<cfset local.result.message = "User already exists. Please Login">
		</cfif>
		<cfreturn local.result>
	</cffunction>

	<cffunction name="validateUserLogin" access="public" returntype="struct">
		<cfargument name="username" required="true" type="string">
		<cfargument name="password" required="true" type="string">
		<cfquery name="local.qryLogin" datasource="#application.datasource#">
			SELECT 
				fldUser_ID AS userid,
				fldEmail,
				fldPhone,
				fldHashedPassword,
				fldUserSaltString,
				fldRoleId
			FROM 
				tblUser
			WHERE 
				fldEmail = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
				OR fldPhone = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset local.result = {}>
		<cfif local.qryLogin.recordCount EQ 1>
			<cfset local.salt = local.qryLogin.fldUserSaltString>
			<cfset local.hashedPassword  = hashPassword(arguments.password, local.salt)>
			<cfif local.hashedPassword  EQ  local.qryLogin.fldHashedPassword>
				<cfset local.result['userid'] = local.qryLogin.userid>
				<cfset local.result['username'] = local.qryLogin.fldEmail>
				<cfset local.result['role'] = local.qryLogin.fldRoleId>
			</cfif>
		</cfif>
		<cfreturn local.result>
	</cffunction>
</cfcomponent>