    <head>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    </head>
    <nav class="navbar fixed-top navbar-expand-lg navbar-dark" style="background-color: #7a51d2;">
      <div class="container-fluid">
        <!-- Logo and Course Craft -->
        <a class="navbar-brand d-flex align-items-center" href="#">
          <i class="bi bi-mortarboard-fill"></i>
          <p class="fst-italic mb-0 ms-2">CourseCraft</p>
        </a>
    
        <!-- Toggle button for mobile -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
    
        <!-- Search form -->
        <form class="d-flex mx-auto">
          <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
          
        </form>
    
        <!-- Navbar links -->
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mb-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link active" aria-current="page" href="#">Home</a>
            </li>
            <li class="nav-item dropdown">
              <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                Categories
              </a>
              <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                <li><a class="dropdown-item" href="#">Development</a></li>
                <li><a class="dropdown-item" href="#">Business</a></li>
                <li><a class="dropdown-item" href="#">Design</a></li>
                <li><a class="dropdown-item" href="#">IT & Software</a></li>
                <li><a class="dropdown-item" href="#">Personal Development</a></li>
              </ul>
            </li>
          
            <li class="nav-item">
              <a class="nav-link" href="#">Reviews</a>
            </li>
          </ul>
    
          <!-- Login/Signup buttons -->
          <div class="d-flex">
           
              <ul class="navbar-nav">
                <li class="nav-item" id="profileLink" style="display: none;">
                  <a class="nav-link nav-profile d-flex align-items-center pe-0" href="#" data-bs-toggle="dropdown">
                    <i class="bi bi-person-circle"></i>
                    <span class="d-none d-md-block dropdown-toggle ps-2">Admin</span>
                  </a><!-- End Profile Iamge Icon -->
        
                  <ul class="dropdown-menu dropdown-menu-end dropdown-menu-arrow profile">
                    <li class="dropdown-header">
                      <h6>Admin</h6>
                    </li>
                    <li>
                      <hr class="dropdown-divider">
                    </li>
        
                    <li>
                      <a class="dropdown-item d-flex align-items-center" href="users-profile.html">
                        <i class="bi bi-person"></i>
                        <span>My Profile</span>
                      </a>
                    </li>
                    <li>
                      <hr class="dropdown-divider">
                    </li>
        
                   
                   
                  
        
                    <li>
                      <a class="dropdown-item d-flex align-items-center" href="#">
                        <i class="bi bi-box-arrow-right"></i>
                        <span>Log Out</span>
                      </a>
                    </li>
        
                  </ul><!-- End Profile Dropdown Items -->
                </li>
                <li class="nav-item" id="loginLink" style="display: none;">
                  <button type="button" class="btn btn-light me-2">Login</button>
                </li>
                <li class="nav-item" id="signupLink" style="display: none;">
                  <button type="button" class="btn btn-dark me-2">Sign Up</button>
                </li>
              </ul>
        
           
          </div>
        </div>
      </div>
    </nav>
    
    <!-- Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.8/dist/umd/popper.min.js" integrity="sha384-I7E8VVD/ismYTF4hNIPjVp/Zjvgyol6VFvRkX/vR+Vc4jQkC+hVqc2pM8ODewa9r" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.min.js" integrity="sha384-0pUGZvbkm6XF6gxjEnlmuGrJXVbNuzT9qBBavbLwCsOGabYfZo0T0to5eqruptLy" crossorigin="anonymous"></script>
    <footer class="w-100 py-4 flex-shrink-0 bg-dark" id="footer1"  style="display: none;">
        <div class="container py-4" >
            <div class="row gy-4 gx-6">
                <div class="col-lg-2 col-md-6">
                    <ul class="list-unstyled text-muted">
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">CourseCraft Business</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">About us</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Contact Us</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Get the app</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <ul class="list-unstyled text-muted">
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Careers</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Blog</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Help and Support</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Affiliate</a></li>
                    </ul>
                </div>
                <div class="col-lg-2 col-md-6">
                    <ul class="list-unstyled text-muted">
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Terms</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Privacy Policy</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Cookie Settings</a></li>
                        <li><a href="#" class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover">Accessibility Settings</a></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="container py-4 d-flex justify-content-between align-items-center">
            <div class="text-white">
            <a class="navbar-brand d-flex align-items-center" href="#">
                <i class="bi bi-mortarboard-fill"></i>
                <p class="fst-italic mb-0 ms-2">CourseCraft</p>
            </a>
            </div>
            <!-- Right section for copyright and links -->
            <div>
            <p class="small text-white mb-0 text-end">&copy; Copyrights. All rights reserved. <a class="link-light link-underline link-underline-opacity-0 link-underline-opacity-100-hover" href="#" >CourseCraft.com</a></p>
            </div>
        </div>
    </footer>
    <footer id="footer" class="footer" style="display: none;">
        <div class="copyright">
            &copy; Copyright <strong><span>CourseCraft</span></strong>. All Rights Reserved
        </div>
    </footer>