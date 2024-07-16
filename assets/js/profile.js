$(document).ready(function() {
    profileDetails();
    Handlebars.registerHelper('prependDotSlash', function(path) {
        return path ? './' + path : path;
    });
    function handlebars(context) {
        $.get('./assets/templates/profile.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#profile-content').html(html);
        });
    }

    function profileDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/userSessionServices.cfc?method=getUserDetails',
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

    $(document).on('click', '#updateProfile', function(event) {
        console.log("clicked");
        event.preventDefault();
        clearValidationMessages();
        var validated = validateForm();
        if (validated) {
            const fullName = $('#fullName').val().trim();
            const userName = $('#userName').val().trim();
            var emailId = $('#emailId').val().trim();
            const phoneNumber = $('#phoneNumber').val().trim();
            const file = $('#profileImageInput')[0].files[0] || 0;
            const address=$('#address').val().trim();
            // var file=saveImage();
            console.log(file);
            let formDetails={
                    fullName,
                    userName,
                    emailId,
                    phoneNumber,
                    address,
                    file
            };    
            var formData = new FormData();
            for (var key in formDetails) {
                if (formDetails.hasOwnProperty(key)) {
                    formData.append(key, formDetails[key]);
                }
            }
            console.log(formData);
            $.ajax({
                    url: './controller/userSessionServices.cfc?method=updateUser',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: 'json', 
                    success: function(response) {
                        console.log(response);
                        if(response.SUCCESS) {
                            $('#updateMessage').removeClass('alert-danger').addClass('alert-success');
                            $('#updateMessage').html(response.MESSAGE);
                            setTimeout(function() {
                                profileDetails();
                            }, 3000); 
                        }
                         else {
                            $('#updateMessage').removeClass('alert-success').addClass('alert-danger');
                            $('#updateMessage').html(response.MESSAGE);
                        }
                    },
                    error: function(xhr, status, error) {
                        showError('profileImageInput', 'Image upload failed. Please try again.');
                    }
                });
            // Perform form submission via AJAX or other means here if needed
        } else {
            console.log('Validation failed');
        }
    });

    function validateForm() {
        var isValid = true;
        isValid &= validateFullName();
        isValid &= validateEmail();
        isValid &= validateUserName();
        isValid &= validatePhoneNumber();
        return !!isValid; // Ensure the result is a boolean
    }

    // Validate full name
    function validateFullName() {
        var fullName = $('#fullName').val().trim();
        if (fullName === '') {
            showError('fullName', 'Full Name is required.');
            return false;
        }
        return true;
    }

    // Validate email id
    function validateEmail() {
        var emailId = $('#emailId').val().trim();
        if (emailId === '') {
            showError('emailId', 'Email Id is required.');
            return false;
        } else if (!isValidEmail(emailId)) {
            showError('emailId', 'Email Id is not valid.');
            return false;
        }
        return true;
    }

    // Validate user name
    function validateUserName() {
        var userName = $('#userName').val().trim();
        if (userName === '') {
            showError('userName', 'User Name is required.');
            return false;
        }
        return true;
    }

    // Validate phone number
    function validatePhoneNumber() {
        var phoneNumber = $('#phoneNumber').val().trim();
        if (phoneNumber === '') {
            showError('phoneNumber', 'Phone Number is required.');
            return false;
        } else if (!isValidPhoneNumber(phoneNumber)) {
            showError('phoneNumber', 'Phone Number is not valid.');
            return false;
        }
        return true;
    }

    // Validate profile image (accepts only image files)
    function validateProfileImage() {
        var profileImageInput = $('#profileImageInput');
        var profileImagePath = profileImageInput.val().toLowerCase();
        var allowedExtensions = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
        if (!allowedExtensions.exec(profileImagePath)) {
            showError('profileImageInput', 'Please select a valid image file (jpg/jpeg/png/gif).');
            return false;
        }
        return true;
    }

    // Utility function to show error message
    function showError(fieldId, message) {
        var errorElement = $('#' + fieldId + 'Error');
        if (errorElement.length) {
            errorElement.html(message);
        } else {
            $('#' + fieldId).after('<div id="' + fieldId + 'Error" class="error-message">' + message + '</div>');
        }
    }

    // Utility function to clear error messages
    function clearValidationMessages() {
        $('.error-message').remove();
    }

    // Utility function to check if the email format is valid
    function isValidEmail(email) {
        var emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }

    // Utility function to check if the phone number format is valid (basic validation)
    function isValidPhoneNumber(phoneNumber) {
        var phoneRegex = /^[0-9]{10}$/; // Assuming 10 digit phone number format
        return phoneRegex.test(phoneNumber);
    }

    // Handle profile image upload
    $(document).on('click', '#uploadImageButton', function(){
        $('#profileImageInput').click();
    });

    $(document).on('click', '#changePassword', function(event){
        event.preventDefault();
        var validated = validatePasswordForm();
        console.log(validated);
        if(validated){
            var currentPassword=$('#currentPassword').val().trim();
            var newPassword = $('#newPassword').val().trim();
            $.ajax({
                type: 'POST',
                url: './controller/userSessionServices.cfc?method=changePassword',
                data: {
                    currentPassword:currentPassword,
                    newPassword:newPassword
                },
                dataType: 'json',
                success: function(response) {
                    var messageDiv = $('#passwordMsg');
                    if (response.SUCCESS) {
                        messageDiv.removeClass('alert-danger').addClass('alert-success');
                        messageDiv.html('password updated successfully');
                        setTimeout(function() {
                            profileDetails();
                        }, 2000); 
                        
                    } 
                    else {
                        messageDiv.removeClass('alert-success').addClass('alert-danger');
                        messageDiv.html('password update ' + response.MESSAGE);
                    }
                },
                error: function(xhr, status, error) {
                    // Handle AJAX errors
                    alert('AJAX error: ' + error);
                }
            });
        }
    });
  
    function validatePasswordForm() {
        var isValid = true;
        isValid &= validatePassword();
        isValid &= validateNewPassword();
        isValid &= validatePasswordMatch();
        return !!isValid; // Ensure the result is a boolean
    }
    function validatePassword() {
        var currentPassword = $('#currentPassword').val().trim();
        var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (currentPassword === '') {
            showError('currentPassword', 'Please Enter Password');
            return false;
        } else if (!regex.test(currentPassword)) {
            showError('currentPassword', 'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character.');
            return false;
        } else {
            showError('currentPassword', '');
            return true;
        }
    }
    function validateNewPassword() {
        var newPassword = $('#newPassword').val().trim();
        var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (newPassword === '') {
            showError('newPassword', 'Please Enter Password');
            return false;
        } else if (!regex.test(newPassword)) {
            showError('newPassword', 'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character.');
            return false;
        } else {
            showError('newPassword', '');
            return true;
        }
    }

    function validatePasswordMatch() {
        var newPassword = $('#newPassword').val().trim();
        var renewPassword = $('#renewPassword').val().trim();
        if (renewPassword === '') {
            showError('renewPassword', 'Please Confirm password');
            return false;
        } else if (newPassword !== renewPassword) {
            showError('renewPassword', 'Passwords do not match');
            return false;
        } else {
            showError('renewPassword', '');
            return true;
        }
    }
    $(document).on('change', '#profileImageInput', function(){
        validateProfileImage();
    });
       
    $(document).on('click', '#removeImageButton', function()
    {     
            $('#deleteProfileConfirmation .modal-body').text("Are you sure You want to delete profile image");
            $('#deleteProfileConfirmation').modal('show');
        $(document).on('click', '#deleteProfileConfirm', function() {
            $.ajax({
                url: './controller/userSessionServices.cfc?method=removeProfileImage',
                type: 'POST',
                dataType:'json',
                success: function(response) {
                        if(response.success) {
                            $('#updateMessage').removeClass('alert-danger').addClass('alert-success');
                            $('#updateMessage').html(response.message);
                            setTimeout(function() {
                                profileDetails();
                            }, 2000);
                        }
                        else {
                            $('#updateMessage').removeClass('alert-success').addClass('alert-danger');
                            $('#updateMessage').html(response.message);
                        }
                },
                error: function(xhr, status, error) {
                    showError('profileImageInput', 'Image removal failed. Please try again.');
                }
            });
        });
    });

    $(document).on('click', '#saveUserSettings', function(event)
    {     
            
            event.preventDefault();
            $('#deleteProfileConfirmation .modal-body').text("Changes will be reflected to entire Application. Are you sure?");
            $('#deleteProfileConfirmation').modal('show');
            $(document).on('click', '#deleteProfileConfirm', function() {
            $.ajax({
                url: './controller/userSessionServices.cfc?method=changeUserSettings',
                type: 'POST',
                dataType:'json',
                success: function(response) {
                        if(response.success) {
                            $('#updateMessage').removeClass('alert-danger').addClass('alert-success');
                            $('#updateMessage').html(response.message);
                            setTimeout(function() {
                                profileDetails();
                            }, 2000);
                        }
                        else {
                            $('#updateMessage').removeClass('alert-success').addClass('alert-danger');
                            $('#updateMessage').html(response.message);
                        }
                },
                error: function(xhr, status, error) {
                    showError('profileImageInput', 'Image removal failed. Please try again.');
                }
            });
        });
    });
});
