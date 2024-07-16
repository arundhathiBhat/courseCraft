$(document).ready(function() {
    $('#sendLink').on("click",function(event) {
        event.preventDefault();
        var validated = validateForm();
        if (validated) {
                var email= $('#yourEmail').val().trim();
                console.log("validation success");
                $.ajax({
                type: 'POST',
                url: './controller/userServices.cfc?method=forgotUser', 
                data: {
                    email:email
                },
                dataType: 'json', 
                success: function(response) {
                    var messageDiv = $('#messageDiv');
                    if (response.SUCCESS) {
                        messageDiv.removeClass('alert-danger').addClass('alert-success');
                        messageDiv.html(response.MESSAGE);
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
        isValid &= validateEmail();
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
            showError('#yourEmail','');
            return true;
        }
    }
});
