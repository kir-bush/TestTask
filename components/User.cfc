<cfcomponent persistent="true" entityname="User" table="Users"> 
<cfproperty name="id" column="idUsers" fieldtype="id" type="numeric"> 
<cfproperty name="login" fieldtype  = "column" type = "string" sqltype="varchar(45)"> 
<cfproperty name="password" fieldtype  = "column" type = "string" sqltype="varchar(45)"> 
<cfproperty name="name" fieldtype  = "column" type = "string" sqltype="varchar(45)"> 
<cfproperty name="surname" fieldtype  = "column" type = "string" sqltype="varchar(45)"> 
</cfcomponent>