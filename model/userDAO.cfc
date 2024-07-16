component {
    public boolean function emailExists(emailID){
        try{
            var emailCountResult = queryExecute(
                "SELECT COUNT(*) AS emailCount FROM Users
                WHERE email=:email",
                {email:{value:arguments.emailID,cfsqltype:"cf_sql_varchar"}},
                {datasource:"cfminiproject"}
            );
            if(emailCountResult.recordCount > 0 && emailCountResult.emailCount[1] > 0) {
                return true;
            }
            else{
                return false;
            }
        }
        catch (any e) {
            writeLog(file="Database", text="Error checking email: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function insertUser(string name,string email,string phoneNumber,string userName,string hashedPassword){
        try{
            var registerUser=queryExecute(
                "INSERT INTO Users(fullName,userName,password,email,phoneNumber,role,createdAt)
                VALUES(:fullName,:userName,:password,:email,:phoneNumber,:role,:createdAt)",
                {
                    fullName:{value:arguments.name,cfsqltype:"cf_sql_nvarchar"},
                    userName:{value:arguments.userName,cfsqltype:"cf_sql_nvarchar"},
                    password:{value:arguments.hashedPassword,cfsqltype:"cf_sql_nvarchar"},
                    email:{value:arguments.email,cfsqltype:"cf_sql_nvarchar"},
                    phoneNumber:{value:arguments.phoneNumber,cfsqltype:"cf_sql_nvarchar"},
                    role:{value:'User',cfsqltype:"cf_sql_nvarchar"},
                    createdAt:{value:now(),cfsqltype:"cf_sql_timestamp"}
                },
                {datasource:"cfminiproject"}
            );
           return true;
        }
        catch (any e) {
            writeLog(file="Database", text="Error registering user: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public boolean function checkUser(string email, string hashedPassword)
    {
        try{
            var loginUser = queryExecute(
                "SELECT password FROM Users 
                 WHERE email=:email",
                 {email:{value:arguments.email,cfsqltype:"cf_sql_varchar"}},
                 {datasource:"cfminiproject"}
            );
            if(arguments.hashedPassword == loginUser.password)
            {
                return true;
            }
            return false;
        }
        catch (any e) {
            writeLog(file="Database", text="Error comparing password: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public struct function getUserDetails(string email) {
        var details={};
        try{
            var userDetailsResult = queryExecute(
                "SELECT userID,fullName,userName,role,profileImagePath FROM Users
                WHERE email = :email",
                {email: {value: arguments.email, cfsqltype: "cf_sql_varchar"}},
                {datasource: "cfminiproject"}
            );
            if(userDetailsResult.recordCount > 0) {
                details = {
                    userID: userDetailsResult.userID[1],
                    fullName: userDetailsResult.fullName[1],
                    userName: userDetailsResult.userName[1],
                    userEmail: arguments.email,
                    role: userDetailsResult.role[1],
                    profileImagePath:userDetailsResult.profileImagePath[1]
                };
            }
           
        }
        catch(any e){
            writeLog(file="Database", text="Error retrieving user: " & e.message & "; Details: " & e.detail);
        }
        return details;
    }
    public boolean function updateToken(string email,string resetToken,date resetTokenExpiration) {
        try{
            var updateResetTokenResult = queryExecute(
                "UPDATE USERS
                SET resetToken=:resetToken,
                resetTokenExpiration=:resetTokenExpiration
                WHERE email = :email",
                {
                    resetToken: {value: arguments.resetToken, cfsqltype: "cf_sql_varchar"},
                    resetTokenExpiration: {value: arguments.resetTokenExpiration, cfsqltype: "cf_sql_timestamp"},
                    email: {value: arguments.email, cfsqltype: "cf_sql_varchar"}
                },
                {datasource: "cfminiproject"}
            );
            return true;
        }
        catch(any e){
            writeLog(file="Database", text="Error updating token: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public struct function validateToken(string resetToken) {
        var details={};
        try{
            var validateTokenResult = queryExecute(
                "SELECT email,resetTokenExpiration FROM Users  
                 WHERE resetToken=:resetToken",
                { resetToken: {value: arguments.resetToken, cfsqltype: "cf_sql_varchar"}},
                {datasource: "cfminiproject"}
            );
            if(validateTokenResult.recordCount>0 OR validateTokenResult.resetTokenExpiration>now())
            {
                details={
                    email:validateTokenResult.email[1],
                    resetTokenExpiration:validateTokenResult.resetTokenExpiration[1]
                }
            }    
        }
        catch(any e){
            writeLog(file="Database", text="Error validating token: " & e.message & "; Details: " & e.detail);
        }
        return details;
    }

    public boolean function updatePassword(string hashedPassword,string email) {
        try{
            var updatePasswordResult = queryExecute(
                "UPDATE Users
                 SET password=:password,
                 resetToken=NULL
                 WHERE email = :email",
                { 
                    password:{value:arguments.hashedPassword,cfsqltype:"cf_sql_nvarchar"},
                    email: {value: arguments.email, cfsqltype: "cf_sql_varchar"}
                },
                {datasource: "cfminiproject"}
            );
           return true;  
        }
        catch(any e){
            writeLog(file="Database", text="Error updating password: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    
    
}