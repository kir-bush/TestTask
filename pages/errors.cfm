<cfif isDefined('url.iderror')>
	<cfset mode = "getOne" />
	<cfset page_err_id = url.iderror />
<cfelseif isDefined('url.update')>
	<cfset mode = "put" />
	<cfset page_err_id = form.iderror />
		<!--- Запрос на UPDATE --->
		<cfif isDefined('form.iderror') AND isDefined('form.comment_short') AND  isDefined('form.comment_full') AND isDefined('form.urgency') AND isDefined('form.critical')>
			<cfset aErrorMessages = application.errorService.validateError(form.comment_short, form.comment_full, form.urgency, form.critical)/>
			<cfif ArrayIsEmpty(aErrorMessages)>
				<cfset application.errorService.updateError(form.iderror, form.comment_short, form.comment_full, form.urgency, form.critical)/>
			</cfif>
		<cfelse>
			<cfset aErrorMessages = ['Ошибка обновления: недостаточно данных']/>
		</cfif>
<cfelseif isDefined('url.newstatus')>
	<cfset mode = "put" />
	<cfset page_err_id = form.iderror />
		<!--- Запрос на new status --->
		<cfif isDefined('form.iderror') AND isDefined('form.comment') AND isDefined('form.status') >
			<cfset aErrorMessages = application.errorService.validateStatus(form.comment, form.status)/>
			<cfif ArrayIsEmpty(aErrorMessages)>
				<cfset application.errorService.updateStatus(form.iderror, form.comment, form.status)/>
			</cfif>
		<cfelse>
			<cfset aErrorMessages = ['Ошибка обновления статуса: недостаточно данных']/>
		</cfif>
<cfelse>
	<cfif isDefined('url.create') AND structCount(form) greater than 1>
		<!---Запрос на INSERT --->
		<cfif isDefined('form.comment_short') AND  isDefined('form.comment_full') AND isDefined('form.urgency') AND isDefined('form.critical')>
			<cfset aErrorMessages = application.errorService.validateError(form.comment_short, form.comment_full, form.urgency, form.critical)/>
			<cfif ArrayIsEmpty(aErrorMessages)>
				<cfset application.errorService.createError(form.comment_short, form.comment_full, form.urgency, form.critical)/>
			</cfif>
		<cfelse>
			<cfset aErrorMessages = ['Ошибка добавления: недостаточно данных']/>
		</cfif>
	</cfif>
	<cfset mode = "getAll" />
</cfif>

<cfif mode EQ "getAll">
	<cfset pageTitle = "Список ошибок" />
	<cfset rsAllErrors = application.errorService.getAllErrors() />
<cfelse>
	<cfset pageTitle = 'Ошибка №' & page_err_id />
	<cfset rsOneError = application.errorService.getErrorByID(page_err_id)/>
</cfif>

<cfinclude template="../partials/header.cfm">
<script src="../scripts/jqmin.js" ></script> 
<script>
	let backup = new Array();
