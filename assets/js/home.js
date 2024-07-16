$(document).ready(function() {
    homeDetails();
    Handlebars.registerHelper('prependDotSlash', function(path) {
        return path ? './' + path : path;
    });
    function handlebars(context) {
        $.get('./assets/templates/home.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#home-content').html(html);
        });
       
    }
    function handlebarsSearch(context) {
        $.get('./assets/templates/home_search.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#search-content').html(html);
        });
       
    }
    function homeDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/courseServices.cfc?method=getCourseCategoryDetails',
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    context = response;
                    console.log(context);
                    handlebars(context);

                } else {
                    console.log("Error");
                }
            },
            error: function(xhr, status, error) {
                alert('AJAX error: ' + error);
            }
        });
    }
    $(document).on('click', '.course-card', function() {
        var courseId = $(this).data('course-id');
        window.location.href = './index.cfm?action=courseDetail&courseId=' + courseId;
    });

    $(document).on('click', '#courseCatalogButton', function() {
        window.location.href = './index.cfm?action=courseCatalog';
    });
    $(document).on('keyup','#searchCourse',function(){
        var courseName = $(this).val().toUpperCase().trim();
            // Check if the input is empty or contains only spaces
         if (courseName === "") {
        $('#search-content').html(""); // Assuming you have a container for search results
        return;
    }
        $.ajax({
            url: './controller/courseServices.cfc?method=searchCourse',
            type: 'POST',
            data: {
                courseName: courseName
            },
            dataType: 'json',
            success: function(response) {
                if(response.success)
               {     
                handlebarsSearch(response);
               }
            },
            error: function(xhr, status, error) {
                console.error('Error:', error);
            }
        });

    });
    $(document).on('focusout', '#searchCourse', function() {
        var courseName = $(this).val().trim();
        
        // Check if the input is empty or contains only spaces
        if (courseName === "") 
            // Clear the search results
            $('#search-content').html(""); // Assuming you have a container for search results
        
    });
    
});