<cfif isDefined('url.idUsers')>
	<cfset mode = "getOne" />
	<cfset page_user_id = url.idUsers />
<cfelseif isDefined('url.update')>
	<cfset mode = "put" />
	<cfset page_user_id = form.idUsers />
		<!--- Запрос на UPDATE --->
		<cfif isDefined('form.idUsers') AND isDefined('form.login') AND  isDefined('form.password') AND isDefined('form.name') AND isDefined('form.surname')>
			<cfif isUserInRole("Administrator")> 
				<cfset aErrorMessages = application.userService.validateUser(form.idUsers, form.login, form.password, form.name, form.surname, form.isActive)/>
			<cfelse>
				<cfset aErrorMessages = application.userService.validateUser(form.idUsers, form.login, form.password, form.name, form.surname)/>
			</cfif>
			<cfif ArrayIsEmpty(aErrorMessages)>
				<cfif isUserInRole("Administrator")> 
					<cfset application.userService.updateuser(form.idUsers, form.login, form.password, form.name, form.surname, form.isActive)/>
				<cfelse>
					<cfset application.userService.updateuser(form.idUsers, form.login, form.password, form.name, form.surname)/>
				</cfif>
			</cfif>
		<cfelse>
			<cfset aErrorMessages = ['Ошибка обновления: недостаточно данных']/>
		</cfif>
<cfelse>
	<cfif isDefined('url.create') AND structCount(form) greater than 1>
		<!---Запрос на INSERT --->
		<cfif isDefined('form.isActive') AND isDefined('form.login') AND  isDefined('form.password') AND isDefined('form.name') AND isDefined('form.surname')>
			<cfif isUserInRole("Administrator")> 
				<cfset aErrorMessages = application.userService.validateUser( form.login, form.password, form.name, form.surname, form.role, form.isActive)/>
			</cfif>
			<cfif ArrayIsEmpty(aErrorMessages)>
				<cfif isUserInRole("Administrator")> 
					<cfset application.userService.createuser( form.login, form.password, form.name, form.surname, form.role, form.isActive)/>
				</cfif>
			</cfif>
		<cfelse>
			<cfset aErrorMessages = ['Ошибка обновления: недостаточно данных']/>
		</cfif>
	</cfif>
	<cfset mode = "getAll" />
</cfif>

<cfif mode EQ "getAll">
	<cfset pageTitle = "Список пользователей" />
	<cfset rsAllUsers = application.userService.getAllusers() />
<cfelse>
	<cfset pageTitle = 'Пользователь ' & page_user_id />
	<cfset rsOneuser = application.userService.getuserByID(page_user_id)/>
</cfif>

<cfinclude template="../partials/header.cfm">
<script src="../scripts/jqmin.js" ></script> 
<script>
	let backup = new Array();
