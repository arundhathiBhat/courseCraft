<main>
  <div class="container">
    <section class="section register min-vh-100 d-flex flex-column align-items-center justify-content-center py-4">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-4 col-md-6 d-flex flex-column align-items-center justify-content-center">
            <div class="card mb-3 mt-5">
              <div class="card-body">
                <div class="pt-4 pb-2">
                  <h5 class="card-title text-center pb-0 fs-4">Create an Account</h5>
                  <p class="text-center small">Enter your personal details to create account</p>
                  <div id="messageDiv" class="alert"></div>
                </div>
                <form class="row g-3" novalidate>
                  <div class="col-12">
                    <label for="yourName" class="form-label">Full Name</label>
                    <input type="text" name="name" class="form-control" id="yourName" required>
                    <div class="invalid-feedback">Please enter your name!</div>
                  </div>
                  <div class="col-12">
                    <label for="yourEmail" class="form-label">Email Address</label>
                    <div class="input-group has-validation">
                      <span class="input-group-text" id="inputGroupPrepend">@</span>
                      <input type="email" name="email" class="form-control" id="yourEmail" required>
                      <div class="invalid-feedback">Please enter a email address!</div>
                    </div>
                  </div>
                  <div class="col-12">
                    <label for="yourPhoneNumber" class="form-label">Phone Number</label>
                    <div class="input-group has-validation">
                      <input type="tel" name="phoneNumber" class="form-control" id="yourPhoneNumber" required>
                      <div class="invalid-feedback">Please enter Phone Number</div>
                    </div>
                  </div>
                  <div class="col-12">
                    <label for="yourUsername" class="form-label">Username</label>
                    <input type="text" name="username" class="form-control" id="yourUserName" required>
                    <div class="invalid-feedback">Please choose a username.</div>
                  </div>
                  <div class="col-12">
                    <label for="yourPassword" class="form-label">Password</label>
                    <input type="password" name="password" class="form-control" id="yourPassword" required>
                    <div class="invalid-feedback">Please Enter password!</div>
                  </div>
                  <div class="col-12">
                    <label for="confirmPassword" class="form-label">Confirm Password</label>
                    <input type="password" name="confirmPassword" class="form-control" id="confirmPassword" required>
                    <div class="invalid-feedback">Confirm your password</div>
                  </div>
                  <div class="col-12">
                    <div class="form-check">
                      <input class="form-check-input" name="terms" type="checkbox" id="acceptTerms">
                      <label class="form-check-label" for="acceptTerms">I agree and accept the <a href="">terms and conditions</a></label>
                      <div class="invalid-feedback">You must agree before submitting.</div>
                    </div>
                  </div>
                  <div class="col-12">
                    <button id="submitBtn" class="btn btn-primary w-100">Create Account</button>
                  </div>
                  <div class="col-12">
                    <p class="small mb-0">Already have an account? <a href="./index.cfm?action=login">Log in</a></p>
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