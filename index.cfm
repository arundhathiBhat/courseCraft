<!DOCTYPE html>
<head>
    <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
</head>
    <!--- include header --->
    <cfinclude template="./view/header.cfm"/>
    <body>
      
        <cfinclude template="./view/#request.viewPath#.cfm"/> 
        <!--- <cfinclude template="dashboard.cfm"/> --->
    </body>
    <!--- include footer --->
    <cfinclude template="./view/footer.cfm"/>
</html>