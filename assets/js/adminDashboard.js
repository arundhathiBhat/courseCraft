$(document).ready(function() {
     // Perform AJAX POST request
     var context = {
        pagetitle: "Dashboard",
        cards: [
            {
              cardType: "customers",
              title: "Users",
              icon: "bi-people",
            },
            {
              cardType: "sales",
              title: "Enrollments",
              icon: "bi-pencil-square",
            },
            {
              cardType: "sales",
              title: "Certification",
              icon: "bi-patch-check-fill",
            }
          ]
    };
    Handlebars.registerHelper('eqStrict', function (a, b) {
      return a === b;
    });
     function handlebars(context){
        $.get('./assets/templates/adminDashboard.hbs', function(templateData) {
            // Assuming transactionsTemplate.hbs contains your Handlebars template
            var source = templateData; // This assumes templateData is the actual template content
    
            // Compile the Handlebars template
            var template = Handlebars.compile(source);
    
            // Render the template with the context data
            var html = template(context);
    
            // Append the rendered HTML to a specific element in your DOM
            $('#main-content').html(html);
            $('#courseSummaryTable').DataTable();
        });
     }
        $.ajax({
        type: 'POST',
        url: './controller/adminServices.cfc?method=adminDashboardDetails',
        dataType: 'json',
        success: function(response) {
            if(response.SUCCESS==true)
            {
                context.courseDetails = response;
                console.log(context);
                handlebars(context);
            }
            else{
                console.log("Error");
            }
        },
        error: function(xhr, status, error) {
            // Handle AJAX errors
            alert('AJAX error: ' + error);
        }
    });

    $(document).on("click",".notAvailable",function(){
            swal("This course is no longer available");
    })
  });
