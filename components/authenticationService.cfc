<cfcomponent output="false">
	<cffunction name="validateUser" access="public" output="false" returntype="array">
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfset structDelete(cookie,"ckwhatever",true) />
		<cfset var aErrorMessages = ArrayNew(1) />
		<cfif arguments.userLogin EQ ''>
			<cfset arrayAppend(aErrorMessages,'Введите логин') />
		</cfif>
		<cfif arguments.userPassword EQ ''>
			<cfset arrayAppend(aErrorMessages,'Введите пароль') />
		</cfif>
		<cfreturn aErrorMessages />
	</cffunction>
	<cffunction name="doLogin" access="public" output="false" returntype="boolean">
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfset var isUserLoggedIn = false />
		<cfquery name="rsLoginUser">
			SELECT * FROM USERS 
			WHERE login = <cfqueryparam value="#arguments.userLogin#" cfsqltype="cf_sql_varchar" /> 
			AND password = <cfqueryparam value="#arguments.userPassword#" cfsqltype="cf_sql_varchar" /> 
			AND isActive = 1
		</cfquery>
		<cfif rsLoginUser.recordCount EQ 1>
			<cflogin >
				<cfloginuser name="#rsLoginUser.login# #rsLoginUser.name#_#rsLoginUser.surname#" password="#rsLoginUser.password#" roles="#rsLoginUser.role#" >
			</cflogin>
			<cfset session.stLoggedInUser = {'userFirstName' = rsLoginUser.name, 'userLastName' = rsLoginUser.surname, 'userID' = rsLoginUser.idUsers} />
			<cfset var isUserLoggedIn = true />
		</cfif>
		<cfreturn isUserLoggedIn />
	</cffunction>
	<cffunction name="doLogout" access="public" output="false" returntype="void">
		<!---delete user data from the session scope--->
		<cfset structdelete(session,'stLoggedInUser') />
		<!---Log the user out--->
		<cflogout session="current">
	</cffunction>

</cfcomponent>