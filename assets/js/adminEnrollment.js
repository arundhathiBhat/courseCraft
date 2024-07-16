$(document).ready(function() {
    enrollmentDetails();
    Handlebars.registerHelper('incrementedIndex', function(value) {
        return parseInt(value) + 1;
      });
    Handlebars.registerHelper('eqStrict', function (a, b) {
        return String(a) === String(b);
    });
    function handlebars(context) {
        $.get('./assets/templates/enrollment.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#enrollment-details').html(html);
            $('#enrollmentDetails').DataTable();
        });
    }
    $(document).on('click', '.approve-btn', function(){
        var enrollmentID = $(this).data('enrollmentid');
        statusChange(1,enrollmentID);
    });
    
    $(document).on('click', '.decline-btn', function(){
        var enrollmentID = $(this).data('enrollmentid');
        statusChange(0,enrollmentID);
    });

    function enrollmentDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/adminServices.cfc?method=enrollment',
            dataType: 'json',
            success: function(response) {
                console.log(response);
                if (response.SUCCESS) {
                    context = response;
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

    function statusChange(status,enrollmentID) {
        if(status)
        {
            $('#confirmation .modal-body').text("The user will be enrolled to course after approving. Are you sure you want to approve?");
        }
        else{
            $('#confirmation .modal-body').text("The user will not be enrolled to course after declining. Are you sure you want to decline?");
        }
        $('#confirmation').modal('show');
        $(document).on('click', '#approveOrDecline', function() {
            var status1=status;
            var enrollmentID1=enrollmentID;
            $.ajax({
                type: 'POST',
                url: './controller/adminServices.cfc?method=approveDecline',
                data:{
                    status:status1,
                    enrollmentID:enrollmentID1
                },
                dataType: 'json',
                success: function(response) {
                    var messageDiv = $('#successDiv');
                    if (response.SUCCESS) {
                        if(status1 == 1){
                            messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                            messageDiv.html('Enrollment Approved successfully');
                            setTimeout(function() {
                                enrollmentDetails();
                                messageDiv.hide();
                            }, 2000); 
                        }
                        else{
                            messageDiv.removeClass('alert-danger').addClass('alert-success').show();
                            messageDiv.html('Enrollment Rejected successfully');
                            setTimeout(function() {
                                enrollmentDetails();
                                messageDiv.hide();
                            }, 2000); 
                           
                        }
                      
                    } else {
                        console.log("Error");
                    }
                },
                error: function(xhr, status, error) {
                    alert('AJAX error: ' + error);
                }
            });
        });
    }
});