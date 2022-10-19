<cfif structKeyExists(URL,'logout')>
	<cfset application.authService.doLogout() />
</cfif>
<!---Form processing begins here--->
<cfif structkeyExists(form,'submitLogin')>
	<!---server side data validation--->
	<cfset aErrorMessages = application.authService.validateUser(form.login,form.password) />
	<cfif ArrayisEmpty(aErrorMessages)>
		<!---proceed to the login procedure--->
		<cfset isUserLoggedIn = application.authService.doLogin(form.login,form.password) />
    <!--- <cfif structKeyExists(form,'noaccessTarget')>
      <cflocation url="#form.noaccessTarget#" />
    </cfif> --->
	</cfif>
</cfif>
<!---Form processing end here--->


<cfset pageTitle = "Авторизация" />
<cfinclude template="../partials/header.cfm">
<main><div id="maincontainer">
<link rel="stylesheet" href="../styles/auth-style3.css">
  <div class="form_auth_block">
    <div class="form_auth_block_content">
	    <cfif structKeyExists(session,'stLoggedInUser')>
	    	<!---Display a welcome message--->
        <cfoutput>
          <div class="welcome">
  	    	  <label >Welcome #session.stLoggedInUser.userLastName# #session.stLoggedInUser.userFirstName#!</label>
  	    	  <a class="form_auth_button" href="/TestTask/pages/users.cfm?idUsers=#session.stLoggedInUser.userID#">Мой профиль</a>
          </div>
        </cfoutput>
	    <cfelse>
       <div class="messageContainer">
          <div class="errorMessage">
            <cfif structKeyExists(url,'noaccess')>
              <p >Для доступа к запрошенной странице необходима авторизация</p>
            </cfif>
            <cfif structKeyExists(variables,'aErrorMessages') AND NOT ArrayIsEmpty(aErrorMessages)>
              <cfoutput>
                <cfloop array="#aErrorMessages#" item="message">
                  <p >#message#</p>
                </cfloop>
              </cfoutput>
            </cfif>
            <cfif structKeyExists(variables,'isUserLoggedIn') AND isUserLoggedIn EQ false>
              <p >Пользователь не найден!</p>
            </cfif>
          </div>
       </div>
        <p class="form_auth_block_head_text">Авторизация</p>
        <cfform class="form_auth_style" action="login.cfm" method="post">
          <label>Введите логин</label>
          <input type="text" name="login" placeholder="Введите Ваш логин" required >
          <label>Введите пароль</label>
          <input type="password" name="password" placeholder="Введите пароль" required >
          <!--- <cfif structKeyExists(url,'noaccessTarget')>
            <cfoutput>
              <input type="hidden" name="noaccessTarget" value="#url.noaccessTarget#">
            </cfoutput>
          </cfif> --->
          <!--- <button class="form_auth_button" type="submit" >Войти</button>  --->
  		    <cfinput class="form_auth_button" type="submit" name="submitLogin" id="submitLogin" value="Войти" />
        </cfform>	
	    </cfif>
    </div>
  </div>
</div></main>