$(document).ready(function() {
 $('#logoutLink').on("click",function(event) {
    event.preventDefault();
    $.ajax({
        type: 'POST',
        url: './controller/userServices.cfc?method=logoutUser', 
        dataType: 'json', 
        success: function(response) {
            if (response.SUCCESS) {
                    window.location.href = './index.cfm?action=home';
                } 
                else {
                    console.log(response.MESSAGE);
                } 
        },
        error: function(xhr, status, error) {
            // Handle AJAX errors
            alert('AJAX error: ' + error);
        }
    });
 });
});