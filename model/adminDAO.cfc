component {
    public numeric function getAllUser(){
        try{
            var UsersCountResult = queryExecute(
                "SELECT COUNT(*) AS userCount FROM Users WHERE role=:role",
                {role: {value: 'User', cfsqltype: "cf_sql_varchar"}},
                {datasource:"cfminiproject"}
            );
            if(UsersCountResult.recordCount > 0 && UsersCountResult.userCount[1] > 0) {
                return UsersCountResult.userCount[1];
            }
            else{
                return 0;
            }
        }
        catch (any e) {
            writeLog(file="Database", text="Error getting users count: " & e.message & "; Details: " & e.detail);
            return 0;
        }
    }
    
    public numeric function getAllEnrollments(){
        try{
            var enrollmentResult = queryExecute(
                "SELECT COUNT(*) AS enrollmentCount FROM Enrollments WHERE status=:status",
                {status: {value: 1, cfsqltype: "cf_sql_varchar"}},
                {datasource:"cfminiproject"}
            );
            if(enrollmentResult.recordCount > 0 && enrollmentResult.enrollmentCount[1] > 0) {
                return enrollmentResult.enrollmentCount[1];
            }
            else{
                return 0;
            }
        }
        catch (any e) {
            writeLog(file="Database", text="Error getting enrollment count: " & e.message & "; Details: " & e.detail);
            return 0;
        }
    }
    
    public numeric function getAllCertified(){
        try{
            var certifiedResult = queryExecute(
                "SELECT COUNT(*) AS certifiedCount FROM Enrollments WHERE progress=:progress",
                {progress: {value:100.00, cfsqltype: "cf_sql_varchar"}},
                {datasource:"cfminiproject"}
            );
            if(certifiedResult.recordCount > 0 && certifiedResult.certifiedCount[1] > 0) {
                return certifiedResult.certifiedCount[1];
            }
            else{
                return 0;
            }
        }
        catch (any e) {
            writeLog(file="Database", text="Error getting certified count: " & e.message & "; Details: " & e.detail);
            return 0;
        }
    }

    public array function getCourseDetails(){
        var courseDetailsArray = [];
        try{
            var courseDetailsResult= queryExecute(
                "SELECT 
                c.courseID AS courseID,
                cat.categoryName AS CategoryName,
                c.title AS courseTitle,
                c.CreatedAt AS courseCreatedDate,
                c.deleted,
                SUM(CASE WHEN e.status = 1 THEN 1 ELSE 0 END) AS numberOfEnrollments,
                SUM(CASE WHEN e.progress = 100.00 THEN 1 ELSE 0 END) AS numberOfCertified
                FROM Courses c
                LEFT JOIN Enrollments e ON c.courseID = e.courseID
                LEFT JOIN Categories cat ON c.categoryID = cat.categoryID
                GROUP BY cat.categoryName, c.courseID, c.title, c.CreatedAt,c.deleted",
                {datasource:"cfminiproject"}
            );
            for (var i = 1; i <= courseDetailsResult.recordCount; i++) {
                var row = {};
                for (var column in courseDetailsResult.columnList) {
                    if (column == "courseCreatedDate") {
                        row[column] = dateFormat(courseDetailsResult[column][i], "long");
                    } else {
                        row[column] = courseDetailsResult[column][i];
                    }
                }
                arrayAppend(courseDetailsArray, row);
            }
        }
        catch(any e)
        {
            writeLog(file="Database", text="Error getting course summary: " & e.message & "; Details: " & e.detail);
        }
        return courseDetailsArray;
    }
    public array function getAllCategory(){
        var categories=[];
        try{
            var allCategoryResult=queryExecute(
                "SELECT * FROM Categories",
                {datasource:"cfminiproject"}
            );
            for (var i = 1; i <=allCategoryResult.recordCount; i++) {
                var row = {};
                for (var column in allCategoryResult.columnList) {
                    row[column] = allCategoryResult[column][i];
                }
                arrayAppend(categories, row);
            }  
        }
        catch(any e)
        {
            writeLog(file="Database", text="Error getting course summary: " & e.message & "; Details: " & e.detail);
        }
        return categories;
    }

    public struct function getAllCoursesModules(){
        try{
            var allCoursesModulesResult = queryExecute(
                "SELECT 
                Categories.categoryID AS categoryID,
                Categories.categoryName AS categoryName,
                Courses.courseID, 
                Courses.title AS courseTitle, 
                Courses.description, 
                Courses.courseImagePath, 
                Modules.moduleID, 
                Modules.title AS moduleTitle, 
                Modules.contentFilePath
            FROM 
                Categories
            LEFT JOIN 
                Courses ON Categories.categoryID = Courses.categoryID AND Courses.deleted = 1
            LEFT JOIN 
                Modules ON Courses.courseID = Modules.courseID AND Modules.deleted = 1
            ORDER BY 
                Courses.courseID, Modules.moduleID",
                {datasource:"cfminiproject"}
            );
            category = {};

            // Loop through the query result to build the courses structure
            for (var i = 1; i <= allCoursesModulesResult.recordCount; i++) {
                var categoryID = allCoursesModulesResult.categoryID[i];
        
                // If the category doesn't exist in the structure, create it
                if (!structKeyExists(category, categoryID)) {
                    category[categoryID] = {
                        "categoryID": categoryID,
                        "categoryName": allCoursesModulesResult.categoryName[i],
                        "courses": []
                    };
                }
        
                // If the row contains course data, add the course to the category's courses array
                if (len(allCoursesModulesResult.courseID[i])) {
                    // Check if the course already exists in the category
                    var courseExists = false;
                    var courseIndex = -1;
                    for (var j = 1; j <= arrayLen(category[categoryID].courses); j++) {
                        if (category[categoryID].courses[j].courseID == allCoursesModulesResult.courseID[i]) {
                            courseExists = true;
                            courseIndex = j;
                            break;
                        }
                    }
        
                    // If the course doesn't exist, add it
                    if (!courseExists) {
                        var newCourse = {
                            "courseID": allCoursesModulesResult.courseID[i],
                            "title": allCoursesModulesResult.courseTitle[i],
                            "description": allCoursesModulesResult.description[i],
                            "courseImagePath": allCoursesModulesResult.courseImagePath[i],
                            "modules": []
                        };
                        arrayAppend(category[categoryID].courses, newCourse);
                        courseIndex = arrayLen(category[categoryID].courses);
                    }
        
                    // Add the module to the corresponding course's modules array if module data exists
                    if (len(allCoursesModulesResult.moduleID[i])) {
                        var newModule = {
                            "moduleID": allCoursesModulesResult.moduleID[i],
                            "title": allCoursesModulesResult.moduleTitle[i],
                            "contentFilePath": allCoursesModulesResult.contentFilePath[i]
                        };
        
                        // Find the course in the category and add the module
                        arrayAppend(category[categoryID].courses[courseIndex].modules, newModule);
                    }
                }
            }
            // Convert the courses structure to an array for easy iteration in templates

        }
        catch (any e) {
            writeLog(file="Database", text="Error getting certified count: " & e.message & "; Details: " & e.detail);
        }                
        return category;
    }
    public struct function getCourseDetail(numeric courseID){
        try{
            var courseDetailsResult=queryExecute(
                "SELECT title, description, courseImagePath,categoryID
                 FROM Courses
                 WHERE Courses.courseID =:courseID",
                 {courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"}},
                 {datasource:"cfminiproject"}
            );
            var row = {};
            for (var column in courseDetailsResult.columnList) {
                    row[column]= courseDetailsResult[column][1];
            } 
        }
        catch(any e)
        {
            writeLog(file="Database", text="Error getting course summary: " & e.message & "; Details: " & e.detail);
        }
        return row;
    }

    public struct function getModuleDetail(numeric moduleID){
        try{
            var moduleDetailsResult=queryExecute(
                "SELECT moduleID,title,contentFilePath
                 FROM Modules
                 WHERE moduleID =:moduleID",
                 {moduleID:{value:arguments.moduleID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            var row = {};
            for (var column in moduleDetailsResult.columnList) {
                    row[column] = moduleDetailsResult[column][1];
            } 
        }
        catch(any e)
        {
            writeLog(file="Database", text="Error getting course summary: " & e.message & "; Details: " & e.detail);
        }
        return row;
    }

    public boolean function insertCourse(string filePath,string title,string description,numeric categoryId){
        try{
            var insertCourseResult=queryExecute(
                "INSERT INTO Courses(title,description,courseImagePath,categoryID,createdAt)
                 VALUES(:title,:description,:courseImagePath,:categoryId,:createdAt)",
                 {
                    title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                    description:{value:arguments.description,cfsqltype:"cf_sql_nvarchar"},
                    courseImagePath:{value:arguments.filePath,cfsqltype:"cf_sql_nvarchar"},
                    categoryId:{value:arguments.categoryId,cfsqltype:"cf_sql_integer"},
                    createdAt:{value:now(),cfsqltype:"cf_sql_timestamp"}
                 },
                 {datasource:"cfminiproject"}
            );
            return true;
        }
        catch (any e) {
            writeLog(file="Database", text="Error inserting course: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }

    public boolean function updateCourse(string filePath,string title,string description,numeric categoryId,numeric itemId){
        try{
            var updateCourseResult=queryExecute(
                "UPDATE Courses
                 SET title=:title,
                 description=:description,
                 courseImagePath=:courseImagePath,
                 categoryID=:categoryId,
                 updatedAt=:updatedAt
                 WHERE courseID=:courseID",
                 {
                    title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                    description:{value:arguments.description,cfsqltype:"cf_sql_nvarchar"},
                    courseImagePath:{value:arguments.filePath,cfsqltype:"cf_sql_nvarchar"},
                    categoryId:{value:arguments.categoryId,cfsqltype:"cf_sql_integer"},
                    updatedAt:{value:now(),cfsqltype:"cf_sql_timestamp"},
                    courseID:{value:arguments.itemId,cfsqltype:"cf_sql_integer"}
                 },
                 {datasource:"cfminiproject"}
            );
            return true;
        }
        catch (any e) {
            writeLog(file="Database", text="Error updating course: " & e.message & "; Details: " & e.detail);
            return false;   
        }
    }

    public boolean function insertModule(string filePath,string title,numeric courseID){
        try{
            var insertCourseResult=queryExecute(
                "INSERT INTO Modules(title,contentFilePath,courseID,createdAt)
                 VALUES(:title,:contentFilePath,:courseID,:createdAt)",
                 {
                    title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                    contentFilePath:{value:arguments.filePath,cfsqltype:"cf_sql_nvarchar"},
                    courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"},
                    createdAt:{value:now(),cfsqltype:"cf_sql_timestamp"}
                 },
                 {datasource:"cfminiproject"}
            );
            return true;
        }
        catch (any e) {
            writeLog(file="Database", text="Error inserting module: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
    public boolean function updateModule(string filePath,string title,numeric moduleID){
        try{
            var updateCourseResult=queryExecute(
                "UPDATE Modules
                 SET title=:title,
                 contentFilePath=:contentFilePath,
                 updatedAt=:updatedAt
                 WHERE moduleID=:moduleID",
                 {
                    title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                    contentFilePath:{value:arguments.filePath,cfsqltype:"cf_sql_nvarchar"},
                    updatedAt:{value:now(),cfsqltype:"cf_sql_timestamp"},
                    moduleID:{value:arguments.moduleID,cfsqltype:"cf_sql_integer"}
                 },
                 {datasource:"cfminiproject"}
            );
            return true;
        }
        catch (any e) {
            writeLog(file="Database", text="Error updating Module: " & e.message & "; Details: " & e.detail);
            return false;   
        }
    }
    public boolean function deleteModulesByCourseID(numeric courseID) {
        try {
                var deleteModulesResult = queryExecute(
                    "UPDATE Modules
                    SET deleted=0 
                    WHERE courseID = :courseID",
                    {courseID: {value: arguments.courseID, cfsqltype: "cf_sql_integer"}},
                    {datasource: "cfminiproject"}
                );
                return true;
            }
            catch (any e) {
                writeLog(file="Database", text="Error deleting modules: " & e.message & "; Details: " & e.detail);
                return false;
            }
    }
        
    public boolean function deleteCourse(numeric courseID){
        try{
             // Begin a transaction
                transaction action="begin";
                var modulesDeleted = deleteModulesByCourseID(courseID);
                if (!modulesDeleted) {
                    transaction action="rollback";
                    return false;
                }
                var deleteCourseResult = queryExecute(
                    "UPDATE Courses 
                    SET deleted=0
                    WHERE courseID =:courseID",
                    {courseID: {value: arguments.courseID, cfsqltype: "cf_sql_integer"}},
                    {datasource: "cfminiproject"}
                );
                return true;
            }
            catch (any e) {
                transaction action="rollback";
                writeLog(file="Database", text="Error deleting course with modules: " & e.message & "; Details: " & e.detail);
                 return false;
            }
        }
    public boolean function deleteModule(numeric moduleID) {
        try {
                var deleteModuleResult = queryExecute(
                    "UPDATE Modules
                    SET deleted = 0
                    WHERE moduleID = :moduleID",
                    {moduleID: {value: arguments.moduleID, cfsqltype: "cf_sql_integer"}},
                    {datasource: "cfminiproject"}
                );
                return true;
            }
            catch (any e) {
                writeLog(file="Database", text="Error deleting module: " & e.message & "; Details: " & e.detail);
                return false;
            }
    }

    public array function getEnrollmentDetails(){
        try {
                var enrollmentDetailsResult = queryExecute(
                    "SELECT 
                    c.courseID,
                    c.title, 
                    u.userID,
                    u.fullName,
                    u.email,
                    e.enrollmentID,
                    e.enrollmentDate,
                    e.status
                FROM 
                    Enrollments e
                INNER JOIN 
                    Courses c ON e.courseID = c.courseID
                INNER JOIN 
                    Users u ON e.userID = u.userID
                ORDER BY 
                    e.enrollmentDate DESC
                ",
                {datasource: "cfminiproject"}
            );
            var combinedResults = [];

            // Loop through each row in the result set
                    for (var i = 1; i <= enrollmentDetailsResult.recordCount; i++) {
                
                // Create a structure with all the necessary details from the row
                    var details = {
                    "courseID": enrollmentDetailsResult.courseID[i],
                    "title":enrollmentDetailsResult.title[i],
                    "userID":enrollmentDetailsResult.userID[i],
                    "fullName": enrollmentDetailsResult.fullName[i],
                    "email": enrollmentDetailsResult.email[i],
                    "enrollmentID": enrollmentDetailsResult.enrollmentID[i],
                    "enrollmentDate": enrollmentDetailsResult.enrollmentDate[i],
                    "status": enrollmentDetailsResult.status[i]
                };
                
                // Append the details structure to the combinedResults array
                arrayAppend(combinedResults,details);
            }

        }
        catch (any e) {
            writeLog(file="Database", text="Error enrollment details: " & e.message & "; Details: " & e.detail);
        }
        return combinedResults;
    }
    
    public boolean function updateStatus(numeric status,numeric enrollmentID)
    {
        try{
            var updateStatusResult=queryExecute(
                    "UPDATE Enrollments
                    SET status=:status,
                    enrollmentDate=:enrollmentDate
                    WHERE enrollmentID=:enrollmentID",
                    {
                        status:{value:arguments.status,cfsqltype:"cf_sql_bit"},
                        enrollmentDate:{value:now(),cfsqltype:"cf_sql_timestamp"},
                        enrollmentID:{value:arguments.enrollmentID,cfsqltype:"cf_sql_integer"}
                    },
                    {datasource:"cfminiproject"}
                );
                return true;
            }
            catch (any e) {
                writeLog(file="Database", text="Error updating status: " & e.message & "; Details: " & e.detail);
                return false;
            }
            
    }
    public string function normalizeTitle(string title){
        title = trim(title); // Remove leading and trailing spaces
        title = rereplace(title, "\s+", "", "all"); // Remove all spaces
        return uCase(title); // Convert to uppercase
    }
    public boolean function checkCourseTitle(string title,numeric categoryID){
        try{
            // var normalizedTitle=normalizeTitle(arguments.title);
            var checkCourseTitleResult=queryExecute(
                "SELECT COUNT(*) AS count
                FROM Courses
                WHERE title = :title
                AND categoryID = :categoryID
                AND deleted = 1",
                {title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                categoryID:{value:arguments.categoryID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            if(checkCourseTitleResult.recordCount > 0 && checkCourseTitleResult.count > 0) {
                return true;
            }
            else{
                return false;
            }

        }
        catch(any e){
            writeLog(file="Database", text="Error checking Courses: " & e.message & "; Details: " & e.detail);
            return false;
        }

    }
    public boolean function checkCourseTitleForUpdate(numeric courseID,string title,numeric categoryID){
        try{
            //var normalizedTitle=normalizeTitle(arguments.title);
            var checkCourseTitleUpdateResult=queryExecute(
                "SELECT COUNT(*) AS count
                FROM Courses
                WHERE title = :title
                AND categoryID = :categoryID
                AND courseID != :courseID
                AND deleted=1",
                {title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                categoryID:{value:arguments.categoryID,cfsqltype:"cf_sql_integer"},
                courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            if(checkCourseTitleUpdateResult.recordCount > 0 && checkCourseTitleUpdateResult.count > 0) {
                return true;
            }
            else{
                return false;
            }

        }
        catch(any e){
            writeLog(file="Database", text="Error checking Courses for update: " & e.message & "; Details: " & e.detail);
            return false;
        }

    }
    public boolean function checkModuleTitle(string title, numeric courseID){
        try {
            // var normalizedTitle=normalizeTitle(arguments.title);
            var checkModuleResult=queryExecute(
                "SELECT COUNT(*) AS count
                FROM Modules
                WHERE courseID= :courseID
                AND title =:title
                AND deleted = 1",
                {title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                courseID:{value:arguments.courseID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
            );
            if(checkModuleResult.recordCount > 0 && checkModuleResult.count > 0) {
                return true;
            }
            else{
                return false;
            }
        } catch (any e) {
            writeLog(file="Database", text="Error checking module: " & e.message & "; Details: " & e.detail);
            return false;
        }
    }
   public boolean function checkModuleTitleForUpdate(string title, numeric moduleID){
        try {
            //   var normalizedTitle=normalizeTitle(arguments.title);
              var checkModuleUpdateResult=queryExecute(
                "SELECT COUNT(*) AS count
                FROM Modules
                WHERE courseID = (SELECT courseID FROM Modules WHERE moduleID = :moduleID)
                AND moduleID != :moduleID
                AND title = :title
                AND deleted = 1",
                {title:{value:arguments.title,cfsqltype:"cf_sql_nvarchar"},
                moduleID:{value:arguments.moduleID,cfsqltype:"cf_sql_integer"}},
                {datasource:"cfminiproject"}
              );
              if(checkModuleUpdateResult.recordCount > 0 && checkModuleUpdateResult.count > 0) {
                return true;
            }
            else{
                return false;
            }

        } catch (any e) {
            writeLog(file="Database", text="Error checking module for update: " & e.message & "; Details: " & e.detail);
            return false;
        }

   }
}

