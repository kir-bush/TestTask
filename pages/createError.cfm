<cfset pageTitle = "Регистрация ошибки" />
<cfinclude template="../partials/header.cfm">
<script src="../scripts/jqmin.js" ></script> 
<script>
	let backup = new Array();
document.addEventListener('DOMContentLoaded', function() {
	 	$("#err_form_submit_btn").css("display", "inline-block");
    $('select.editable-data').on('keypress', function(event){
    	event.preventDefault();
    });
    $('#err_form_submit_btn').on('click', function(event){
    	let s1 = document.getElementById("urgency");
    	let s2 = document.getElementById("critical");
    	let formValid = validSel(s1) && validSel(s2);
    	console.log(formValid)
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
<main> <div id="maincontainer">
	<link rel="stylesheet" href="../styles/elemend-data.css">
	<link rel="stylesheet" href="../styles/error-data-form9.css">
	<h1 style="display: inline;">Регистрация ошибки</h1> 
		<form id="error-data-form" action="errors.cfm?create" method="post" accept-charset="utf-8">
			<div>
				<label>Комментарий</label>
				<textarea id="comment_short" class="editable-data" name="comment_short" maxlength="100" required></textarea>
			</div>
			<div>
				<label>Подробное описание</label>
				<textarea id="comment_full" class="editable-data" name="comment_full" maxlength="500"  required></textarea>
			</div>
			<div>
				<label>Срочность</label>
				<select id="urgency" class="editable-data" name="urgency" onblur="validSel(this)" onchange="validSel(this)" requred>
				  	<option value="none" selected disabled hidden></option>	
					<cfset urgencyValues = ["Очень срочно","Срочно","Несрочно","Совсем несрочно"] />
					<cfloop index="i" array = "#urgencyValues#" item="el">
					    <cfoutput><option value="#el#" >#el#</option></cfoutput>
					</cfloop>
				</select>
				<div class="validMessage" id="validMessage_urgency">Выберите вариант из списка</div>
			</div>
			<div>
				<label>Критичность</label>
				<select id="critical" class="editable-data" name="critical" onblur="validSel(this)" onchange="validSel(this)" requred> 
					<cfset criticalValues = ["Авария","Критичная","Некритичная","Запрос на изменение"] />
				  	<option value="none" selected disabled hidden></option>	
					<cfloop index="i" array = "#criticalValues#" item="el">
					    <cfoutput><option value="#el#">#el#</option></cfoutput>
					</cfloop>
				</select>
				<div class="validMessage" id="validMessage_critical">Выберите вариант из списка</div>
			</div>
			<!--- <input type="hidden" name="operation" value="update"> --->
		<div class="controls">
   		<input id="err_form_submit_btn" type="submit" value="Сохранить">
		</div>
		</form>
</div></main>
<cfinclude template="../partials/footer.cfm">