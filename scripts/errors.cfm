<cfif isDefined('url.iderror')>
	<cfset mode = "getOne" />
	<cfset page_err_id = url.iderror />
<cfelseif isDefined('form.iderror')>
	<cfset mode = "put" />
	<cfset page_err_id = form.iderror />
		<!--- Запрос на UPDATE --->
		<cfupdate  tablename="error"/>
<cfelse>
	<cfif isDefined('form.comment_short')>
		<!---Запрос на INSERT --->
	</cfif>
	<cfset mode = "getAll" />
</cfif>

<cfif mode EQ "getAll">
	<cfset pageTitle = "Список ошибок" />
    <cfquery name="rsAllErrors" >
		SELECT *
		FROM error
		ORDER BY date DESC
	</cfquery>
<cfelse>
	<cfset pageTitle = 'Ошибка №' & page_err_id />
	<cfquery name="rsOneError" >
				SELECT *
				FROM error
				WHERE iderror = #page_err_id#
	</cfquery>
</cfif>

<cfinclude template="header.cfm">
<script src="./scripts/jqmin.js" ></script> 
<script>
document.addEventListener('DOMContentLoaded', () => {
    $('select.editable-data').on('keypress', (event)=>{
    	event.preventDefault();
    });
    $('#edit_btn').on('click', (event)=>{
    	event.preventDefault();
	    $('.editable-data').removeAttr("readonly")
    });
    $('#cancel_btn').on('click', (event)=>{
    	event.preventDefault();
	    $('.editable-data').attr("readonly", "")
    });
    $('#err_form_submit_btn').on('click', (event)=>{
    	let s1 = document.getElementById("urgency");
    	let s2 = document.getElementById("critical");
    	let formValid = validSel(s1) && validSel(s2);
    	if (!formValid) {
	    	event.preventDefault();
    	}
    });
    $('textarea.editable-data').on('keyup', (e)=>{
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
<main>
	<cfif mode EQ "getAll">
		<link rel="stylesheet" href="../styles/table-sort.css">
		<script src="./scripts/table-sort.js" ></script> 
		<h1>Список ошибок</h1>
		<div id="errors-table">
			<table class="table_sort">
				<thead>
		            <tr style="position: sticky; top: 3rem; z-index: 1; border-top: ">
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
							<td>#dateFormat(date, 'dd.mm.yyyy')#</td>
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
	<cfelse>
		<link rel="stylesheet" href="../styles/elemend-data.css">
		<link rel="stylesheet" href="../styles/error-data-form1.css">
		<h1>Ошибка #<cfoutput>#page_err_id#</cfoutput></h1>
		<cfoutput >
			<form id="error-data-form" action="errors.cfm" method="post" accept-charset="utf-8">
				<input type="hidden" name="iderror" value="#page_err_id#">
				<div>
					<label>Комментарий</label>
					<textarea id="comment_short" class="editable-data" name="comment_short" maxlength="100" readonly required>#rsOneError.comment_short#</textarea>
				</div>
				<div>
					<label>Подробное описание</label>
					<textarea id="comment_full" class="editable-data" name="comment_full" maxlength="500" readonly required>#rsOneError.comment_full#</textarea>
				</div>
				<div>
					<label>Срочность</label>
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
					<label>Критичность</label>
					<select id="critical" class="editable-data" name="critical" readonly="readonly" onblur="validSel(this)" onchange="validSel(this)" requred> 
						<cfset criticalValues = ["Авария","Критичная","Некритичная","Запрос на изменение"] />
						<cfloop index="i" array = "#criticalValues#" item="el">
						    <cfoutput><option value="#el#" <cfif el EQ rsOneError.critical>selected</cfif>>#el#</option></cfoutput>
						</cfloop>
					</select>
					<div class="validMessage" id="validMessage_critical">Выберите вариант из списка</div>
				</div>
	   			<p><input id="err_form_submit_btn" type="submit" value="Сохранить"></p>
			</form>
				<button id="edit_btn">Редактировать</button>
				<button id="cancel_btn">Отменить</button>
		</cfoutput>
		<div>
			
		</div>
		<div>
			
		</div>
	</cfif>
</main>
<cfinclude template="footer.cfm">