$(document).ready(function() {
    courseDetails();
    Handlebars.registerHelper('prependDotSlash', function(path) {
        return path ? './' + path : path;
    });
    Handlebars.registerHelper('eqStrict', function (a, b) {
        return String(a) === String(b);
    });
    function handlebars(context) {
        $.get('./assets/templates/courseDetail.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#course-content').html(html);
          
        });
    }
    function courseDetails() {
        
        var courseId=$('#courseId').val() || 0;
        if(courseId != 0)
        {    
            $.ajax({
                type: 'POST',
                url: './controller/courseServices.cfc?method=courseContent',
                data:{
                    courseId:courseId
                },
                dataType: 'json',
                success: function(response) {
                    if (response.success) {
                        context = response;
                        console.log(context);
                        handlebars(context);
                      
                    }
                    else {
                        console.log("Error");
                    }
                },
                error: function(xhr, status, error) {
                    alert('AJAX error: ' + error);
                }
        });
        }
    }
   
    
    $(document).on("click", ".module-title", function() {
        const moduleFile = $(this).data('module-file');
        const moduleId = $(this).data('module-id');
        const moduleTitle = $(this).text(); // Get the module title text
        const enrollmentId = $(this).data('enrollment-id');
        const pdfUrl = moduleFile; // Use the provided file path directly
    
        // Set the modal title to the module title
        $('#pdfViewerModal .modal-title').text(moduleTitle);
    
        // Show the PDF viewer and set the iframe src to the PDF URL
        $('#pdfViewerIframe').attr('src', pdfUrl);
        $('#pdfViewerContainer').show();
        $('#pdfViewerModal').modal('show');
    
        // Check if the module is already completed
        if ($(`#${moduleId}`).prop('checked')) {
            $('#markAsCompletedButton').prop('disabled', true);
        } else {
            $('#markAsCompletedButton').prop('disabled', false);
        }
    
        $(document).on('click', '#markAsCompletedButton', function() {
            $('#moduleConfirmation .modal-body').text("Are you sure you want to complete this course?");
            $('#moduleConfirmation').modal('show');
            $(document).on('click', '#completed', function() {
                $('#pdfViewerModal').modal('hide');
                $(`#${moduleId}`).prop('checked', true);
                    $.ajax({
                        type: 'POST',
                        url: './controller/userSessionServices.cfc?method=moduleCompletion',
                        data: {
                            moduleId: moduleId,
                            enrollmentId: enrollmentId
                        },
                        dataType: 'json',
                        success: function(response) {
                            if (response.success) {
                                courseDetails();
                            } else {
                                console.log("Error");
                            }
                        },
                        error: function(xhr, status, error) {
                            alert('AJAX error: ' + error);
                        }
                    });
                });
            });
    });
    

    function showError(fieldId, message) {
        var errorElement = $('#' + fieldId + 'Error');
        if (errorElement.length) {
            errorElement.html(message);
        } else {
            $('#' + fieldId).after('<div id="' + fieldId + 'Error" class="error-message">' + message + '</div>');
        }
    }
    function hideError(fieldId) {
        var errorElement = $('#' + fieldId + 'Error');
        if (errorElement.length) {
            errorElement.hide();
        }
    }
    $(document).on("click","#enrollButton",function(){
        hideError('enrollButton');
        $('#rejectMessage').hide();
        var courseID = $(this).data('course-id');
        var button = $(this); 
        $.ajax({
            type: 'POST',
            url: './controller/userSessionServices.cfc?method=enrollmentCourse',
            data:{
                courseId:courseID
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    showError('enrollButton',response.message);
                    button.prop('disabled', true);
                }
                else {
                    console.log("Error");
                }
            },
            error: function(xhr, status, error) {
                alert('AJAX error: ' + error);
            }
    });

    });
});