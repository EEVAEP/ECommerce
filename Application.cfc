
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
			<cfset application.modelService = createObject("component","model.registerAndLogin")>
			<cfset application.modelAdminCtg = createObject("component","model.AdminCategory")>
		
		    <cfreturn true>
    	</cffunction>

        <cffunction name="onRequestStart" returnType="void">
        	<cfargument name="requestname" required="true">
        	<cfif structKeyExists(url,"reload") AND url.reload EQ 1>
            		<cfset onApplicationStart()>
        	</cfif>

			<cfset local.pages = ["SignUp.cfm","Login.cfm"]>
        	<cfif NOT structKeyExists(session,"username") AND NOT arrayFindNoCase(local.pages, ListLast(CGI.SCRIPT_NAME,'/'))>
		    	<cflocation url="../../view/Admin/Login.cfm" addToken="no">
	    	</cfif>



			<cfset local.restrictedPages = [    "dashboard.cfm","SubCategory.cfm",
                                            "ProductPage.cfm"
                                        ]>     
        <cfif NOT structKeyExists(session,"roleid") AND arrayFindNoCase(local.restrictedPages, listLast(CGI.SCRIPT_NAME,'/'))>
            <cflocation  url="../../view/Admin/Login.cfm" addToken = "false">
        <cfelseif structKeyExists(session, "roleid") AND session.roleid NEQ 1 AND arrayFindNoCase(local.restrictedPages, listLast(CGI.SCRIPT_NAME,'/'))>
            <cflocation url = "../../view/Admin/Login.cfm" addToken = "false">
        </cfif>
    	</cffunction>
	
       
</cfcomponent>
