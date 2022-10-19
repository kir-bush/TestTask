<cfset pageTitle = "Регистрация пользователя" />
<cfinclude template="../partials/header.cfm">
<script src="../scripts/jqmin.js" ></script>
<script>
document.addEventListener('DOMContentLoaded', function(){
	 	$("#user_form_submit_btn").css("display", "inline-block");
})
</script>
<main><div id="maincontainer">
	<link rel="stylesheet" href="../styles/elemend-data.css">
	<link rel="stylesheet" href="../styles/user-data-form.css">
	<h1 style="display: inline;">Регистрация пользователя</h1> 
	<form id="user-data-form" action="users.cfm?create" method="post" accept-charset="utf-8">
				<div>
					<label>Имя</label>
					<input type="text" id="name" class="editable-data" name="name" maxlength="45" required >
				</div>
				<div>
					<label>Фамилия</label>
					<input type="text" id="surname" class="editable-data" name="surname" maxlength="45" required >
				</div>
				<div>
					<label>Логин</label>
					<input type="text" id="login" class="editable-data" name="login" maxlength="45" required >
				</div>
				<div>
					<label>Пароль</label>
					<input type="text" id="password" class="editable-data" name="password" maxlength="45" required>
				</div>
				<cfif isUserInRole("Administrator")>
					<div>
						<label>Роль</label>
						<input type="text" id="role" class="editable-data" name="role" maxlength="45" required >
					</div>
					<div>
						<label>Активен</label>
						<input type="number" id="isActive" class="editable-data" name="isActive" min="0" max="1" required >
					</div>
				</cfif>
				<div class="controls">
		   			<input form="user-data-form" id="user_form_submit_btn" type="submit" value="Сохранить">
				</div>
			</form>
	<div>
		
	</div>
	<div>
		
	</div>
</div></main>
<cfinclude template="../partials/footer.cfm">