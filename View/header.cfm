<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">

  <title>CourseCraft</title>
  <meta content="" name="description">
  <meta content="" name="keywords">

  <!-- Favicons -->
  <link href="./assets/img/favicon.png" rel="icon">
  <link href="./assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Google Fonts -->
  <link href="https://fonts.gstatic.com" rel="preconnect">
  <link href="https://fonts.googleapis.com/css?family=Open+Sans:300,300i,400,400i,600,600i,700,700i|Nunito:300,300i,400,400i,600,600i,700,700i|Poppins:300,300i,400,400i,500,500i,600,600i,700,700i" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
  
  
  <!-- Vendor CSS Files -->
  <!--- <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous"> --->
  <link href="./assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="./assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="./assets/vendor/boxicons/css/boxicons.min.css" rel="stylesheet">
  <link href="./assets/vendor/quill/quill.snow.css" rel="stylesheet">
  <link href="./assets/vendor/quill/quill.bubble.css" rel="stylesheet">
  <link href="./assets/vendor/remixicon/remixicon.css" rel="stylesheet">
  <link href="./assets/vendor/simple-datatables/style.css" rel="stylesheet">
  <link href="./assets/css/style.css" rel="stylesheet">
  <link href="./assets/css/profile.css" rel="stylesheet">
  <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
  
  <!--handlebars--> 
  <script src="https://cdn.jsdelivr.net/npm/handlebars@4.7.7/dist/handlebars.min.js"></script>
  <script type="text/javascript" charset="utf8" src="https://cdn.datatables.net/1.11.5/js/jquery.dataTables.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js"></script>
  
</head>
  <nav class="navbar fixed-top navbar-expand-lg navbar-dark" style="background-color: #7a51d2;">
    <div class="container-fluid">
      <!-- Logo and Course Craft -->
      <div class="d-flex align-items-center justify-content-between">
        <a class="navbar-brand d-flex align-items-center" href="#">
          <i class="bi bi-mortarboard-fill"></i>
          <p class="fst-italic mb-0 ms-2">CourseCraft</p>
          <cfif url.keyExists("courseCatalog")>
            <i class="bi bi-list toggle-sidebar-btn"></i>
          </cfif>
          <cfif session.isLoggedIn && session.role =='Admin'>
          <i class="bi bi-list toggle-sidebar-btn"></i>
        </cfif>
        </a>
    </div>
      <!-- Toggle button for mobile -->
      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
  
      <!-- Search form -->
      <!--- <form class="d-flex mx-auto">
        <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
        
      </form>
   --->
      <!-- Navbar links -->
      <cfif NOT session.isLoggedIn>
      <div class="collapse navbar-collapse" id="navbarSupportedContent">
        <ul class="navbar-nav me-auto mb-2 mb-lg-0">
          <li class="nav-item">
            <a class="nav-link active" aria-current="page" href="./index.cfm?action=home">Home</a>
          </li>
        </ul>
  
        <!-- Login/Signup buttons -->
        <div class="d-flex">
            <ul class="navbar-nav">   
              <li class="nav-item" id="loginLink" style="">
                <button type="button" class="btn btn-light me-2"><a href=./index.cfm?action=login style="text-decoration:none; color:black;">Login</a></button>
              </li>
              <li class="nav-item" id="signupLink" style="">
                <button type="button" class="btn btn-dark me-2"><a href=./index.cfm?action=register style="text-decoration:none; color:white;">Sign Up</a></button>
              </li>
            <cfelse>
             
              <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                <div class="profile-image">
                <cfif session.profileImage != ''>
                  <img src="<cfoutput>#session.profileImage#</cfoutput>" alt="Profile" class="rounded-circle me-2">
                <cfelse>  
                  <img src="./assets/img/person-circle.png" alt="Profile" class="rounded-circle me-2">
                </cfif>
                </div>
           
                <span class="d-none d-md-block dropdown-toggle ps-2" style="color:white;"><cfoutput>#session.userName#</cfoutput></span>
              </a><!-- End Profile Iamge Icon -->
           
                <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                  <li class="dropdown-header">
                    <h6><cfoutput>#session.userName#</cfoutput></h6>
                  </li>
                  <li>
                    <hr class="dropdown-divider">
                  </li>
      
                  <li>
                    <a class="dropdown-item d-flex align-items-center" href="./index.cfm?action=profile">
                      <i class="bi bi-person"></i>
                      <span>My Profile</span>
                    </a>
                  </li>
                  <li>
                    <hr class="dropdown-divider">
                  </li>
                  <li>
                    <a class="dropdown-item d-flex align-items-center" href="./index.cfm?action=dashboard">
                      <i class="bi bi-person"></i>
                      <span>My Dashboard</span>
                    </a>
                  </li>
                  <li>
                    <hr class="dropdown-divider">
                  </li>
                  <li>
                    <a class="dropdown-item d-flex align-items-center" id="logoutLink">
                      <i class="bi bi-box-arrow-right"></i>
                      <span>Log Out</span>
                    </a>
                  </li>
                </ul><!-- End Profile Dropdown Items -->
            </ul>
          </cfif>
        </div>
      </div>
    </div>
  </nav>
