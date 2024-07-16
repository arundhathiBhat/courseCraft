component {
    remote struct function getUserDetails() returnformat="JSON"{
        var response={
            success=false
        };
        try{
            var userDetails=new model.userSessionDAO();
            var details=userDetails.getUserDetail();
            if(!structIsEmpty(details))
            {
                response.fullName = details.fullName;
                response.userName = details.userName;
                response.userEmail = details.userEmail;
                response.phoneNumber = details.phoneNumber;
                response.address=details.address;
                response.profileImagePath=details.profileImagePath;
                response.success=true; 
            }
        }
        catch (any e) {
            response.message = e.detail;
        }
        return response;
    }
    remote struct function updateUser(fullName,userName,emailId,phoneNumber,required string address="",file) returnformat="JSON"{
        var response={
            success=false
        };
        try{
            if(arguments.file != 0) 
            {
                     var uploadDirectory = expandPath("../Uploads/profileImage");
                    if (!directoryExists(uploadDirectory)) {
                        directoryCreate(uploadDirectory);
                    }
                    var uploadedFilePath = fileUpload(
                        destination="#uploadDirectory#", 
                        fileField="file",
                        onConflict= "makeunique");
                    var filePath = "Uploads/profileImage" & '/' & uploadedFilePath.serverFile;
            }
            else{
                filePath="";
            }
                 var checkEmail=new model.userSessionDAO();
                 var  emailExists=checkEmail.emailExists(arguments.emailId);
                 if(!emailExists)
                 {
                    var details=checkEmail.updateUserDetails(fullName,userName,emailId,phoneNumber,address,filePath);
                    session.userName = arguments.userName;
                    session.profileImage = filePath;
                    response.message="profile updated successfully";
                    response.success=true;
                 } 
                 else{
                    response.message="Email already exists";
                 }
        }
        catch (any e) {
            response.message = e.message;
        }
        return response;
    }
    remote struct function changePassword(string currentPassword,string newPassword)returnformat="JSON"{
        var response={
            success=false
        };
        try {
            var hashedPassword = hash(arguments.currentPassword, "SHA-256");
            var checkPwd=new model.userSessionDAO();
            var passwordCorrect=checkPwd.checkPassword(hashedPassword);
            if(passwordCorrect){
                var hashedNewPassword = hash(arguments.newPassword,"SHA-256");
                var updated=checkPwd.updatePassword(hashedNewPassword);
                if(updated){
                    response.message="password Updated successfully";
                    response.success=true;
                }
                else{
                    response.message="could not update the password";
                }
            }
            else{
                response.message="invalid password";
            }
            
        } catch (any e) {
            response.message = e.message;
        }
        return response;
    }

    remote struct function removeProfileImage()returnformat="JSON"{
        var response={
            "success"=false,
            "message"=''
        };
        try{
            var profileImage=new model.userSessionDAO();
            var removeProfileImage=profileImage.deleteProfileImage();
            if(removeProfileImage){
                session.profileImage="";
                response.message="profile photo has been removed";
                response.success=true;
            }
            else{
                response.message="problem in removing profile photo";
                response.success="false";
            }
        }
        catch(any e){
            response.message=e.message;
        }
        return response;
    }

    remote struct function userDashboardDetails() returnformat="JSON"{
        var response={
            "success"=false,
            "message"=''
        };
        try {
            var courseEnrollment = new model.userSessionDAO();
            var userDetails=courseEnrollment.getUserDetail();
            var enrolledCourse = courseEnrollment.enrolledCourseOfUser();
            var completedCourse = courseEnrollment.completedCourseOfUser();
            response={
                "userDetails":userDetails,
                "enrolledCourse":enrolledCourse,
                "completedCourse":completedCourse,
                "success":true
            };
        } 
        catch(any e) {
            response.message=e.message;
        }
        return response;
    }

    remote struct function downloadCertificate(numeric enrollmentID) returnformat="JSON" {
        var response = {
            "success": false,
            "message": '',
            "pdfUrl": ''
        };
        try {
            var certification = new model.userSessionDAO();
            var details = certification.certificationDetails(arguments.enrollmentID);
            if (!structIsEmpty(details)) {
                var pdfFile = expandPath('../certification/' & details.courseName & '.pdf');
                var htmlFilePath = expandPath('../certification.html');
                var htmlContent = fileRead(htmlFilePath);
                htmlContent = replace(htmlContent, "{{Name}}", details.userFullName, "all");
                htmlContent = replace(htmlContent, "{{CourseName}}", details.courseName, "all");
                htmlContent = replace(htmlContent, "{{certifiedAT}}", details.certifiedDate, "all");
                cfhtmltopdf(destination = pdfFile, overwrite = "yes") {
                    writeOutput(htmlContent);
                }
                response.success = true;
                response.pdfUrl = '/MiniProject/certification/' & details.courseName & '.pdf';
            } else {
                response.message = "Error in getting certification details";
            }
        } catch (any e) {
            response.message = e.message;
        }
        return response;
    }
    
    remote struct function enrollmentCourse(numeric courseId) returnformat="JSON"{
        var response={
            "success":false,
            "message":'',
            'isLoggedIn':''
        };
        try{
            if(!session.isLoggedIn){
                response.success=true;
                response.isLoggedIn=session.isLoggedIn;
                response.message='not logged in go to login page';
            }
            else{
                    var enrollUser=new model.userSessionDAO();
                    var enrolled=enrollUser.enrollForCourse(arguments.courseId);
                    if (enrolled){
                        response.success=true;
                        response.isLoggedIn=session.isLoggedIn;
                        response.message='your request has been sent, wait for some times';
                    }
                    else{
                        response.isLoggedIn=session.isLoggedIn;
                        response.message='problem facing in enrollment process';
                    }
            }
        }
        catch(any e){
            response.message = e.message;
        }
        return response;
    }
    remote struct function moduleCompletion(numeric moduleId,numeric enrollmentId) returnformat="JSON"{
        var response={
            "success":false,
            "message":''
        };
        try {
            var moduleCompletion=new model.userSessionDAO();
            var moduleCompleted=moduleCompletion.updateModuleStatus(arguments.moduleId,arguments.enrollmentId);
            if(moduleCompleted){
                var progressUpdated=moduleCompletion.updateProgress(arguments.enrollmentId);
                if(progressUpdated){
                    response={
                        "success":true,
                        "message":'successfully completed the module'
                    };
                }
                else{
                    response={
                        "success":false,
                        "message":'problem in updating the progress'
                    };
                }
            }
            else{
                response={
                    "success":true,
                    "message":'problem in module completion'
                }
            }
        } catch (any e) {
            response.message = e.message;
        }
        return response;
    }
}