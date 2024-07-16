component {
    remote struct function adminDashboardDetails() returnformat="JSON"{
        var response={
            success=false
        };
        try{
            var getUser=new model.adminDAO();
            var allUsers = getUser.getAllUser();
            var enrollments=getUser.getAllEnrollments();
            var certified=getUser.getAllCertified();
            var courseSummary=getUser.getCourseDetails();
            response={
                values:[allUsers,enrollments,certified],
                courseSummary:courseSummary,
                success:true
            }
        }
        catch (any e) {
            response.success=false;
            response.message=e;
        }
    return response;
    }

    remote struct function addCourseModules() returnformat="JSON"{
        var response={
            success=false
        };
        try{
            var getCourseModules=new model.adminDAO();
            var allCategories=getCourseModules.getAllCategory();
            var allCoursesModules=getCourseModules.getAllCoursesModules();
            response={
                allCategories:allCategories,
                allCourseModule:allCoursesModules,
                success:true
            }
        }
        catch(any e)
        {
            response.success=false;
            response.message=e.message;
        }
        return response;
    }
    remote struct function getCourseModule(string itemType,numeric id) returnformat="JSON"{
        var response={
            success=false
        }
        try {
            var getCourseModule=new model.adminDAO();
            if(arguments.itemType == 'course')
            {
                var courseDetails=getCourseModule.getCourseDetail(arguments.id);
                response=courseDetails;
                response.success=true; 
            }
            else {
                var moduleDetails=getCourseModule.getModuleDetail(arguments.id);
                response=moduleDetails;
                response.success=true;
            }
        } 
        catch (any e) {
            response.message=e.message;
        }
        return response;
    }

    remote struct function addUpdateCourses(string formType,string itemType,numeric itemId, string inputTitle,string inputFile,string inputDescription, numeric inputCategory)returnformat="JSON" {
        var response = {
            success = false,
            message = ''
        };
        try {
            var insertUpdate = new model.adminDAO();
                var uploadDirectory = expandPath("../Uploads/CourseImage");
                if (!directoryExists(uploadDirectory)) {
                    directoryCreate(uploadDirectory);
                }
                var uploadedFilePath = fileUpload(
                    destination="#uploadDirectory#", 
                    fileField="inputFile",
                    onConflict= "makeunique");
                var filePath = "Uploads/CourseImage" & '/' & uploadedFilePath.serverFile;
                if (arguments.formType == 'add') {
                    var uniqueTitle=insertUpdate.checkCourseTitle(arguments.inputTitle,arguments.inputCategory);
                    if(uniqueTitle){
                        response.success= false;
                        response.message="Course already exists in selected category";
                    }
                    else{
                        var inserted = insertUpdate.insertCourse(filePath, arguments.inputTitle, arguments.inputDescription, arguments.inputCategory);
                        if (inserted) {
                            response.success = true;
                        }
                    }
                } else {
                    var uniqueTitle=insertUpdate.checkCourseTitleForUpdate(arguments.itemId,arguments.inputTitle,arguments.inputCategory);
                    if(uniqueTitle){
                        response.success= false;
                        response.message="Course already exists in selected category";
                    }
                    else{
                        var updated = insertUpdate.updateCourse(filePath, arguments.inputTitle, arguments.inputDescription, arguments.inputCategory, arguments.itemId);
                        if (updated) {
                            response.success = true;
                        }
                    }
                }
            }
       catch (any e) {
            response.message = e.message;
        }
        return response;
     }
    remote struct function addUpdateModules(string formType,string itemType,numeric itemId, string inputTitle,any inputModuleContent= "") returnformat="JSON"{
        var response = {
            success = false,
            message = ''
        };
        try{
            var insertUpdate = new model.adminDAO();
                var uploadDirectory = expandPath("../Uploads/ModuleFile");
                if (!directoryExists(uploadDirectory)) {
                    directoryCreate(uploadDirectory);
                }
                var uploadedFilePath = fileUpload(
                    destination="#uploadDirectory#", 
                    fileField="inputModuleContent",
                    mimeType="application/pdf",
                    onConflict= "makeunique");
                var filePath = "Uploads/ModuleFile" & '/' & uploadedFilePath.serverFile;
                if (formType == 'add') {
                    var uniqueTitle=insertUpdate.checkModuleTitle(arguments.inputTitle,arguments.itemId);
                    if(uniqueTitle){
                        response.success= false;
                        response.message="Module already exists in selected course";
                    }
                    else{
                        var inserted = insertUpdate.insertModule(filePath,arguments.inputTitle, arguments.itemId);
                        if (inserted) {
                            response.success = true;
                        }
                    }
                } else {
                    var uniqueTitle=insertUpdate.checkModuleTitleForUpdate(arguments.inputTitle,arguments.itemId);
                    if(uniqueTitle){
                        response.success= false;
                        response.message="Module already exists in selected course";
                    }
                    else{
                        var updated = insertUpdate.updateModule(filePath, arguments.inputTitle, arguments.itemId);
                        if (updated) {
                            response.success = true;
                        }
                    }
                }
        } catch (any e) {
            response.message = e.message;
        }
        return response;
    }

    remote struct function deleteCourseModule(string itemType,numeric itemId) returnformat="JSON" {
        var response = {
            "success" = false,
            "message" = ''
        };
        try {
            var deleteCourseOrModule = new model.adminDAO();
            if (arguments.itemType == 'course') {
                var deleted=deleteCourseOrModule.deleteCourse(arguments.itemId);
                if(deleted){
                    response.success=true;
                }
            } else {
                    var deleted=deleteCourseOrModule.deleteModule(arguments.itemId);
                    if(deleted)
                    {
                        response.success=true;
                    }
                }
            }
        catch (any e) {
            response.message = e.message;
        }
        return response;
    }

    remote struct function enrollment() returnformat="JSON" {
        var response = {
            success = false
        };
        try {
            var enrollmentDetails = new model.adminDAO();
            var enrolled=enrollmentDetails.getEnrollmentDetails();
            response={
                enrollDetails:enrolled,
                success:true
            }
        }
        catch (any e) {
            response.message = e.message;
        }
        return response;
    }

    remote struct function approveDecline(numeric status,numeric enrollmentID) returnformat="JSON"{
        var response={
            success=false
        };
        try{
            var statusChange= new model.adminDAO();
            var statusChanged=statusChange.updateStatus(arguments.status,arguments.enrollmentID);
            if(statusChanged)
            {
                if(arguments.status == 1){
                    var enrollCourse=new model.courseDAO();
                    var enrolledCourse=enrollcourse.enrollCoursesModules(arguments.enrollmentID);
                    if(enrolledCourse){
                        response.success=true;
                    }
                    else{
                        response.success=false;
                    }
                }
                else{
                 response.success=true;
                }
            }
        }
        catch (any e) {
            response.message = e.message;
        }
        return response;
    }
}

