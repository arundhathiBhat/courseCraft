$(document).ready(function() {
    $('#resetButton').on("click",function(event) {
        event.preventDefault();
        var validated = validateForm();
        if (validated) {
                var password= $('#yourPassword').val().trim();
                var token=$('#token').val();
                console.log("validation success");
                $.ajax({
                type: 'POST',
                url: './controller/userServices.cfc?method=resetUser', 
                data: {
                    password:password,
                    token:token
                },
                dataType: 'json', 
                success: function(response) {
                    var messageDiv = $('#messageDiv');
                    if (response.SUCCESS) {
                        messageDiv.removeClass('alert-danger').addClass('alert-success');
                        messageDiv.html(response.MESSAGE);
                        window.location.href = './index.cfm?action=login';
                    } 
                    else {
                        messageDiv.removeClass('alert-success').addClass('alert-danger');
                        messageDiv.html( response.MESSAGE);
                    }
                },
                error: function(xhr, status, error) {
                    // Handle AJAX errors
                    alert('AJAX error: ' + error);
                }
            });
        } 
        else {
            console.log('Validation failed');
        }
    });

    function validateForm() {
        var isValid = true;
        isValid &= validatePassword();
        isValid &= validatePasswordMatch();
        return isValid;
    }

    function showError(field, message) {
        if (message === '') {
            $(field).addClass('is-valid').removeClass('is-invalid');
        } 
        else {
            $(field).addClass('is-invalid').removeClass('is-valid');
        }
        $(field).next('.invalid-feedback').text(message).show();
    }

    function validatePassword() {
        var password = $('#yourPassword').val().trim();
        var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (password === '') {
            showError('#yourPassword', 'Please Enter Password');
            return false;
        } else if (!regex.test(password)) {
            showError('#yourPassword', 'Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character.');
            return false;
        } else {
            showError('#yourPassword', '');
            return true;
        }
    }

    function validatePasswordMatch() {
        var password = $('#yourPassword').val().trim();
        var confirmPassword = $('#confirmPassword').val().trim();
        if (confirmPassword === '') {
            showError('#confirmPassword', 'Please Confirm password');
            return false;
        } else if (password !== confirmPassword) {
            showError('#confirmPassword', 'Passwords do not match');
            return false;
        } else {
            showError('#confirmPassword', '');
            return true;
        }
    }

});
