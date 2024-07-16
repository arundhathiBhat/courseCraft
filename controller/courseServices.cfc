component{
    remote struct function getCourseCategoryDetails()returnformat="JSON"{
        var response={
            "success"=false,
            "message"=''
        };
        try{
            var courseCategory=new model.courseDAO();
            var courseCatDetails=courseCategory.getCourseCategory();
            if(!session.isLoggedIn){
                if(!structIsEmpty(courseCatDetails)){
                    response={
                        "courseCatDetails"=courseCatDetails,
                        "success"=true
                    };
                }
            }
            else{
               var courseCatEnrolledCourse=new model.userSessionDAO();
               var courseCatEnCourse=courseCatEnrolledCourse.getCourseCatDetails();
               if(!structIsEmpty(courseCatEnCourse)){
                    response={
                    "courseCatDetails":courseCatEnCourse,
                    "success":true
                    };
               }

            }
        }
        catch(any e){
            response.message=e.message;
        }
        return response;
    }
    remote struct function courseContent(numeric courseId) returnformat="JSON"{
        var response={
            "success"=false,
            "message"=''
        };
        try {
            var categoryCourse = new model.courseDAO();
            var categoryCourseDetails = categoryCourse.getCourseCategoryByID(courseId);
            var moduleDetails=categoryCourse.getModulesById(arguments.courseId);
            if(!session.isLoggedIn){
                if(!structIsEmpty(categoryCourseDetails)){
                    response={
                        "role":'User',
                        "categoryCourseDetails":categoryCourseDetails,
                        "moduleDetails":moduleDetails,
                        "enrolled": false,
                        "success":true
                    };
                }
            }
            else{
                var enrollment=new model.userSessionDAO();
                var enrolledOrNot=enrollment.checkEnrollment(arguments.courseId);
                if(!structIsEmpty(enrolledOrNot)){
                    if(enrolledOrNot.status == 1){
                        var enrolledModules=enrollment.getModulestatus(arguments.courseId);
                        response={
                            "role":session.role,
                            "categoryCourseDetails":categoryCourseDetails,
                            "moduleDetails":enrolledModules,
                            "enrolledOrNot":enrolledOrNot,
                            "enrolled":true,
                            "success":true
                        };
                    }
                    else {
                        response={
                            "role":session.role,
                            "categoryCourseDetails":categoryCourseDetails,
                            "moduleDetails":moduleDetails,
                            "enrolledOrNot":enrolledOrNot,
                            "enrolled":true,
                            "success":true
                        };
                    }
                }
                else{
                    response={
                        "role":session.role,
                        "categoryCourseDetails":categoryCourseDetails,
                        "moduleDetails":moduleDetails,
                        "enrolledOrNot":enrolledOrNot,
                        "enrolled":false,
                        "success":true
                    };
                }
            }
        } 
        catch (any e) {
            response.message=e.message;
        }
        return response;
    }
    remote struct function searchCourse(string courseName) returnFormat="JSON"{
        var response={
            "success"=false,
            "message"=''
        };
        try {
            var courseDetails=new model.courseDAO();
            var courseFound=courseDetails.searchCourses(arguments.courseName);
                response={
                    "courseDetails":courseFound,
                    "success":true,
                    "message":'course found'
            };
        } 
        catch (any e) {
            response.message=e.message;
        }
        return response;
    }
}