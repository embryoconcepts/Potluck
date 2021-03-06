//
//  MHPFirestoreParserTests.swift
//  PotluckTests
//
//  Created by Jennifer Hamilton on 5/31/18.
//  Copyright © 2018 Many Hands Apps. All rights reserved.
//

import XCTest
@testable import Potluck
import Firebase

class MHPFirestoreParserTests: XCTestCase {
    let parser = MHPFirestoreParser()
    
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
    
    
    // MARK: - encodeUser(firUser: User, mhpUser: MHPUser?, firstName: String?, lastName: String?, state: UserAuthorizationState) -> [String: Any]
    
    func testBuildDataSet_shouldSucceedForAnonUser() {
        // Arrange
        let expected = ["userState": "anonymous"]
        
        // Act
        let result = parser.buildUserDataSet(firemail: nil, mhpUser: nil, firstName: nil, lastName: nil, state: .anonymous) as! [String: String]
        
        // Assert
        XCTAssertEqual(expected, result, "Building a data set for an anonymous user should succeed.")
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithMHPEmail() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.email = "hlamarr@electronicmail.com"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "email": "hlamarr@electronicmail.com",
            "userState": "unverified"
        ]
        
        // Act
        let result: [String: Any] = parser.buildUserDataSet(firemail: firUserEmail,
                                                             mhpUser: mhpUser,
                                                             firstName: nil,
                                                             lastName: nil,
                                                             state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["email"] as! String, result["email"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithNoMHPEmail() {
        // Arrange
        let mhpUser = MHPUser()
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "email": "hlamarr@electronicmail.com",
            "userState": "unverified"
            ]
        
        // Act
        let result: [String: Any] = parser.buildUserDataSet(firemail: firUserEmail,
                                                              mhpUser: mhpUser,
                                                              firstName: nil,
                                                              lastName: nil,
                                                              state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["email"] as! String, result["email"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForUnverifiedUserWithDifferentEmails() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.email = "hedy@electronicmail.com"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "email": "hedy@electronicmail.com",
            "userState": "unverified"
        ]
        
        // Act
        let result: [String: Any] = parser.buildUserDataSet(firemail: firUserEmail,
                                                             mhpUser: mhpUser,
                                                             firstName: nil,
                                                             lastName: nil,
                                                             state: .unverified)
        
        // Assert
        XCTAssertEqual(expected["email"] as! String, result["email"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForVerifiedUser() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.email = "hlamarr@electronicmail.com"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "email": "hlamarr@electronicmail.com",
            "userState": "verified"
        ]
        
        // Act
        let result: [String: Any] = parser.buildUserDataSet(firemail: firUserEmail,
                                                        mhpUser: mhpUser,
                                                        firstName: nil,
                                                        lastName: nil,
                                                        state: .verified)
        
        // Assert
        XCTAssertEqual(expected["email"] as! String, result["email"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
    
    func testBuildDataSet_shouldSucceedForRegisteredUser() {
        // Arrange
        var mhpUser = MHPUser()
        mhpUser.email = "hlamarr@electronicmail.com"
        mhpUser.firstName = "Hedy"
        mhpUser.lastName = "Lamarr"
        
        let firUserEmail = "hlamarr@electronicmail.com"
        let expected: [String: Any] = [
            "firstName": "Hedy",
            "lastName": "Lamarr",
            "email": "hlamarr@electronicmail.com",
            "userState": "registered"
        ]
        
        // Act
        let result: [String: Any] = parser.buildUserDataSet(firemail: firUserEmail,
                                                        mhpUser: mhpUser,
                                                        firstName: nil,
                                                        lastName: nil,
                                                        state: .registered)
        
        // Assert
        XCTAssertEqual(expected["firstName"] as! String, result["firstName"] as! String)
        XCTAssertEqual(expected["lastName"] as! String, result["lastName"] as! String)
        XCTAssertEqual(expected["email"] as! String, result["email"] as! String)
        XCTAssertEqual(expected["userState"] as! String, result["userState"] as! String)
    }
        
    
    // MARK: - func parseResponseToUser(document: DocumentSnapshot, data: [String: Any]) -> MHPUser?
    
    func testParseResponseToUser_shouldSucceedForUnverifiedUser() {
        // Arrange
        // TODO: set up Mock Firestore db
        
        // Act
        
        
        // Assert
        
        
    }
    

    /*
     parseResponseToUser:
     unverified
     verified
     registered
     invalid data
     */
    
}
