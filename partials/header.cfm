<!DOCTYPE html>
<html lang="ru">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="../styles/default.css">
    <link rel="stylesheet" href="../styles/header-style.css">
    <cfoutput><title>#pageTitle#</title></cfoutput>
  </head>
  <body>
    <header>
       
        <cfif structKeyExists(session,'stLoggedInUser')>
          <nav id="nav-controls">
            <ul id="nav-menu-list">            
              <li><a class="nav-button<cfif pageTitle EQ "Регистрация ошибки"> active</cfif>" href="/TestTask/pages/createError.cfm">Зарегистрировать ошибку</a></li>
              <li><a class="nav-button<cfif pageTitle EQ "Список ошибок"> active</cfif>" href="/TestTask/pages/errors.cfm">Список ошибок</a></li>
              <cfif isUserInRole('Administrator')>  
                <li><a class="nav-button<cfif pageTitle EQ "Регистрация пользователя"> active</cfif>" href="/TestTask/pages/createUser.cfm">Добавление пользователя</a></li>
                <li><a class="nav-button<cfif pageTitle EQ "Список пользователей"> active</cfif>" href="/TestTask/pages/users.cfm">Список пользователей</a></li>
              <cfelse>
                <cfoutput>
                  <li><a class="nav-button<cfif pageTitle EQ "Пользователь #session.stLoggedInUser.userID#"> active</cfif>" href="/TestTask/pages/users.cfm?idUsers=#session.stLoggedInUser.userID#">Мой профиль</a></li>
                </cfoutput>
              </cfif>  
              <li class="exit"><a class="nav-button" href="/TestTask/pages/login.cfm?logout">Выход</a></li>
            </ul>
          </nav>
        <cfelse>
          <label class="nav-button" >Error management system</label>
        </cfif>
      
    </header>