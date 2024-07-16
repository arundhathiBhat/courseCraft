$(document).ready(function() {
    courseModuleDetails();
    Handlebars.registerHelper('addOne', function(value) {
        return value + 1;
    });
    function handlebars(context) {
        $.get('./assets/templates/addCourseModule.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#course-details').html(html);
        });
    }

    function courseModuleDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/adminServices.cfc?method=addCourseModules',
            dataType: 'json',
            success: function(response) {
                if (response.SUCCESS) {
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

    $(document).on('click', '.addCourseBtn', function() {
        openModal('add', 'course');
    });

    $(document).on('click', '.editCourseBtn', function() {
        var courseId = $(this).data('course-id');
        openModal('edit', 'course', courseId);
    });

    $(document).on('click', '.editModuleBtn', function() {
        var moduleId = $(this).data('module-id');
        openModal('edit', 'module', moduleId);
    });

    $(document).on('click', '.addModuleBtn', function() {
        var courseId = $(this).data('course-id');
        openModal('add', 'module', courseId);
    });

    $(document).on('click', '.deleteCourseBtn', function() {
        var courseId = $(this).data('course-id');
        deleteCourseModule('course', courseId);
    });

    $(document).on('click', '.deleteModuleBtn', function() {
        var moduleId = $(this).data('module-id');
        deleteCourseModule('module', moduleId);
    });
    
    $(document).on('click', '.saveChangesButton', function() {
        console.log(validateForm());
        if(validateForm()) {
            saveChanges();
        }
    });

    function validateForm() {
        const itemType = $('#itemType').val();
        let isValid = true;
        $('.error-message').remove();

        const title = $('#inputTitle').val().trim();
        if (title === '') {
            $('#inputTitleRow').append('<div class="error-message text-danger">Title is required.</div>');
            isValid = false;
        }

        const description = $('#inputDescription').val().trim();
        if (description === '') {
            $('#descriptionRow').append('<div class="error-message text-danger">Description is required.</div>');
            isValid = false;
        }

        const category = $('#inputCategory').val();
        if (!category || category === '') {
            $('#categoryRow').append('<div class="error-message text-danger">Category is required.</div>');
            isValid = false;
        }
        if(itemType === 'course')
        {    
            const fileUpload = $('#inputFile')[0].files[0];
            if (fileUpload) {
                const fileType = fileUpload.type;
                const validImageTypes = ['image/jpeg', 'image/png'];
                if (!validImageTypes.includes(fileType)) {
                    $('#fileUploadRow').append('<div class="error-message text-danger">Please upload a valid JPG or PNG file.</div>');
                    isValid = false;
                }
                else{
                    isValid=true;
                }
            } else {
                $('#fileUploadRow').append('<div class="error-message text-danger">Course Image is required.</div>');
                isValid = false;
            }
        }
        else{
            const moduleContentUpload = $('#inputModuleContent')[0].files[0];
            if (moduleContentUpload) {
                const fileType = moduleContentUpload.type;
                if (fileType !== 'application/pdf') {
                    $('#moduleContentRow').append('<div class="error-message text-danger">Please upload a valid PDF file.</div>');
                    isValid = false;
                }
                else{
                    isValid=true;
                }
            }
            else {
                $('#moduleContentRow').append('<div class="error-message text-danger">Module Content is required.</div>');
                isValid = false;
            }
        }
        return isValid;
    }

    function openModal(action, itemType, itemId = '') {
        $('#formType').val(action);
        $('#itemType').val(itemType);
        $('#itemId').val(itemId);

        if (itemType === 'course') {
            $('#modalTitle').text(action === 'add' ? 'Add Course' : 'Edit Course');
            $('#fileUploadRow').show();
            $('#descriptionRow').show();
            $('#categoryRow').show();
            $('#moduleContentRow').hide();

            if (action === 'edit') {
                fetchDetails(itemType, itemId);
            } else {
                $('#currentFileImage').empty();
               
                clearForm();
            }
        } 
        else{
            $('#modalTitle').text(action === 'add' ? 'Add Module' : 'Edit Module');
            $('#fileUploadRow').hide();
            $('#descriptionRow').hide();
            $('#categoryRow').hide();
            $('#moduleContentRow').show();

            if (action === 'edit') {
                fetchDetails(itemType, itemId);
            } else {
                $('#currentFileContent').empty();
                clearForm();
            }
        }

        $('#courseModuleModal').modal('show');
        $('.error-message').remove();
    }

    function fetchDetails(itemType, itemId) {
        $.ajax({
            url: './controller/adminServices.cfc?method=getCourseModule',
            method: 'POST',
            data: {
                itemType: itemType,
                id: itemId
            },
            dataType: 'json',
            success: function(response) {
                console.log(response);
                if (response.SUCCESS) {
                    $('#inputTitle').val(response.TITLE);
                    $('#inputDescription').val(response.DESCRIPTION);
                    $('#inputCategory').val(response.CATEGORYID);

                    $('#currentFileImage').empty();
                    $('#currentFileContent').empty();

                    if (itemType === 'course' && response.COURSEIMAGEPATH) {
                        let imageFileName = response.COURSEIMAGEPATH.split('/').pop();
                        $('#currentFileImage').html('<a href="' + response.COURSEIMAGEPATH + '" target="_blank">' + imageFileName + '</a>');
                    }

                    if (itemType === 'module' && response.CONTENTFILEPATH) {
                        let contentFileName = response.CONTENTFILEPATH.split('/').pop();
                        $('#currentFileContent').html('<a href="' + response.CONTENTFILEPATH + '" target="_blank">' + contentFileName + '</a>');
                    }
                } else {
                    swal({
                        icon:"error",
                        text:response.MESSAGE
                    });
                }
            },
            error: function(xhr, status, error) {
                alert('AJAX error: ' + error);
            }
        });
    }

    function clearForm() {
        $('#inputTitle').val('');
        $('#inputFile').val('');
        $('#inputDescription').val('');
        $('#inputCategory').val('');
        $('#inputModuleContent').val('');
    }

    function saveChanges() {
        $('#modalTitle').append('<div class="error-message text-danger"></div>');
        const formType = $('#formType').val();
        const itemType = $('#itemType').val();
        const itemId = $('#itemId').val()||0;
        const inputTitle = $('#inputTitle').val();
        const inputFile = $('#inputFile')[0].files[0];
        const inputDescription = $('#inputDescription').val();
        const inputCategory = $('#inputCategory').val();
        const inputModuleContent = $('#inputModuleContent')[0].files[0];
        let formDetails;

        if (itemType === 'course') {    
            formDetails = {
                formType,
                itemType,
                itemId,
                inputTitle,
                inputFile,
                inputDescription,
                inputCategory
            };
            var formData = new FormData();
                for (var key in formDetails) {
                if (formDetails.hasOwnProperty(key)) {
                formData.append(key, formDetails[key]);
                }
            }

            $.ajax({
                url: './controller/adminServices.cfc?method=addUpdateCourses',
                method: 'POST',
                data: formData,
                contentType: false,
                processData: false,
                dataType: 'json',
                success: function(response) {
                    var messageDiv = $('#messDiv');
                    if (response.SUCCESS) {
                        $('#courseModuleModal').modal('hide');
                        if(formType=='add') {
                            if(itemType == 'course'){
                                messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                                messageDiv.html('course added successfully');
                                setTimeout(function() {
                                    courseModuleDetails();
                                     messageDiv.hide();
                                }, 2000); 
                            }
                            
                        }
                        else{
                                messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                                messageDiv.html('course updated successfully');
                                setTimeout(function() {
                                    courseModuleDetails();
                                    messageDiv.hide();
                                }, 2000);  
                        }
        
                    } else {
                        swal({
                            icon:"error",
                            text:response.MESSAGE
                        });
                    }
                },
                error: function(xhr, status, error) {
                    alert('AJAX error: ' + error);
                }
            });
        } 
        else {
            formDetails = {
                formType,
                itemType,
                itemId,
                inputTitle,
                inputModuleContent
            };
            var formData = new FormData();
             for (var key in formDetails) {
                if (formDetails.hasOwnProperty(key)) {
                formData.append(key, formDetails[key]);
            }
          }
          $.ajax({
            url: './controller/adminServices.cfc?method=addUpdateModules',
            method: 'POST',
            data: formData,
            contentType: false,
            processData: false,
            dataType: 'json',
            success: function(response) {
                var messageDiv = $('#messDiv');
                if (response.SUCCESS) {
                    $('#courseModuleModal').modal('hide');
                    if(formType=='add') {
                            messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                            messageDiv.html('Module added successfully');
                            setTimeout(function() {
                                courseModuleDetails();
                                messageDiv.hide();
                            }, 2000); 
                        
                    }
                    else{
                            messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                            messageDiv.html('Module updated successfully');
                            setTimeout(function() {
                                courseModuleDetails();
                                 messageDiv.hide();
                            }, 2000); 
                        }
                } else {
                    swal({
                        icon:"error",
                        text:response.MESSAGE
                    });
                }
            },
            error: function(xhr, status, error) {
                alert('AJAX error: ' + error);
            }
        });
        }
    }

    function deleteCourseModule(itemType, itemId) {
        if(itemType == 'course')
        {
          
            $('#deleteConfirmation .modal-body').text("Are you sure you want to delete this course? Note: All the modules in this course will be deleted.");
               
        }
        else{
            $('#deleteConfirmation .modal-body').text("Are you sure you want to delete this module?");
        }
        $('#deleteConfirmation').modal('show');
        $(document).on('click', '#deleteConfirm', function() {
            var itemType1=itemType;
            var itemId1=itemId;
            console.log(itemType1);
            $.ajax({
                url: './controller/adminServices.cfc?method=deleteCourseModule',
                method: 'POST',
                data: {
                    itemType: itemType1,
                    itemId: itemId1
                },
                dataType: 'json',
                success: function(response) {
                    var messageDiv = $('#messDiv');
                    if(response.success) {
                        if(itemType1 == 'course'){
                                messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                                messageDiv.html('course deleted successfully');
                                setTimeout(function() {
                                    courseModuleDetails();
                                    messageDiv.hide();
                                }, 2000); 
                        }
                        else{
                                messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                                messageDiv.html('Module deleted successfully');
                                setTimeout(function() {
                                    courseModuleDetails();
                                    messageDiv.hide();
                                }, 2000); 
                            }
                    } 
                    else {
                        swal({
                            icon:"error",
                            text:response.MESSAGE
                        });
                    }
                },
                error: function(xhr, status, error) {
                    alert('AJAX error: ' + error);
                }
            });
        });
    }
});
