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
        <cfset application.modelOrderPage = createObject("component","model.OrderPage")>
        <cfset application.datasource = "shoppingcart">         
        <cfreturn true>
    </cffunction>

    <cffunction name="onRequestStart" returnType="void">
        <cfargument name="requestname" required="true">
        <cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            <cfset onApplicationStart()>
        </cfif>
        <cfset local.adminPages = ["dashboard.cfm", "productPage.cfm", "SubCategory.cfm"]>
        <cfset local.userPages = ['UserCart.cfm', 'UserProfile.cfm', 'PaymentDetailsPage.cfm', 'PaymentSuccessful.cfm']>
        <cfset local.currentPage = listLast(CGI.SCRIPT_NAME, '/')>
        <cfset local.productId = structKeyExists(url,"productId") ? url.productId : "">
        <cfset local.action = structKeyExists(url,"action") ? url.action : "">
        <cfif (NOT structKeyExists(session, 'roleid')  AND (arrayFindNoCase(local.adminPages, local.currentPage) 
                OR arrayFindNoCase(local.userPages, local.currentPage)))
                OR (structKeyExists(session, 'roleid') AND session.roleid NEQ 1 AND arrayFindNoCase(local.adminPages, local.currentPage))>
            <cfif len(local.productId)>
                <cfset session.productId = local.productId>
            </cfif>
            <cfif len(local.action)>
                <cfset session.action = local.action>
            </cfif>
            <cflocation url = "../Login.cfm" addToken = "false">
        </cfif>
	</cffunction>
</cfcomponent>
