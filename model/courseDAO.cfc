component {
    public struct function getCourseCategory(){
        try {
            var courseCategoryResult=queryExecute(
                "SELECT 
                cat.categoryID,
                cat.categoryName,
                c.courseID,
                c.title,
                c.description,
                c.courseImagePath,
                COUNT(m.moduleID) AS moduleCount
            FROM 
                Categories cat
            LEFT JOIN 
                Courses c ON cat.categoryID = c.categoryID AND c.deleted = 1
            LEFT JOIN 
                Modules m ON c.courseID = m.courseID AND m.deleted=1
            GROUP BY 
                cat.categoryID,
                cat.categoryName,
                c.courseID,
                c.title,
                c.description,
                c.courseImagePath",
                {datasource: "cfminiproject"}
            );
            category= {};

            // Loop through the query result to build the courses structure
            for (row in courseCategoryResult) {
                categoryID = row.categoryID;
        
                // If the course doesn't exist in the structure, create it
                if (!structKeyExists(category, categoryID)) {
                    category[categoryID] = {
                        "categoryID": categoryID,
                        "categoryName": row.categoryName,
                        "courses":[]
                    };
                }
        
                // If the row contains module data, add the module to the course's modules array
                if (row.courseID != "") {
                    courses = {
                        "courseID": row.courseID,
                        "title": row.title,
                        "description":row.description,
                        "courseImagePath": row.courseImagePath,
                        "moduleCount":row.moduleCount
                    };
                    arrayAppend(category[categoryID].courses, courses);
                }
            }
        } catch (any e) {
            writeLog(file="Database", text="Error getting category course details: " & e.message & "; Details: " & e.detail);
        }
        return category;
    }

    public struct function getCourseCategoryById(numeric courseID){
        try {
            var courseCategoryResult=queryExecute(
                "SELECT 
                cat.categoryID,
                cat.categoryName,
                c.courseID,
                c.title,
                c.description,
                c.courseImagePath
            FROM 
                Categories cat
            LEFT JOIN 
                Courses c ON cat.categoryID = c.categoryID
                WHERE courseID=:courseID",
                {courseID={value:arguments.courseID,cfsqltype:"cf_sql_integer"}},
                {datasource: "cfminiproject"}
            );
            courseCategory= {};

            // Loop through the query result to build the courses structure
            for (row in courseCategoryResult) {
                    courseCategory = {
                        "categoryID": row.categoryID,
                        "categoryName": row.categoryName,
                        "courseID": row.courseID,
                        "title": row.title,
                        "description":row.description,
                        "courseImagePath": row.courseImagePath
                    };
            }
        } catch (exType exName) {
            writeLog(file="Database", text="Error getting category course details: " & e.message & "; Details: " & e.detail);
        }
        return courseCategory;
    } 
    public array function getModulesById(numeric courseID){
        try {
            var moduleResult=queryExecute(
                "SELECT 
                 moduleID,title,contentFilePath
                 FROM Modules 
                WHERE courseID=:courseID 
                AND deleted = 1",
                {courseID={value:arguments.courseID,cfsqltype:"cf_sql_integer"}},
                {datasource: "cfminiproject"}
            );
            var modulesArray = [];
        
            // Loop through the query result and build the array of structures
            for (var i = 1; i <= moduleResult.recordCount; i++) {
                var moduleStruct = {
                    "moduleID": moduleResult.moduleID[i],
                    "moduleTitle": moduleResult.title[i],
                    "contentFilePath": moduleResult.contentFilePath[i]
                };
                arrayAppend(modulesArray, moduleStruct);
            }
        }
        catch (any e) {
            writeLog(file="Database", text="Error getting module details: " & e.message & "; Details: " & e.detail);
        }
        return modulesArray;
    }
    public array function searchCourses(string courseName){
        try {
            var searchCourseResult=queryExecute(
                "SELECT  courseID,title,description,courseImagePath
                 FROM Courses
                 WHERE UPPER(title) LIKE :courseName 
                 AND deleted = 1 ",
                 {courseName={value:"%" & arguments.courseName & "%",cfsqltype:"cf_sql_nvarchar"}},
                 {datasource: "cfminiproject"}
            );
            var courseArray=[];
            for (var i = 1; i <= searchCourseResult.recordCount; i++) {
                var courseStruct = {
                    "courseID": searchCourseResult.courseID[i],
                    "courseTitle": searchCourseResult.title[i],
                    "description": searchCourseResult.description[i],
                    "courseImagePath":searchCourseResult.courseImagePath[i]
                };
                arrayAppend(courseArray, courseStruct);
            }
          
        } catch (any e) {
            writeLog(file="Database", text="Error getting course search details: " & e.message & "; Details: " & e.detail);
        }
        return  courseArray;
    }
    // public struct function searchCourseCategory(string courseName){
    //     try {
    //         var courseCategoryResult=queryExecute(
    //             "SELECT 
    //             cat.categoryID,
    //             cat.categoryName,
    //             c.courseID,
    //             c.title,
    //             c.description,
    //             c.courseImagePath
    //         FROM 
    //             Categories cat
    //         LEFT JOIN 
    //             Courses c ON cat.categoryID = c.categoryID AND UPPER(c.title) LIKE :courseName
    //             ORDER BY cat.categoryID, c.courseID",
    //             {courseName={value:"%" & arguments.courseName & "%",cfsqltype:"cf_sql_nvarchar"}},
    //             {datasource: "cfminiproject"}
    //         );
    //         category= {};

    //         // Loop through the query result to build the courses structure
    //         for (row in courseCategoryResult) {
    //             categoryID = row.categoryID;
        
    //             // If the course doesn't exist in the structure, create it
    //             if (!structKeyExists(category, categoryID)) {
    //                 category[categoryID] = {
    //                     "categoryID": categoryID,
    //                     "categoryName": row.categoryName,
    //                     "courses":[]
    //                 };
    //             }
        
    //             // If the row contains module data, add the module to the course's modules array
    //             if (row.courseID != "") {
    //                 courses = {
    //                     "courseID": row.courseID,
    //                     "title": row.title,
    //                     "description":row.description,
    //                     "courseImagePath": row.courseImagePath
    //                 };
    //                 arrayAppend(category[categoryID].courses, courses);
    //             }
    //         }
    //     } catch (any e) {
    //         writeLog(file="Database", text="Error getting category course search details: " & e.message & "; Details: " & e.detail);
    //     }
    //     return category;
    // }
    public boolean function enrollCoursesModules(numeric enrollmentID){
        try {
            cfstoredproc( procedure="InsertModulesForEnrollment",datasource="cfminiproject" ) {
                cfprocparam( cfsqltype="cf_sql_integer", value=arguments.enrollmentID );
                
            }
            return true;
        } catch (any e) {
            writeLog(file="Database", text="Error updating modules for enrollment: " & e.message & "; Details: " & e.detail);
                return false;
        }
    }
}