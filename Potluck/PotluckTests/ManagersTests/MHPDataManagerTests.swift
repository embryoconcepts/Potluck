//
//  MHPDataManagerTests.swift
//  PotluckTests
//
//  Created by Jennifer Hamilton on 5/31/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import XCTest
@testable import Potluck
import Firebase

class MHPDataManagerTests: XCTestCase {
    let dataManager = MHPDataManager()
    
    // Class Level - before/after all tests
    override class func setUp() {
        super.setUp()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    // Instance Level - before/after each test
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    
    // MARK: - buildDataSet(firUser: User, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any]
    
    func testBuildDataSet_shouldSucceedForAnonUser() {
        // Arrange
        let expected = ["userState": "anonymous"]
        
        // Act
        let result = dataManager.buildDataSet(firUserEmail: nil, mhpUser: nil, firstName: nil, lastName: nil, state: .anonymous) as! [String: String]
        
        // Assert
        XCTAssertEqual(expected, result, "Building a data set for an anonymous user should succeed.")
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithMHPEmail() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.userEmail = "hlamarr@electronicmail.com"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "facebookPermissions": false,
            "locationPermissions": false,
            "notificationPermissions": false,
            "notificationPreferences": false,
            "userEmail": "hlamarr@electronicmail.com",
            "userEventListID": "",
            "userFacebookID": "",
            "userFirstName": "",
            "userLastName": "",
            "userProfileURL": "",
            "userState": "unverified"
        ]
        
        // Act
        let result: [String: Any] = dataManager.buildDataSet(firUserEmail: firUserEmail,
                                                             mhpUser: mhpUser,
                                                             firstName: nil,
                                                             lastName: nil,
                                                             state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["facebookPermissions"] as! Bool, result["facebookPermissions"] as! Bool)
        XCTAssertEqual(expected["locationPermissions"] as! Bool, result["locationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPermissions"] as! Bool, result["notificationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPreferences"] as! Bool, result["notificationPreferences"] as! Bool)
        XCTAssertEqual(expected["userEmail"] as! String, result["userEmail"] as! String)
        XCTAssertEqual(expected["userEventListID"] as! String, result["userEventListID"] as! String)
        XCTAssertEqual(expected["userFacebookID"] as! String, result["userFacebookID"] as! String)
        XCTAssertEqual(expected["userFirstName"] as! String, result["userFirstName"] as! String)
        XCTAssertEqual(expected["userLastName"] as! String, result["userLastName"] as! String)
        XCTAssertEqual(expected["userProfileURL"] as! String, result["userProfileURL"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithNoMHPEmail() {
        // Arrange
        let mhpUser = MHPUser()
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "facebookPermissions": false,
            "locationPermissions": false,
            "notificationPermissions": false,
            "notificationPreferences": false,
            "userEmail": "hlamarr@electronicmail.com",
            "userEventListID": "",
            "userFacebookID": "",
            "userFirstName": "",
            "userLastName": "",
            "userProfileURL": "",
            "userState": "unverified"
            ]
        
        // Act
        let result: [String: Any] = dataManager.buildDataSet(firUserEmail: firUserEmail,
                                                              mhpUser: mhpUser,
                                                              firstName: nil,
                                                              lastName: nil,
                                                              state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["facebookPermissions"] as! Bool, result["facebookPermissions"] as! Bool)
        XCTAssertEqual(expected["locationPermissions"] as! Bool, result["locationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPermissions"] as! Bool, result["notificationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPreferences"] as! Bool, result["notificationPreferences"] as! Bool)
        XCTAssertEqual(expected["userEmail"] as! String, result["userEmail"] as! String)
        XCTAssertEqual(expected["userEventListID"] as! String, result["userEventListID"] as! String)
        XCTAssertEqual(expected["userFacebookID"] as! String, result["userFacebookID"] as! String)
        XCTAssertEqual(expected["userFirstName"] as! String, result["userFirstName"] as! String)
        XCTAssertEqual(expected["userLastName"] as! String, result["userLastName"] as! String)
        XCTAssertEqual(expected["userProfileURL"] as! String, result["userProfileURL"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithDifferentEmails() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.userEmail = "hedy@electronicmail.com"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "facebookPermissions": false,
            "locationPermissions": false,
            "notificationPermissions": false,
            "notificationPreferences": false,
            "userEmail": "hedy@electronicmail.com",
            "userEventListID": "",
            "userFacebookID": "",
            "userFirstName": "",
            "userLastName": "",
            "userProfileURL": "",
            "userState": "unverified"
        ]
        
        // Act
        let result: [String: Any] = dataManager.buildDataSet(firUserEmail: firUserEmail,
                                                             mhpUser: mhpUser,
                                                             firstName: nil,
                                                             lastName: nil,
                                                             state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["facebookPermissions"] as! Bool, result["facebookPermissions"] as! Bool)
        XCTAssertEqual(expected["locationPermissions"] as! Bool, result["locationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPermissions"] as! Bool, result["notificationPermissions"] as! Bool)
        XCTAssertEqual(expected["notificationPreferences"] as! Bool, result["notificationPreferences"] as! Bool)
        XCTAssertEqual(expected["userEmail"] as! String, result["userEmail"] as! String)
        XCTAssertEqual(expected["userEventListID"] as! String, result["userEventListID"] as! String)
        XCTAssertEqual(expected["userFacebookID"] as! String, result["userFacebookID"] as! String)
        XCTAssertEqual(expected["userFirstName"] as! String, result["userFirstName"] as! String)
        XCTAssertEqual(expected["userLastName"] as! String, result["userLastName"] as! String)
        XCTAssertEqual(expected["userProfileURL"] as! String, result["userProfileURL"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    
    /*
     test successes and fails:
     
     anon
     unverified
     verified
     registered
     updating registered
     invalid info
     firUser email and mhpUser email conflict?
     
     */
    
}
