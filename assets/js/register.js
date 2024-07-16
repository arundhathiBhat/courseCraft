$(document).ready(function() {
    $('#submitBtn').on("click", function(event) {
        event.preventDefault(); // Prevent the default form submission

        var validated = validateForm();
        if (!validated) {
            console.log('not validated');
        } 
        else {
            var name = $('#yourName').val().trim();
            var email = $('#yourEmail').val().trim();
            var phoneNumber = $('#yourPhoneNumber').val().trim();
            var userName = $('#yourUserName').val().trim();
            var password = $('#yourPassword').val().trim();

            // Perform AJAX POST request
            $.ajax({
                type: 'POST',
                url: './controller/userServices.cfc?method=registerUser',
                data: {
                    name: name,
                    email: email,
                    phoneNumber: phoneNumber,
                    userName: userName,
                    password: password
                },
                dataType: 'json',
                success: function(response) {
                    var messageDiv = $('#messageDiv');
                    if (response.SUCCESS) {
                        messageDiv.removeClass('alert-danger').addClass('alert-success');
                        messageDiv.html('Registered successfully');
                        setTimeout(function() {
                            window.location.href = './index.cfm?action=login';
                        }, 3000); 
                    } 
                    else {
                        messageDiv.removeClass('alert-success').addClass('alert-danger');
                        messageDiv.html('Registration failed: ' + response.MESSAGE);
                    }
                },
                error: function(xhr, status, error) {
                    // Handle AJAX errors
                    alert('AJAX error: ' + error);
                }
            });
        }
    });

    function validateForm() {
        var isValid = true;
        isValid &= validateFullName();
        isValid &= validateEmail();
        isValid &= validateUserName();
        isValid &= validatePhoneNumber();
        isValid &= validatePassword();
        isValid &= validatePasswordMatch();
        isValid &= validateCheckbox();
        return !!isValid; // Ensure the result is a boolean
    }

    function showError(field, message) {
        if (message === '') {
            $(field).addClass('is-valid').removeClass('is-invalid');
        } else {
            $(field).addClass('is-invalid').removeClass('is-valid');
        }
        $(field).next('.invalid-feedback').text(message).show();
    }

    function validateFullName() {
        var fullName = $('#yourName').val().trim();
        if (fullName === '') {
            showError('#yourName', 'Please Enter Full Name');
            return false;
        } else {
            showError('#yourName', '');
            return true;
        }
    }

    function validateEmail() {
        var email = $('#yourEmail').val().trim();
        var regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (email === '') {
            showError('#yourEmail', 'Please Enter Email Address');
            return false;
        } else if (!regex.test(email)) {
            showError('#yourEmail', 'Please Enter valid Email Address');
            return false;
        } else {
            showError('#yourEmail', '');
            return true;
        }
    }

    function validateUserName() {
        var userName = $('#yourUserName').val().trim();
        if (userName === '') {
            showError('#yourUserName', 'Please Enter User Name');
            return false;
        } else {
            showError('#yourUserName', '');
            return true;
        }
    }

    function validatePhoneNumber() {
        var phoneNumber = $('#yourPhoneNumber').val().trim();
        var regex = /^\d{10}$/;
        if (phoneNumber === '') {
            showError('#yourPhoneNumber', 'Enter phone number');
            return false;
        } else if (!regex.test(phoneNumber)) {
            showError('#yourPhoneNumber', 'Enter Valid 10 digit phone number');
            return false;
        } else {
            showError('#yourPhoneNumber', '');
            return true;
        }
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

    function validateCheckbox() {
        if (!$('#acceptTerms').is(':checked')) {
            showError('#acceptTerms', 'Please accept terms and conditions');
            return false;
        } else {
            showError('#acceptTerms', '');
            return true;
        }
    }
});