document.addEventListener('DOMContentLoaded', function()  {
	$('.editable-data').css("box-shadow", "none");

    $('select.editable-data').on('keypress', function(event){
    	event.preventDefault();
    });

    $('#user_form_edit_btn').on('click', function(event){
    	event.preventDefault();
			$("#user_form_noedit_btn").css("display", "inline-block");
			$("#user_form_submit_btn").css("display", "inline-block");
			$("#user_form_edit_btn").css("display", "none");
    	$('.editable-data').each(function(i,e){
    		backup.push(e.value);
    	})
	    $('.editable-data').removeAttr("readonly")
		$('.editable-data').css("box-shadow", "0px 0px 0px 1px black");
    });

    $('#user_form_noedit_btn').on('click', function(event){
    	event.preventDefault();
			$("#user_form_noedit_btn").css("display", "none");
			$("#user_form_submit_btn").css("display", "none");
			$("#user_form_edit_btn").css("display", "inline-block");
    	$('.editable-data').each(function(i,e){
    		e.value = backup.shift();
    	})
	    $('.editable-data').attr("readonly", "")
		$('.editable-data').css("box-shadow", "none");
    });
});
</script>
<main><div id="maincontainer">
	<cfif mode EQ "getAll">
		<link rel="stylesheet" href="../styles/table-sort.css">
		<h1 style="display: inline; margin-left: 70px;">Список Пользователей</h1>
		<cfif structKeyExists(variables,'aErrorMessages') AND ArrayisEmpty(aErrorMessages)>
			<h3 style="color: lightseagreen; display: inline; padding-left: 50px;">Операция выполнена успешно</h3>
		<cfelseif structKeyExists(variables,'aErrorMessages') AND NOT ArrayisEmpty(aErrorMessages)>
			<h3 style="color: red; display: inline; padding-left: 50px;">Ошибка: операция не выполнена</h3>
		</cfif>
		<div id="users-table">
			<table class="table_sort">
				<thead>
		            <tr style="position: sticky; top: 3rem;border-top: ">
		            	<th>id</th>
		              <th>Логин</th>
		              <th>Пароль</th>
		              <th>Имя</th>
		            	<th>Фамилия</th>
		              <th>Роль</th>
		              <th>Активен</th>
		            	<th></th>
		            </tr>
				</thead>
				<tbody>
		      <cfoutput query="rsAllUsers">
			      <tr>
							<td>#idUsers#</td>
							<td>#login#</td>
							<td>#password#</td>
							<td>#name#</td>
							<td>#surname#</td>
							<td>#role#</td>
							<td>#isActive#</td>
							<td><a href="users.cfm?idUsers=#idUsers#">Профиль</a></td>
						</tr>
		      </cfoutput>
				</tbody>
	    </table>
		</div>
	<cfelse>
		<link rel="stylesheet" href="../styles/elemend-data.css">
		<link rel="stylesheet" href="../styles/user-data-form.css">
		<h1 style="display: inline;">Пользователь #<cfoutput>#page_user_id#</cfoutput></h1> 
		<cfif structKeyExists(variables,'aErrorMessages') AND ArrayisEmpty(aErrorMessages)>
			<h3 style="color: lightseagreen; display: inline; padding-left: 50px;">Операция выполнена успешно</h3>
		<cfelseif structKeyExists(variables,'aErrorMessages') AND NOT ArrayisEmpty(aErrorMessages)>
			<h3 style="color: red; display: inline; padding-left: 50px;">Ошибка: операция не выполнена</h3>
		</cfif>
		<cfoutput >
			<form id="user-data-form" action="users.cfm?update" method="post" accept-charset="utf-8">
				<input type="hidden" name="idUsers" value="#page_user_id#">
				<div>
					<label>Имя</label>
					<input type="text" id="name" class="editable-data" name="name" maxlength="30" readonly required value="#rsOneUser.name#">
				</div>
				<div>
					<label>Фамилия</label>
					<input type="text" id="surname" class="editable-data" name="surname" maxlength="30" readonly required value="#rsOneUser.surname#">
				</div>
				<div>
					<label>Логин</label>
					<input type="text" id="login" class="editable-data" name="login" maxlength="30" readonly required value="#rsOneUser.login#">
				</div>
				<div>
					<label>Пароль</label>
					<input type="text" id="password" class="editable-data" name="password" maxlength="30" readonly required value="#rsOneUser.password#">
				</div>
				<cfif isUserInRole("Administrator")>
					<div>
						<label>Активен</label>
						<input type="number" id="isActive" class="editable-data" name="isActive" min="0" max="1" readonly required value="#rsOneUser.isActive#">
					</div>
				</cfif>
				<div class="controls">
		   			<input  id="user_form_submit_btn" type="submit" value="Сохранить">
					<button id="user_form_edit_btn" >Редактировать</button>
					<button id="user_form_noedit_btn" >Отменить</button>
				</div>
			</form>
		</cfoutput>
	</cfif>
</div></main>
<cfinclude template="../partials/footer.cfm">