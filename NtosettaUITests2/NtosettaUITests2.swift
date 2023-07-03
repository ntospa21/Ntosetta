import XCTest

class LoginViewUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false        
        app.launch()
        
    }
    
    
    func testLoginButtonTapped() {
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.secureTextFields["Password"]
        let loginButton = app.buttons["Login"]
        let tabBar = app.tabBars["Tab Bar"]
        let profileButton = tabBar.buttons["Profile"]
        let homeTabButton = tabBar.buttons["Home"]
        let first = app.collectionViews.firstMatch
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        
        XCTAssertTrue(loginButton.exists)
        
        
        // When
        emailTextField.tap()
        emailTextField.typeText("tak@rak.gr")
        
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        
        
        loginButton.tap()
        
        
        XCTAssertTrue(tabBar.waitForExistence(timeout: 10))
        
        profileButton.tap()
        homeTabButton.tap()
        first.tap()
        
        
        
   
       
        
        
        
    }
    
    func testLoginButtonTappedWrongly() {
        
        let errorAlert = app.alerts["Error"]
        
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.secureTextFields["Password"]
        let loginButton = app.buttons["Login"]
        let okButton = errorAlert.scrollViews.otherElements.buttons["OK"]
        
        
        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)
        
        XCTAssertTrue(loginButton.exists)
        
        // When
        emailTextField.tap()
        emailTextField.typeText("example@rak.gr")
        
        passwordTextField.tap()
        passwordTextField.typeText("123456")
        
        loginButton.tap()
        
        okButton.tap()
        
        
        
        
    }
    
    func testForgotButton() throws {
        let forgotBtn = app.buttons["Forgot Password?"]
        let forgotTxtFld = app.textFields["EmailFgt"]
        let senderBtn = app.buttons["SendPasswordReset"]
        
        
        XCTAssertTrue(forgotBtn.exists)
        
        
        forgotBtn.tap()
        
        XCTAssertTrue(forgotTxtFld.exists)
        
        forgotTxtFld.tap()
        forgotTxtFld.typeText("tommyaek@gmail.com")
        
        senderBtn.tap()
        
        
        
    }
    
    
    func testRegisterBtn() throws {
        
        let registerBtn = app.buttons["Register"]
        let emailTextFieldRegister = app.textFields["TextFieldRegister"]
        let passwordSecureTextFieldRegister = app.secureTextFields["PassReg"]
        let firstNameTextFieldRegister = app.textFields["FirstName"]
        let lastNameTextFieldRegister = app.textFields["LastName"]
        let registerSenderBtn = app.buttons["FinalRegister"]
        
        XCTAssertTrue(registerBtn.exists)
        
        registerBtn.tap()
        
        XCTAssertTrue(emailTextFieldRegister.exists)
        XCTAssertTrue(passwordSecureTextFieldRegister.exists)
        XCTAssertTrue(firstNameTextFieldRegister.exists)
        XCTAssertTrue(lastNameTextFieldRegister.exists)
        XCTAssertTrue(registerSenderBtn.exists)
        
        emailTextFieldRegister.tap()
        emailTextFieldRegister.typeText("tommyaek@gmail.com")

        passwordSecureTextFieldRegister.tap()
        passwordSecureTextFieldRegister.typeText("123456")
        
        firstNameTextFieldRegister.tap()
        firstNameTextFieldRegister.typeText("Thomas")
        
        lastNameTextFieldRegister.tap()
        lastNameTextFieldRegister.typeText("Pantos")
        
        registerSenderBtn.tap()
        
    }
    
    
}
