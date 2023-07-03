//
//  MainMenuUITest.swift
//  NtosettaUITests2
//
//  Created by Pantos, Thomas on 17/6/23.
//

import XCTest

 class MainMenuUITest: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false        
        app.launch()
        
    }
    
    
    
     func testArticles() throws {
         
         let emailTextField = app.textFields["Email"]
         let passwordTextField = app.secureTextFields["Password"]
         let loginButton = app.buttons["Login"]
         let tabBar = app.tabBars["Tab Bar"]
         let profileButton = tabBar.buttons["Profile"]
         let homeTabButton = tabBar.buttons["Home"]
         let first = app.collectionViews.firstMatch
         let backButton = app.navigationBars.buttons.element(boundBy: 0)
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
         
         XCTAssertTrue(backButton.waitForExistence(timeout: 3))
         backButton.tap()
         
       
         
         
         
         
         
     }
}
