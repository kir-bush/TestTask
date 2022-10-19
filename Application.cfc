<cfcomponent output="false">
	<cfset this.name = "TestTask" />
	<cfset this.dataSource = "MySQL" />
	<cfset this.applicationTimeout = createTimespan(0,1,0,0) />
	<cfset this.sessionManagement = true/>
	<cfset this.sessionTimeout = createTimespan(0, 0, 30, 0)/>
	<cfset this.locationPages = "/TestTask/pages/"/>
	<!---OnApplicationStart() method--->
	<cffunction name="onApplicationStart" returntype="boolean" >
		<cfset application.errorService = createObject("component",'TestTask.components.errorService') />
		<cfset application.userService = createObject("component",'TestTask.components.userService') />
		<cfset application.authService = createObject("component",'TestTask.components.authenticationService') />
		<cfreturn true />
	</cffunction>
	<cffunction name="onRequestStart" returntype="boolean" >
		<cfargument name="targetPage" type="string" required="true"/>
		<cfif isDefined("url.restart")> 
			<cfset this.onApplicationStart() />
		</cfif> 
				
		<cfif NOT listFind(arguments.targetPage,'login.cfm', '/?&,') AND NOT isUserLoggedIn()>
			<!--- Если неавторизованный пользователь отправляет запрос не к странице "Авторизация" --->
			<cfset urll = this.locationPages & 'login.cfm?noaccess' /><!---&noaccessTarget='  & arguments.targetPage  --->
			<cflocation url= '#urll#'/>
		</cfif>
		<cfreturn true />
	</cffunction>
	
</cfcomponent>