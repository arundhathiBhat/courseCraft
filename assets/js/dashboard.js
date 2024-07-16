$(document).ready(function() {
    enrolledCourseDetails();

    function handlebars(context) {
        $.get('./assets/templates/dashboard.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#dashboard-content').html(html);
        });
    }

    function enrolledCourseDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/userSessionServices.cfc?method=userDashboardDetails',
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

    $(document).on('click','#certDownload',function(){
        var enrollmentID = $(this).data('enrollment-id');
        $.ajax({
            type: 'POST',
            url: './controller/userSessionServices.cfc?method=downloadCertificate',
            data:{
                enrollmentID:enrollmentID
            },
            dataType: 'json',
            success: function(response) {
                if (response.success) {
                    console.log(response.message);
                    // var link = document.createElement('a');
                    // link.href = response.pdfUrl;
                    // window.open(response.pdfUrl,'_blank');
                    // link.download = response.pdfUrl.split('/').pop();
                    // document.body.appendChild(link);
                    // link.click();
                    // document.body.removeChild(link);
                    var link = document.createElement('a');
                    link.href = response.pdfUrl;
                    link.download = response.pdfUrl.split('/').pop();
                    document.body.appendChild(link);
                    link.click();
                    document.body.removeChild(link);
                } 
                else {
                    console.log(response.message);
                }
            },
            error: function(xhr, status, error) {
                alert('AJAX error: ' + error);
            }
        });
    });
    
});