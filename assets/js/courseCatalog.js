$(document).ready(function() {
    courseCatalogDetails();

    Handlebars.registerHelper('eq', function (a, b) {
        return a == b;
    });
    
    function handlebars(context) {
        $.get('./assets/templates/courseCatalog.hbs', function(templateData) {
            var source = templateData;
            var template = Handlebars.compile(source);
            var html = template(context);
            $('#catalog-content').empty().append(html);;
        });
    }

    function courseCatalogDetails() {
        $.ajax({
            type: 'POST',
            url: './controller/courseServices.cfc?method=getCourseCategoryDetails',
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
    $(document).on('click', '#clearFiltersButton', function() {
        $('input[name="category"]').prop('checked', false);
        $('input[name="module"]').prop('checked', false);
        $('#searchCourses').val('');
        applyFilters();
    });
    
    function applyFilters() {
        let selectedCategories = $('input[name="category"]:checked').map(function() {
            return this.value;
        }).get();
    
        let selectedModules = $('input[name="module"]:checked').map(function() {
            return this.value;
        }).get();
    
        const searchText = $('#searchCourses').val().toLowerCase();
    
        $('.course-card').each(function() {
            const card = $(this);
            const cardCategory = card.data('category-id').toString();
            const cardModuleCount = parseInt(card.data('module-count'), 10);
            const cardTitle = card.find('.card-title').text().toLowerCase();
            let showCard = true;
    
            if (selectedCategories.length > 0 && !selectedCategories.includes(cardCategory)) {
                showCard = false;
            }
    
            if (selectedModules.length > 0) {
                let moduleMatch = false;
                selectedModules.forEach(function(moduleRange) {
                    const [minModules, maxModules] = moduleRange.split('-').map(Number);
                    if (maxModules) {
                        if (cardModuleCount >= minModules && cardModuleCount <= maxModules) {
                            moduleMatch = true;
                        }
                    } else if (cardModuleCount >= minModules) {
                        moduleMatch = true;
                    }
                });
                if (!moduleMatch) {
                    showCard = false;
                }
            }
    
            if (searchText && !cardTitle.includes(searchText)) {
                showCard = false;
            }
    
            card.toggle(showCard);
        });
    }
    
    $(document).on('change', 'input[name="category"]', function() {
        applyFilters();
    });
    $(document).on('change', 'input[name="module"]', function() {
        applyFilters();
    });
    $(document).on('keyup', '#searchCourses', function() {
        applyFilters();
    });
});