component output="true"{
    remote struct function registerUser(string name,string email,string phoneNumber,string userName,string password) returnformat="JSON"{
        var response={
            message:'',
            success:false
        };
        try{
            if(len(arguments.name)>50){
                response.message="Name limit exceeding";
            }
            else if(len(arguments.userName)>50){
                response.message="user Name limit exceeding";
            }
            else if(len(arguments.email)>100){
                response.message="email limit exceeding";
            }
            else if(len(arguments.password)>255)
            {
                response.message="password limit exceeding";
            }
            else{
                var registerUser=new model.userDAO() ;
                var emailExists=registerUser.emailExists(arguments.email);
                if(emailExists)
                {
                    response.message="email already exists";
                }
                else{
                    var hashedPassword = hash(arguments.password, "SHA-256");
                    var registered=registerUser.insertUser(arguments.name,arguments.email,arguments.phoneNumber,arguments.userName,hashedPassword);
                    if(registered)
                    {
                            emailBody = "
                            <html>
                                <body>
                                    <p>Dear User,</p>
                                    <p>Congratulations! Your registration with Course Craft has been successfully completed.</p>
                                    <p>You can now log in to your account using the credentials you provided during registration.</p>
                                    <p>If you have any questions or need assistance, please feel free to contact our support team.</p>
                                    <p>Welcome aboard, and happy learning!</p>
                                    <p>Regards,<br>Course Craft Team</p>
                                </body>
                            </html>
                            ";
                        cfmail(
                            to=arguments.email,
                            from="coursecraft123@gmail.com",
                            subject="Registration successful",
                            type="html",
                            charset="utf-8",
                            username="coursecraft123@gmail.com",
                            password="qmpt pvqc ymjr uzrh",
                            server="smtp.gmail.com",
                            port="465",
                            useSSL="true")
                        {
                            writeOutput(emailBody);
                        }
                        response.message="registered successfully";
                        response.success=true;
                    }
                    else{
                        response.message="could not register";
                    }
                }
            }
        }
        catch(any e){
            response.message=e.message;
        }
        return response;  
    }

    remote struct function loginUser(string email,string password) returnformat="JSON"{
        var response={
            message:'',
            success:false
        };
        try{
            var loginUser=new model.userDAO();
            var emailExists = loginUser.emailExists(arguments.email);
            if(emailExists)
            {
                var hashedPassword = hash(arguments.password, "SHA-256");
                var login=loginUser.checkUser(arguments.email,hashedPassword);   
                if(login){
                    var userDetails = loginUser.getUserDetails(arguments.email);
                    //setting session variables
                    if(!structIsEmpty(userDetails))
                    {
                        session.userID = userDetails.userID;
                        session.fullName = userDetails.fullName;
                        session.userName = userDetails.userName;
                        session.userEmail = arguments.email;
                        session.role = userDetails.role;
                        session.profileImage=userDetails.profileImagePath;
                        session.isLoggedIn = true;

                        response.message="Logged in successfully";
                        response.success=true; 
                        response.role=userDetails.role;
                    }
                    else{
                        response.message="Problem in fetching User"; 
                    } 
                }
                else{
                    response.message="incorrect password";
                }
            }
            else {
                response.message="User does not exists";
            }
        }
        catch(any e){
            response.message=e.message;
        }
    return response;
    }

    remote struct function forgotUser(string email) returnformat="JSON"{
        var response={
            message:'',
            success:false
        };
        try{
            var forgotUser=new model.userDAO();
            var emailExists = forgotUser.emailExists(arguments.email);
            if(emailExists)
            {
                resetToken = createUUID();
                resetTokenExpiration = dateAdd("h",1,now());
                var tokenUpdated=forgotUser.updateToken(arguments.email,resetToken,resetTokenExpiration);
                if(tokenUpdated)
                {
                    resetLink = "http://localhost:8500/MiniProject/index.cfm?action=resetPassword&resetToken=" & resetToken;
                    emailBody = "
                        <html>
                        <body>
                            <p>Dear User,</p>
                            <p>We received a request to reset your password. Click the link below to reset your password:</p>
                            <p><a href='" & resetLink & "'>Reset Password</a></p>
                            <p>If you did not request a password reset, please ignore this email.</p>
                            <p>Regards,<br>Course Craft</p>
                        </body>
                        </html>
                        ";
                    cfmail(
                        to=arguments.email,
                        from="coursecraft123@gmail.com",
                        subject="Reset Password",
                        type="html",
                        charset="utf-8",
                        username="coursecraft123@gmail.com",
                        password="qmpt pvqc ymjr uzrh",
                        server="smtp.gmail.com",
                        port="465",
                        useSSL="true")
                    {
                        writeOutput(emailBody);
                    }
                    response.message="Mail sent to your email id check your email box";
                    response.success=true;
                }
                else{
                            response.message="Failed to send the mail try again"; 
                    } 
            }
            else {
                response.message="User does not exists";
            }
        }
        catch(any e){
            response.message=e.message;
        }
    return response;
    }

    remote struct function resetUser(string password,string token) returnformat="JSON"{
        var response={
            message:'',
            success:false
        };
        try{
            var resetUser=new model.userDAO();
            var tokenValidation = resetUser.validateToken(arguments.token);
            if(!structIsEmpty(tokenValidation))
            {
                var hashedPassword = hash(arguments.password, "SHA-256");
                var passswordUpdated=resetUser.updatePassword(hashedPassword,tokenValidation.email);
                if(passswordUpdated)
                {
                    response.message="password reset successful";
                    response.success=true;
                }
                else{
                    response.message="Failed to reset password";
                }              
            }
            else {
                response.message="The reset link is invalid or has been expired";
            }
        }
        catch(any e){
            response.message=e.message;
        }
    return response;
    }

    remote struct function logoutUser() returnformat="JSON"{
        var response={
            messsage='',
            success=false
        }
        try{
            sessionInvalidate();
            response.message="Logged out successfully";
            response.success=true;
        }
        catch (any e) {
            response.message=e.message;  
        }
        return response;
    }
}