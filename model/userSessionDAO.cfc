component{
    public struct function getUserDetail(){
        var details={};
        try{
            var userDetailsResult = queryExecute(
                "SELECT fullName,userName,email,phoneNumber,address,profileImagePath FROM Users
                WHERE userID=:userID",
                {userID: {value: session.userID, cfsqltype: "cf_sql_integer"}},
                {datasource: "cfminiproject"}
            );
            if(userDetailsResult.recordCount > 0) {
                details = {
                    fullName: userDetailsResult.fullName[1],
                    userName: userDetailsResult.userName[1],
                    userEmail: userDetailsResult.email,
                    phoneNumber:userDetailsResult.phoneNumber[1],
                    address:userDetailsResult.address[1],
                    profileImagePath:userDetailsResult.profileImagePath[1]
                };
            }
        }
         catch(any e){
            writeLog(file="Database", text="Error retrieving user: " & e.message & "; Details: " & e.detail);
        }
        return details;
    }
    public boolean function updateUserDetails(fullName,userName,emailId,phoneNumber,string address="",string filePath=""){
        try{
            var userUpdateResult = queryExecute(
                "UPDATE Users
                 SET fullName=:fullName,
                  userName=:userName,
                  email=:email,
                  phoneNumber=:phoneNumber,
                  address=:address,
                  profileImagePath=:profileImagePath,
                  updatedAt=:updatedAt
                  WHERE userID=:userID",
                {userID: {value: session.userID, cfsqltype: "cf_sql_integer"},
                fullName:{value:arguments.fullName,cfsqltype:"cf_sql_nvarchar"},
                userName:{value:arguments.userName,cfsqltype:"cf_sql_nvarchar"},
                email:{value:arguments.emailId,cfsqltype:"cf_sql_nvarchar"},
                address:{value:arguments.address,cfsqltype:"cf_sql_nvarchar"},
                phoneNumber:{value:arguments.phoneNumber,cfsqltype:"cf_sql_nvarchar"},
                profileImagePath:{value:arguments.filePath,cfsqltype:"cf_sql_nvarchar"},
                updatedAt:{value:now(),cfsqltype:"cf_sql_timestamp"}
                },
                {datasource: "cfminiproject"}
            );
            return true;
        }
         catch(any e){
            writeLog(file="Database", text="Error retrieving user: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public boolean function emailExists(string emailID){
        try {
            var emailCountResult = queryExecute(
                "SELECT COUNT(*) AS emailCount FROM Users
                 WHERE email = :email
                 AND userID != :userID",
                {
                    email: {value: arguments.emailID, cfsqltype: "cf_sql_varchar"},
                    userID: {value: session.userID, cfsqltype: "cf_sql_integer"}
                },
                {datasource: "cfminiproject"}
            );
            if (emailCountResult.recordCount > 0 && emailCountResult.emailCount[1] > 0) {
                return true;
            } else {
                return false;
            }
        } catch (any e) {
            writeLog(file="Database", text="Error checking email: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public boolean function checkPassword(string hashedPassword)
    {
        try{
            var checkPasswordResult = queryExecute(
                "SELECT password FROM Users 
                WHERE userID=:userID",
                {userID:{value:session.userID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            if(arguments.hashedPassword == checkPasswordResult.password)
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
    public boolean function updatePassword(string hashedPassword)
    {
        try{
            var updatePasswordResult = queryExecute(
                "UPDATE Users
                 SET password=:password
                WHERE userID=:userID",
                {password:{value:arguments.hashedPassword,cfsqltype:"cf_sql_nvarchar"},
                 userID:{value:session.userID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
         return true;
           
        }
        catch (any e) {
            writeLog(file="Database", text="Error updating password: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public boolean function deleteProfileImage(){
        try {
            var deleteProfileImageResult= queryExecute(
                "UPDATE Users 
                 SET profileImagePath=NULL
                 WHERE userID=:userID",
                 {userID:{value:session.userID,cfsqltype:"cf_sql_integer"}},
                 {datasource:"cfminiproject"}
            );
            return true;
        } catch (any e) {
            writeLog(file="Database", text="Error deleting profileImage: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public array function enrolledCourseOfUser(){
        try{
            var enrolledCourseDetailsResult = queryExecute(
                "SELECT e.enrollmentID,e.courseID,
                c.title AS courseTitle,
                c.description AS courseDescription,
                c.courseImagePath,
                e.enrollmentDate,
                e.progress,
                e.[status]
            FROM 
                Enrollments e
            JOIN 
                Courses c ON e.courseID = c.courseID
            WHERE 
                e.userID =:userID
                AND e.progress < 100
                AND e.[status] = 1
            ORDER BY e.enrollmentDate DESC",
                {userID: {value: session.userID, cfsqltype: "cf_sql_integer"}},
                {datasource: "cfminiproject"}
            );
            var enrolledCourseArray=[];
            for (var i = 1; i <= enrolledCourseDetailsResult.recordCount; i++) {
                var enrolledCourseStruct = {
                    "enrollmentID": enrolledCourseDetailsResult.enrollmentID[i],
                    "courseID": enrolledCourseDetailsResult.courseID[i],
                    "courseTitle": enrolledCourseDetailsResult.courseTitle[i],
                    "courseDescription":enrolledCourseDetailsResult.courseDescription[i],
                    "courseImagePath": enrolledCourseDetailsResult.courseImagePath[i],
                    "enrollmentDate": enrolledCourseDetailsResult.enrollmentDate[i],
                    "progress":enrolledCourseDetailsResult.progress[i]
                };
                arrayAppend(enrolledCourseArray, enrolledCourseStruct);
            }
        }
         catch(any e){
            writeLog(file="Database", text="Error retrieving enrolled course details: " & e.message & "; Details: " & e.detail);
        }
        return enrolledCourseArray;
    }

    public array function completedCourseOfUser(){
        try{
            var completedCourseResult = queryExecute(
                "SELECT 
                e.enrollmentID,
                e.courseID,
                c.title AS courseTitle,
                c.description AS courseDescription,
                c.courseImagePath,
                e.enrollmentDate,
                e.progress,
                e.[status]
            FROM 
                Enrollments e
            JOIN 
                Courses c ON e.courseID = c.courseID
            WHERE 
                e.userID =:userID
                AND e.progress = 100
                AND e.[status] = 1",
                {userID: {value: session.userID, cfsqltype: "cf_sql_integer"}},
                {datasource: "cfminiproject"}
            );
            var completedCourseArray=[];
            for (var i = 1; i <= completedCourseResult.recordCount; i++) {
                var completedCourseStruct = {
                    "enrollmentID": completedCourseResult.enrollmentID[i],
                    "courseID": completedCourseResult.courseID[i],
                    "courseTitle": completedCourseResult.courseTitle[i],
                    "courseDescription":completedCourseResult.courseDescription[i],
                    "courseImagePath": completedCourseResult.courseImagePath[i],
                    "enrollmentDate": completedCourseResult.enrollmentDate[i],
                    "progress":completedCourseResult.progress[i]
                };
                arrayAppend(completedCourseArray, completedCourseStruct);
            }
        }
         catch(any e){
            writeLog(file="Database", text="Error in completed course: " & e.message & "; Details: " & e.detail);
        }
        return completedCourseArray;
    }

    public struct function getCourseCatDetails() {
        try {
            var courseCategoryResult=queryExecute(
                "SELECT 
                c.courseID,
                c.title,
                c.description,
                c.courseImagePath,
                c.categoryID,
                cat.categoryName,
                e.enrollmentID,
                e.userID,
                e.progress,
                e.[status],
                (SELECT COUNT(*) FROM Modules m WHERE m.courseID = c.courseID) AS moduleCount
            FROM 
                Courses c
            LEFT JOIN 
                Enrollments e 
            ON 
                c.courseID = e.courseID 
                AND e.userID =:userId
            LEFT JOIN 
                Categories cat
            ON 
                c.categoryID = cat.categoryID
            WHERE c.deleted = 1
            ORDER BY 
                c.title",
            {userID: {value: session.userID, cfsqltype: "cf_sql_integer"}},
            {datasource: "cfminiproject"}
        );
        var category = {};

// Loop through the query result to build the courses structure
        for (row in courseCategoryResult) {
            var categoryID = row.categoryID;

            // If the category doesn't exist in the structure, create it
            if (!structKeyExists(category, categoryID)) {
                category[categoryID] = {
                    "categoryID": categoryID,
                    "categoryName": row.categoryName,
                    "courses": []
                };
            }
            var course = {
                "courseID": row.courseID,
                "title": row.title,
                "description": row.description,
                "courseImagePath": row.courseImagePath,
                "moduleCount": row.moduleCount,
                "enrollment":{} // Initialize enrollment as null
            };
            if (row.enrollmentID != "") {
                course.enrollment = {
                    "enrollmentID": row.enrollmentID,
                    "progress": row.progress,
                    "status": row.status
                };
            }
            arrayAppend(category[categoryID].courses, course);
            }
        } 
        catch (any e) {
             writeLog(file="Database", text="error in getting course category with enrollment details" & e.message & "; Details: " & e.detail);
        }
        return category;
    }

    public struct function certificationDetails(numeric enrollmentID){
      try {
            var certicateResult= queryExecute(
                "SELECT 
                c.title AS courseName,
                e.certifiedAT AS certifiedDate,
                u.fullName AS userFullName
            FROM 
                Enrollments e
            JOIN 
                Courses c ON e.courseID = c.courseID
            JOIN 
                Users u ON e.userID = u.userID
            WHERE 
                e.enrollmentID =:enrollmentID",
            {enrollmentID: {value: arguments.enrollmentID, cfsqltype: "cf_sql_integer"}},
            {datasource: "cfminiproject"}
            );
            var certificationDetails={};
            if(certicateResult.recordCount > 0) {
                certificationDetails = {
                    "courseName": certicateResult.courseName[1],
                    "certifiedDate": certicateResult.certifiedDate[1],
                    "userFullName": certicateResult.userFullName[1]
                };
            }
        }
        catch(any e){
            writeLog(file="Database", text="course completion page " & e.message & "; Details: " & e.detail);
        }
        return certificationDetails;
    }
    public boolean function enrollForCourse(numeric courseId){
        try{
                var enrollmentResult=queryExecute(
                    "INSERT INTO Enrollments(userID,courseID,enrollmentDate)
                      VALUES(:userID,:courseID,:enrollmentDate)",
                       {userID:{value:session.userID,cfsqltype:"cf_sql_integer"},
                        courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"},
                        enrollmentDate:{value:now(),cfsqltype:"cf_sql_timestamp"}},
                        {datasource:"cfminiproject"}
                );
                return true; 
        }
        catch(any e){
            writeLog(file="Database", text="enrollmentProcess" & e.message & "; Details: " & e.detail);
            return false;   
        }
    }
    public struct function checkEnrollment(numeric courseId){
        var enrollmentDetails={};
        try{
             var checkEnrollmentResult=queryExecute(
                "SELECT TOP 1 *
                 FROM Enrollments
                 WHERE courseID = :courseID AND userID = :userID
                 ORDER BY enrollmentDate DESC",
                  {courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"},
                    userID:{value:session.userID,cfsqltype:"cf_sql_integer"}},
                    {datasource:"cfminiproject"}
             );
             if(checkEnrollmentResult.recordCount > 0) {
                enrollmentDetails = {
                    "enrollmentId":checkEnrollmentResult.enrollmentID[1],
                    "status": checkEnrollmentResult.status[1],
                    "progress": checkEnrollmentResult.progress[1]
                };
            }
        }
        catch(any e){
            writeLog(file="Database", text="checking enrollment" & e.message & "; Details: " & e.detail);
        }
        return enrollmentDetails;
    }

    public array function getModulestatus(numeric courseId){
        try{
            var modulesCompletedResult=queryExecute(
                "SELECT 
                m.moduleID,
                m.title,
                m.contentFilePath,
                ec.completed
            FROM 
                Enrollments e
            JOIN 
                EnrolledCourses ec ON e.enrollmentID = ec.enrollmentID
            JOIN 
                Modules m ON ec.moduleID = m.moduleID
            WHERE 
                e.courseID =:courseID
                AND e.userID =:userID
                AND e.status = 1",
                {courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"},
                userID:{value:session.userID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            var modulesArray = [];
        
            // Loop through the query result and build the array of structures
            for (var i = 1; i <= modulesCompletedResult.recordCount; i++) {
                var moduleStruct = {
                    "moduleID": modulesCompletedResult.moduleID[i],
                    "moduleTitle": modulesCompletedResult.title[i],
                    "contentFilePath": modulesCompletedResult.contentFilePath[i],
                    "moduleCompleted":modulesCompletedResult.completed[i]
                };
                arrayAppend(modulesArray, moduleStruct);
            }
        }
        catch(any e){
            writeLog(file="Database", text="error in getting module status" & e.message & "; Details: " & e.detail);
        }
        return modulesArray;
    }
    public boolean function updateModuleStatus(numeric moduleId, numeric enrollmentId){
        try {
            var updateModuleStatusResult=queryExecute(
                "UPDATE EnrolledCourses
                 SET completed = 1
                 WHERE enrollmentID=:enrollmentID
                 AND moduleID=:moduleID",
                  {enrollmentID:{value:arguments.enrollmentId,cfsqltype:"cf_sql_integer"},
                  moduleID:{value:arguments.moduleId,cfsqltype:"cf_sql_integer"}},
                  {datasource:"cfminiproject"}
            );
            return true;
        } catch (any e) {
            writeLog(file="Database", text="error in updating module status" & e.message & "; Details: " & e.detail);
            return false;
        }  
    }
    public boolean function updateProgress(numeric enrollmentId){
        try {
            var getTotalModules = queryExecute(
                "SELECT COUNT(*) AS totalModules
                FROM EnrolledCourses ec
                INNER JOIN Enrollments e ON ec.enrollmentID = e.enrollmentID
                WHERE e.enrollmentID = :enrollmentID",
                {enrollmentID:{value:arguments.enrollmentId,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            var totalModules=getTotalModules.totalModules[1];
            var getCompletedModules = queryExecute(
                " SELECT COUNT(*) AS completedModules
                FROM EnrolledCourses
                WHERE enrollmentID = :enrollmentID AND completed = 1",
                {enrollmentID:{value:arguments.enrollmentId,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            var completedModules=getCompletedModules.completedModules[1];
            var progress = (completedModules / totalModules) * 100.0;
            var updateProgressResult=queryExecute(
                "UPDATE Enrollments
                SET progress = :progress
                WHERE enrollmentID = :enrollmentID",
                {enrollmentID:{value:arguments.enrollmentId,cfsqltype:"cf_sql_integer"},
                 progress:{value:progress,cfsqltype:"cf_sql_decimal"}},
                {datasource:"cfminiproject"}
            );
            if(progress == 100.00){
                var updateCertifiedResult=queryExecute(
                    "UPDATE Enrollments
                    SET certifiedAt =:certifiedAt
                    WHERE enrollmentID = :enrollmentID",
                    {enrollmentID:{value:arguments.enrollmentId,cfsqltype:"cf_sql_integer"},
                     certifiedAt:{value:now(),cfsqltype:"cf_sql_timestamp"}},
                    {datasource:"cfminiproject"}
                );
            }
            return true;
        } catch (any e) {
            writeLog(file="Database", text="error in updating progress" & e.message & "; Details: " & e.detail);
            return false;
        }
    }
}