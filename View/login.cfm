<main>
<div class="container">
   
    <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">
            <div class="card mb-3 mt-5">

              <div class="card-body">

                <div class="pt-4 pb-2">
                  <h5 class="card-title text-center pb-0 fs-4">Login to Your Account</h5>
                  <p class="text-center small">Enter your username & password to login</p>
                  <div id="messageDiv" class="alert" style="display:none;"></div>
                </div>

                <form class="row g-3" novalidate>

                  <div class="col-12">
                    <label for="yourEmail" class="form-label">Email Address</label>
                    <div class="input-group has-validation">
                      <span class="input-group-text" id="inputGroupPrepend">@</span>
                      <input type="text" name="email" class="form-control" id="yourEmail" required>
                      <div class="invalid-feedback">Please enter your emailAddress.</div>
                    </div>
                  </div>

                  <div class="col-12">
                    <label for="yourPassword" class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" id="yourPassword" required>
                    <div class="invalid-feedback">Please enter your password!</div>
                  </div>
                  <p class="small mb-0">Forgot Password? <a href="./index.cfm?action=forgotpassword">Please Click here</a></p>
                  <div class="col-12">
                    <button id="submitBtnLogin" class="btn btn-primary w-100" style="background-color:#7a51d2;">Login</button>
                  </div>
                  <div class="col-12">
                    <p class="small mb-0">Don't have account? <a href="">Create an account</a></p>
                  </div>
                </form>

              </div>
            </div>

          </div>
        </div>
      </div>

    </section>

  </div>
</main>

