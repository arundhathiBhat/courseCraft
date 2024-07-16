$(document).ready(function() {
    $('#submitBtnLogin').on("click",function(event) {
        event.preventDefault();
        var validated = validateForm();
        if (validated) {
                var email= $('#yourEmail').val().trim();
                var password= $('#yourPassword').val().trim();
                console.log("validation success");
                $.ajax({
                type: 'POST',
                url: './controller/userServices.cfc?method=loginUser', 
                data: {
                    email:email,
                    password:password
                },
                dataType: 'json', 
                success: function(response) {
                    var messageDiv = $('#messageDiv');
                    if (response.SUCCESS) {
                        messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                        messageDiv.html('logged in successfully');
                     
                        if (response.ROLE === 'Admin') {
                            setTimeout(function() {
                                window.location.href = './index.cfm?action=admin.dashboard';
                            }, 2000); 
                        } else {
                            setTimeout(function() {
                                window.location.href = './index.cfm?action=admin.dashboard';
                            }, 2000); 
                        }
                    } 
                    else {
                        messageDiv.removeClass('alert-success').addClass('alert-danger').show();
                        messageDiv.html('Login failed: ' + response.MESSAGE);
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
        isValid &= validateEmail();
        isValid &= validatePassword();
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

    function validateEmail() {
        var email = $('#yourEmail').val().trim();
        var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email === '') {
            showError('#yourEmail', 'Please enter your email.');
            return false;
        } 
        else if (!regex.test(email)) {
            showError('#yourEmail', 'Please enter a valid email address.');
            return false;
        } 
        else {
            showError('#yourEmail', '');
            return true;
        }
    }

    function validatePassword() {
        var password = $('#yourPassword').val().trim();
        var regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+])[A-Za-z\d!@#$%^&*()_+]{8,}$/;
        if (password === '') {
            showError('#yourPassword', 'Please enter your password!');
            return false;
        }
        else if (!regex.test(password)) {
            showError('#yourPassword', 'Incorrect password');
            return false;
        } 
         else {
            showError('#yourPassword', '');
            return true;
        }
    }
});
