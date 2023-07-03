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


        XCTAssertTrue(emailTextField.exists)
        XCTAssertTrue(passwordTextField.exists)

        XCTAssertTrue(loginButton.exists)

        // When
        emailTextField.tap()
        emailTextField.typeText("tak@rak.gr")

        passwordTextField.tap()
        passwordTextField.typeText("123456")




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
    
    
    


}

//let app = XCUIApplication()
//let button = app.navigationBars["Ntosetta"].children(matching: .other).element(boundBy: 1).children(matching: .other).element.children(matching: .button).element
//button.tap()
//
//let emailTextField = app.textFields["Email"]
//
//