document.addEventListener('DOMContentLoaded', function()  {
		$('#error-data-form .editable-data').css("box-shadow", "none");
		
    $('select.editable-data').on('keypress', function(event){
    	event.preventDefault();
    });
    $('#err_form_edit_btn').on('click', function(event){
    	event.preventDefault();
			$("#err_form_noedit_btn").css("display", "inline-block");
			$("#err_form_submit_btn").css("display", "inline-block");
			$("#err_form_edit_btn").css("display", "none");
    	$('#error-data-form .editable-data').each(function(i,e){
    		backup.push(e.value);
    	})
	    $('#error-data-form .editable-data').removeAttr("readonly")
			$('#error-data-form .editable-data').css("box-shadow", "0px 0px 0px 1px black");
    });
    $('#err_form_noedit_btn').on('click', function(event){
    	event.preventDefault();
			$("#err_form_noedit_btn").css("display", "none");
			$("#err_form_submit_btn").css("display", "none");
			$("#err_form_edit_btn").css("display", "inline-block");
    	$('#error-data-form .editable-data').each(function(i,e){
    		e.value = backup.shift();
    		if(e.nodeName == "TEXTAREA")
    			textAreaAdjust(e);
    	})

	    $('#error-data-form .editable-data').attr("readonly", "")
			$('#error-data-form .editable-data').css("box-shadow", "none");
    });
    $('#err_form_submit_btn').on('click', function(event){
    	let s1 = document.getElementById("urgency");
    	let s2 = document.getElementById("critical");
    	let formValid = validSel(s1) && validSel(s2);
    	if (!formValid) {
	    	event.preventDefault();
    	}
    });
    $('textarea.editable-data').on('keyup', function(e){
    	textAreaAdjust(e.target)
    });
    let tas = document.getElementsByTagName("textarea") 
    for (var i = 0; i < tas.length; i++) {
		tas[i].style.height = "1px";
    	tas[i].style.height = (tas[i].scrollHeight)+"px";
    }
});
// const urgencyValues = ["Очень срочно","Срочно","Несрочно","Совсем несрочно"]
// const criticalValues = ["Авария","Критичная","Некритичная","Запрос на изменение"]
function textAreaAdjust(element) {
  element.style.height = "1px";
  element.style.height = (element.scrollHeight)+"px";
}
function validSel(selectObj){
	if (selectObj.value == "none") {
		document.getElementById("validMessage_" + selectObj.id).style.visibility = "visible"
		return false;
	}else{
		document.getElementById("validMessage_" + selectObj.id).style.visibility = "hidden"
		return true;
	}
}
</script>
<main><div id="maincontainer">
	<!--- <cfoutput> <div id="debug" style="font:bold 20pt; color: darkred;">
		<!--- ## --->
		<cfset x = application.errorService.validateError(form.comment_short, form.comment_full, form.urgency, form.critical)/>
		<cfdump var="#x#">
	</div></cfoutput> --->
	<cfif mode EQ "getAll">
		<link rel="stylesheet" href="../styles/table-sort.css">
		<script src="../scripts/table-sort.js" ></script> 
		<h1 style="display: inline;">Список ошибок</h1>
		<cfif structKeyExists(variables,'aErrorMessages') AND ArrayisEmpty(aErrorMessages)>
			<h3 style="color: lightseagreen; display: inline; padding-left: 50px;">Операция выполнена успешно</h3>
		<cfelseif structKeyExists(variables,'aErrorMessages') AND NOT ArrayisEmpty(aErrorMessages)>
			<h3 style="color: red; display: inline; padding-left: 50px;">Ошибка: операция не выполнена</h3>
		</cfif>
		<div id="errors-table">
			<table class="table_sort">
				<thead>
		      <tr style="position: sticky; top: 3rem;border-top: ">
		       	<th>id</th>
		        <th>Добавлена</th>
		       	<th>Комментарий</th>
		        <th>Подробное описание</th>
		        <th>Статус</th>
		        <th>Срочность</th>
		      	<th>Критичность</th>
		       	<th></th>
		      </tr>
				</thead>
				<tbody>
		      <cfoutput query="rsAllErrors">
			      <tr>
							<td>#iderror#</td>
							<td>#dateTimeFormat(ParseDateTime(ToString(datetime_created)), 'yyyy.mm.dd')#</td>
							<td>#comment_short#</td>
							<td>#comment_full#</td>
							<td>#status#</td>
							<td>#urgency#</td>
							<td>#critical#</td>
							<td><a href="errors.cfm?iderror=#iderror#">Подробнее</a></td>
						</tr>
		      </cfoutput>
				</tbody>
	        </table>
		</div>
		<cfif rsAllErrors.recordCount EQ 0>
			<h3 style="margin-left: count(50vw-11px);">Записей нет</h3>
		</cfif>
	<cfelse>
		<link rel="stylesheet" href="../styles/elemend-data.css">
		<link rel="stylesheet" href="../styles/error-data-form9.css">
		<h1 style="display: inline;">Ошибка #<cfoutput>#page_err_id#</cfoutput></h1> 
		<cfif structKeyExists(variables,'aErrorMessages') AND ArrayisEmpty(aErrorMessages)>
			<h3 style="color: lightseagreen; display: inline; padding-left: 50px;">Операция выполнена успешно</h3>
		<cfelseif structKeyExists(variables,'aErrorMessages') AND NOT ArrayisEmpty(aErrorMessages)>
			<h3 style="color: red; display: inline; padding-left: 50px;">Ошибка: операция не выполнена</h3>
		</cfif>
		<cfoutput >
			<form id="error-data-form" action="errors.cfm?update" method="post" accept-charset="utf-8">
				<input type="hidden" name="iderror" value="#page_err_id#">
				<div>
					<label>Комментарий:</label>
					<textarea id="comment_short" class="editable-data" name="comment_short" maxlength="100" readonly required>#rsOneError.comment_short#</textarea>
				</div>
				<div>
					<label>Подробное описание:</label>
					<textarea id="comment_full" class="editable-data" name="comment_full" maxlength="500" readonly required>#rsOneError.comment_full#</textarea>
				</div>
				<div>
					<label>Срочность:</label>
					<select id="urgency" class="editable-data" name="urgency" readonly="readonly" onblur="validSel(this)" onchange="validSel(this)" requred>
					  	<!--- <option value="none" selected disabled hidden></option>	 --->
						<cfset urgencyValues = ["Очень срочно","Срочно","Несрочно","Совсем несрочно"] />
						<cfloop index="i" array = "#urgencyValues#" item="el">
						    <cfoutput><option value="#el#" <cfif el EQ rsOneError.urgency>selected</cfif> >#el#</option></cfoutput>
						</cfloop>
					</select>
					<div class="validMessage" id="validMessage_urgency">Выберите вариант из списка</div>
				</div>
				<div>
					<label>Критичность:</label>
					<select id="critical" class="editable-data" name="critical" readonly="readonly" onblur="validSel(this)" onchange="validSel(this)" requred> 
						<cfset criticalValues = ["Авария","Критичная","Некритичная","Запрос на изменение"] />
						<cfloop index="i" array = "#criticalValues#" item="el">
						    <cfoutput><option value="#el#" <cfif el EQ rsOneError.critical>selected</cfif>>#el#</option></cfoutput>
						</cfloop>
					</select>
					<div class="validMessage" id="validMessage_critical">Выберите вариант из списка</div>
				</div>
				<!--- <input type="hidden" name="operation" value="update"> --->
				<div class="controls">
		   		<input form="error-data-form" id="err_form_submit_btn" type="submit" value="Сохранить">
					<button id="err_form_edit_btn" >Редактировать</button>
					<button id="err_form_noedit_btn" >Отменить</button>
				</div>
			</form>
			<div class="status_block">
				<div>
					<label>Статус:</label>
					<label id="status_current" class="editable-data">#rsOneError.status#</label>
				</div>
				<cfif NOT (rsOneError.status EQ "Закрытая")>
					<h2 style="	margin-top: 20px;">Обновить статус</h2>
					<div>
						<label id="label1">1) Введите комментарий</label>
						<label id="label2">2) Выберите действие</label>
					</div>	
					<form id="error_status_update_form" action="errors.cfm?newstatus" method="post" accept-charset="utf-8">
						<input type="hidden" name="iderror" value="#page_err_id#">
							<textarea id="comment" class="editable-data" name="comment" maxlength="500" required placeholder="Перед обновлением статуса введите комментарий"></textarea>
						<div id="status_controls">
							<cfif rsOneError.status EQ "Открытая">
								<input class="err_status_update_btn" type="submit" name="status" value="Решенная">
							<cfelseif rsOneError.status EQ "Новая">
								<input class="err_status_update_btn" type="submit" name="status" value="Открытая">
							<cfelseif rsOneError.status EQ "Решенная">
								<input class="err_status_update_btn" type="submit" name="status" value="Открытая">
								<input class="err_status_update_btn" type="submit" name="status" value="Закрытая">
							</cfif>
						</div>
					</form>
				</cfif>
			</div>				
			<cfset rsJournal = application.errorService.getErrorJournalById(page_err_id)/>
		</cfoutput>
		<h2 style="	margin-top: 20px;">Журнал изменений</h2>
		<div id="journal">
			<link rel="stylesheet" href="../styles/table-test-style.css">
			<table class="table_test">
				<thead>
		            <tr style="position: sticky; top: 3rem;border-top: ">
		                <th>Добавлен</th>
		            		<th>Статус</th>
		                <th>Комментарий</th>
		                <th>Пользователь</th>
		            </tr>
				</thead>
				<tbody>
		        <cfoutput query="rsJournal">
			        <tr>
								<td>#dateTimeFormat(ParseDateTime(ToString(datetime)), 'mmm dd, hh:mm')#</td>
								<td>#action#</td>
								<td>#comment#</td>
								<td>#name# #surname#</td>
							</tr>
		        </cfoutput>
				</tbody>
		  </table>
			<cfif rsJournal.recordCount EQ 0>
				<h3 style="margin-left: 250px;">Записей нет</h3>
			</cfif>
		</div>
	</cfif>
</div></main>
<cfinclude template="../partials/footer.cfm">