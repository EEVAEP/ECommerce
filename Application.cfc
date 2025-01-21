
<cfcomponent output="false">
	
	<cfset this.name = "ECommerceAuthentication"> 
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)> 
    <cfset this.sessionManagement = true> 
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)> >
    <cfset this.setClientCookies = true>
	<cfset this.datasource = "shoppingcart"> 
    
    <cffunction name="onApplicationStart" returnType="boolean">
		<cfset application.encryptionKey = generateSecretKey("AES")>
		<cfset application.userService = createObject("component","controller.userLogin")>
		<cfset application.CntrlProduct = createObject("component","controller.AdminProduct")>
		<cfset application.modelService = createObject("component","model.registerAndLogin")>
		<cfset application.modelAdminCtg = createObject("component","model.AdminCategory")>
		<cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="void">
        <cfargument name="requestname" required="true">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>

		<cfset local.pages = ["SignUp.cfm", "Login.cfm"]>
		<cfset local.restrictedPages = ["dashboard.cfm", "SubCategory.cfm", "ProductPage.cfm"]>
		<cfset currentPage = listLast(CGI.SCRIPT_NAME, '/')>
		<cfif (NOT structKeyExists(session, "username") AND NOT arrayFindNoCase(local.pages, currentPage)) OR 
    		(arrayFindNoCase(local.restrictedPages, currentPage) AND 
				(NOT structKeyExists(session, "roleid") OR 
            		(structKeyExists(session, "roleid") AND session.roleid NEQ 1)
        		)
    		)>
    		<cflocation url="../../view/Admin/Login.cfm" addToken="no">
		</cfif>

    </cffunction>
	
       
</cfcomponent>
