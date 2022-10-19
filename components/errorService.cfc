<cfcomponent output="false" displayname="errorService" hint="This component handles different queries for the app">
	
	<cffunction name="getErrorByID" returntype="query" >
		<cfargument name="errorID" type="numeric" required="true">
		<cfset var rsErrById = '' />
		<cfquery name="rsErrById">
			SELECT * FROM ERROR
			WHERE IDERROR = <cfqueryparam value="#arguments.errorID#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfreturn rsErrById/>
	</cffunction>
	
	<!---addError() method--->
	<cffunction name="createError" access="public" output="false" returntype="void">
		<cfargument name="new_comment_short" required="true" type="string" />
		<cfargument name="new_comment_full" required="true" type="string" />
		<cfargument name="new_urgency" required="true" type="string" />
		<cfargument name="new_critical" required="true" type="string" />
		<cfquery  >
			INSERT error (datetime_created, comment_short, comment_full, status, urgency, critical)
			VALUES
			(
				NOW(),
				<cfqueryparam value="#arguments.new_comment_short#" cfsqltype="cf_sql_longvarchar" />,
				<cfqueryparam value="#arguments.new_comment_full#" cfsqltype="cf_sql_longvarchar" />,
				"Новая",
				<cfqueryparam value="#arguments.new_urgency#" cfsqltype="cf_sql_longvarchar" />,
				<cfqueryparam value="#arguments.new_critical#" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>
		<cfquery  name="idd">
			SELECT MAX(IDERROR) AS ID FROM ERROR
		</cfquery>
		<cfquery  >
			INSERT error_journal (date, error_id, user, action, comment)
			VALUES
			(
				NOW(),
				<cfqueryparam value="#idd.id#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="Новая" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="Ошибка добавлена в базу" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>
	</cffunction>
	
	<!---Update Err Method--->
	<cffunction name="updateError" returntype="void">
		<cfargument name="old_iderror" required="true" type="numeric" />
		<cfargument name="new_comment_short" required="true" type="string" />
		<cfargument name="new_comment_full" required="true" type="string" />
		<cfargument name="new_urgency" required="true" type="string" />
		<cfargument name="new_critical" required="true" type="string" />
		<cfquery>
			UPDATE error
			SET
			comment_short = <cfqueryparam value="#arguments.new_comment_short#" cfsqltype="cf_sql_longvarchar" />,
			comment_full = <cfqueryparam value="#arguments.new_comment_full#" cfsqltype="cf_sql_longvarchar" />,
			urgency = <cfqueryparam value="#arguments.new_urgency#" cfsqltype="cf_sql_longvarchar" />,
			critical = <cfqueryparam value="#arguments.new_critical#" cfsqltype="cf_sql_longvarchar" />
			WHERE iderror = <cfqueryparam value="#arguments.old_iderror#" cfsqltype="cf_sql_integer" />
		</cfquery>
	</cffunction>
	<cffunction name="updateStatus" returntype="void">
		<cfargument name="iderror" required="true" type="numeric" />
		<cfargument name="comment" required="true" type="string" />
		<cfargument name="status" required="true" type="string" />
		<cfquery>
			UPDATE error
			SET
			status = <cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_longvarchar" />
			WHERE iderror = <cfqueryparam value="#arguments.iderror#" cfsqltype="cf_sql_integer" />
		</cfquery>
		<cfquery  >
			INSERT error_journal (date, error_id, user, action, comment)
			VALUES
			(
				NOW(),
				<cfqueryparam value="#arguments.iderror#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#session.stLoggedInUser.userID#" cfsqltype="cf_sql_integer" />,
				<cfqueryparam value="#arguments.status#" cfsqltype="cf_sql_varchar" />,
				<cfqueryparam value="#arguments.comment#" cfsqltype="cf_sql_longvarchar" />
			)
		</cfquery>
	</cffunction>

	<cffunction name="getErrorJournalById" returntype="Query">
		<cfargument name="iderror" required="true" type="numeric" />
			<cfquery name="rsChanges">
				SELECT error_journal.date as datetime, error_journal.action, error_journal.comment, users.name, users.surname
				FROM error_journal INNER JOIN users ON error_journal.user = users.idUsers 
				WHERE error_journal.error_id = <cfqueryparam value="#arguments.iderror#" cfsqltype="cf_sql_integer" />
				ORDER BY date desc
			</cfquery>
			<cfreturn rsChanges/>
		</cffunction> 
	
	<!--- Get all errors Method --->
	<cffunction name="getAllErrors" access="public" returntype="Query"> <!--- roles="Administrator" --->
		<cfset var rsAllErrors = '' />
		<cfquery name="rsAllErrors" >
			SELECT *
			FROM error
			ORDER BY datetime_created DESC
		</cfquery>
		<cfreturn rsAllErrors /> 
	</cffunction>
	
	<!---Validate page form method--->
	<cffunction name="validateError" returntype="array">
		<cfargument name="comment_short" required="true" type="string" />
		<cfargument name="comment_full" required="true" type="string" />
		<cfargument name="urgency" required="true" type="string" />
		<cfargument name="critical" required="true" type="string" />
		<cfset local.messages = []/>
		<cfif arguments.comment_short EQ ''>
			<cfset arrayAppend(local.messages,'Некорректно заполнено поле <Комментарий>') />
		</cfif>
		<cfif arguments.comment_full EQ ''>
			<cfset arrayAppend(local.messages, 'Некорректно заполнено поле <Описание>') />
		</cfif>
		<cfset urg=["Очень срочно","Срочно","Несрочно","Совсем несрочно"] />
		<cfif NOT arrayContains(urg, arguments.urgency)>
			<cfset arrayAppend(local.messages, 'Некорректно заполнено поле <Срочность>') />
		</cfif>
		<cfset crit=["Авария","Критичная","Некритичная","Запрос на изменение"] />
		<cfif NOT arrayContains(crit, arguments.critical)>
			<cfset arrayAppend(local.messages, 'Некорректно заполнено поле <Критичность>') />
		</cfif>
		<cfreturn local.messages />
	</cffunction>

	<cffunction name="validateStatus" returntype="array">
		<cfargument name="comment" required="true" type="string" />
		<cfargument name="status" required="true" type="string" />
		<cfset local.messages = []/>
		<cfif arguments.comment EQ ''>
			<cfset arrayAppend(local.messages,'Некорректно заполнено поле <Комментарий>') />
		</cfif>
		<cfset st=["Новая","Открытая","Решенная","Закрытая"] />
		<cfif NOT arrayContains(st, arguments.status)>
			<cfset arrayAppend(local.messages, 'Некорректно заполнено поле <Срочность>') />
		</cfif>
		<cfreturn local.messages />
	</cffunction>
</cfcomponent>