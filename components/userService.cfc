<cfcomponent output="false">
	<!---addUser() method--->
	<cffunction name="createUser" access="public" output="false" returntype="void" roles="Administrator">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfargument name="userRole" type="string" required="true" />
		<cfargument name="userIsActive" type="numeric" required="false" default = 1/>
		<cfquery>
			INSERT INTO users(login, password, name, surname, isActive, role)
			VALUES
			(
				<cfqueryparam value="#arguments.userFirstName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userLastName#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userLogin#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userPassword#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.userIsActive#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.userRole#" cfsqltype="cf_sql_varchar" />
			)
		</cfquery>
	</cffunction>
	<!---validateUser() method--->
	<cffunction name="validateUser" access="public" output="false" returntype="array">
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfargument name="role" type="string" required="false" />
		<cfargument name="isActive" type="numeric" required="false" />
		<cfset var aErrorMessages = arrayNew(1) />
		<!---Validate firstName--->
		<cfif arguments.userFirstName EQ ''>
			<cfset arrayAppend(aErrorMessages,'Please provide a valid first name') />
		</cfif>
		<!---Validate lastName--->
		<cfif arguments.userLastName EQ ''>
			<cfset arrayAppend(aErrorMessages,'Please provide a valid lastname') />
		</cfif>
		<!---Validate userLogin--->
		<cfif arguments.userLogin EQ '' >
			<cfset arrayAppend(aErrorMessages,'Please provide a valid login ')/>
		</cfif>
		<!---Validate Password--->
		<cfif arguments.userPassword EQ '' >
			<cfset arrayAppend(aErrorMessages,'Please provide a password ')/>
		</cfif>
		<cfif structKeyExists(arguments, "isActive") AND (0 GREATER THAN arguments.isActive OR arguments.isActive GREATER THAN 1) >
			<cfset arrayAppend(aErrorMessages,'Please provide user active status')/>
		</cfif>
		<cfif structKeyExists(arguments, "role") AND arguments.role EQ '' >
			<cfset arrayAppend(aErrorMessages,'Please provide user role')/>
		</cfif>
		<cfreturn aErrorMessages />
	</cffunction>
	<!---getUserByID() method--->
	<cffunction name="getUserByID" access="public" output="false" returntype="query">
		<cfargument name="userID" type="numeric" required="true" />
		<cfset var rsSingleUser = '' />
		<cfquery  name="rsSingleUser">
			SELECT *
			FROM USERS
			WHERE idUsers = <cfqueryparam value="#arguments.userID#" cfsqltype="cf_sql_integer" /> 
		</cfquery>
		<cfreturn rsSingleUser />
	</cffunction>
	<!---updateUser() method--->
	<cffunction name="updateUser" access="public" output="false" returntype="void">
		<cfargument name="idUser" type="numeric" required="true" />
		<cfargument name="userFirstName" type="string" required="true" />
		<cfargument name="userLastName" type="string" required="true" />
		<cfargument name="userLogin" type="string" required="true" />
		<cfargument name="userPassword" type="string" required="true" />
		<cfargument name="userIsActive" type="numeric" required="false"/>
		<cfquery>
			UPDATE USERS
			SET
			login = <cfqueryparam value="#arguments.userFirstName#" cfsqltype="cf_sql_varchar" />,
			password = <cfqueryparam value="#arguments.userLastName#" cfsqltype="cf_sql_varchar" />,
			name = <cfqueryparam value="#arguments.userLogin#" cfsqltype="cf_sql_varchar" />,
			surname = <cfqueryparam value="#arguments.userPassword#" cfsqltype="cf_sql_varchar" />
			<cfif isDefined('arguments.userIsActive')>,
				isActive = <cfqueryparam value="#arguments.userIsActive#" cfsqltype="cf_sql_integer" />
			</cfif>
			WHERE idUsers = <cfqueryparam value="#arguments.idUser#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
		
		<!---Get All active Users Method--->
		<cffunction name="getAllUsers" returntype="Query" roles="Administrator">
			<cfquery name="rs_allUsers">
				SELECT * FROM USERS
				ORDER BY idUsers
			</cfquery>
			<cfreturn rs_allUsers/>
		</cffunction> 
</cfcomponent>