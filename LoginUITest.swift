//
//  LoginUITest.swift
//  NtosettaUnitTests
//
//  Created by Pantos, Thomas on 15/6/23.
//

import XCTest

@testable import Ntosetta
 class LoginViewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLoginFlow() {
        // Perform UI actions and assertions for the login flow
        let emailTextField = app.textFields["Email"]
        let passwordTextField = app.secureTextFields["Password"]
        let loginButton = app.buttons["Login"]

        // Enter valid email and password
        emailTextField.tap()
        emailTextField.typeText("test@example.com")
        passwordTextField.tap()
        passwordTextField.typeText("password")
        loginButton.tap()

        // Add assertions for successful login flow

        // Example assertion:
        XCTAssertTrue(app.navigationBars["Home"].exists)
    }

    func testForgotPasswordFlow() {
        // Perform UI actions and assertions for the forgot password flow
        let forgotPasswordButton = app.buttons["Forgot Password?"]

        forgotPasswordButton.tap()

        // Add assertions for forgot password flow

        // Example assertion:
        XCTAssertTrue(app.navigationBars["Forgot Password"].exists)
    }

    func testRegistrationFlow() {
        // Perform UI actions and assertions for the registration flow
        let registerButton = app.buttons["Register"]

        registerButton.tap()

        // Add assertions for registration flow

        // Example assertion:
        XCTAssertTrue(app.navigationBars["Register"].exists)
    }
}
