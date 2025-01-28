<cfcomponent output="false">
	<cfset this.name = "ECommerceAuthentication"> 
    <cfset this.applicationTimeout = createTimeSpan(1, 0, 0, 0)> 
    <cfset this.sessionManagement = true> 
    <cfset this.sessionTimeout = createTimeSpan(0, 0, 30, 0)> >
    <cfset this.setClientCookies = true>
	
    <cffunction name="onApplicationStart" returnType="boolean">
		<cfset application.encryptionKey = generateSecretKey("AES")>
		<cfset application.userLogin = createObject("component","controller.userLogin")>
		<cfset application.CntrlProduct = createObject("component","controller.AdminProduct")>
        <cfset application.userLoginService = createObject("component","model.registerAndLogin")>
		<cfset application.modelAdminCtg = createObject("component","model.AdminCategory")>
		<cfset application.modelUserPage = createObject("component","model.UserPage")>
        <cfset application.datasource = "shoppingcart">         <cfreturn true>
    	</cffunction>

    	<cffunction name="onRequestStart" returnType="void">
        	<cfargument name="requestname" required="true">
        	<cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            		<cfset onApplicationStart()>
        	</cfif>

		<cfset local.adminPages = ["dashboard.cfm", "productPage.cfm", "SubCategory.cfm"]>
        	<cfset local.userPages = ['UserCart.cfm','userOrder.cfm','userProfile.cfm']>
        	<cfset local.currentPage = listLast(CGI.SCRIPT_NAME, '/')>
        	<cfset local.hasRole = structKeyExists(session, 'roleid')>
        	<cfset local.isUser = structKeyExists(session, 'userid')>
        	<cfset local.productId = structKeyExists(url,"productId") ? url.productId : "">

        	<cfif (!local.hasRole AND !local.isUser AND (arrayFindNoCase(local.adminPages, local.currentPage) 
            		OR arrayFindNoCase(local.userPages, local.currentPage))) 
            		OR (local.hasRole AND session.roleid NEQ 1 AND arrayFindNoCase(local.adminPages, local.currentPage))
            		OR (!local.hasRole AND arrayFindNoCase(local.userPages, local.currentPage))>
        		<cfif len(local.productId)>
                		<cfset session.productId = local.productId>
            		</cfif>
            			<cflocation url = "../Login.cfm" addToken = "false">
        	</cfif>
	</cffunction>
</cfcomponent>
