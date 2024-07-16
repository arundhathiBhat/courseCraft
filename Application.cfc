
component {
    this.name = "myApplication1";
    this.applicationTimeout = CreateTimeSpan(10, 0, 0, 0); //10 days
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan(0, 0, 30, 0); //30 minutes
    this.datasource="cfminiproject";
   
    function onApplicationStart() { 
        
    }
    function onSessionStart() {
        session.date='dd/mm/yyyy';
        session.theme='light';
        session.timeZone='Asia/Culcutta';
        session.isLoggedIn=false;
    }
    function onRequestStart(string targetPage) {
        var allowedActions = {
            "home":"home",
            "register":"register",
            "login":"login",
            "forgotpassword":"forgotpassword",
            "resetPassword":"resetPassword",
            "profile":"profile",
            "dashboard":"dashboard",
            "courseDetail":"courseDetail",
            "courseCatalog":"courseCatalog",
            "admin.addCourseModule":"admin/addCourseModule",
            "admin.dashboard":"admin/dashboard",
            "admin.enrollment":"admin/enrollment",
            "moduleContent" : "moduleContent"       
        }
        if(url.keyExists("action") && allowedActions.keyExists(url.action)){
            if(!session.isLoggedIn && listFindNoCase('profile,dashboard,admin.dashboard,admin.addCourseModule,admin.enrollment,moduleContent',url.action)){
                request.viewPath = allowedActions["login"];
            }
            else if(session.isLoggedIn && session.role=='User' && listFindNoCase('admin.dashboard,admin.addCourseModule,admin.enrollment',url.action))
            {
                request.viewPath = allowedActions['dashboard'];
            }
            else if(session.isLoggedIn && session.role=='Admin' && listFindNoCase('dashboard',url.action))
            {
                request.viewPath = allowedActions['admin.dashboard'];
            }
            else{
                request.viewPath = allowedActions[url.action];
            }
        }

    } 
    public boolean function onMissingTemplate(string targetPage) {
    }
    function onError( any e) {
        writeDump(e);
    } 

}