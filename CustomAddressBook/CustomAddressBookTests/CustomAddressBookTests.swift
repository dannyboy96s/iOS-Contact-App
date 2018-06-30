//
//  CustomAddressBookTests.swift
//  CustomAddressBookTests


import XCTest
@testable import CustomAddressBook

class CustomAddressBookTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testPersonValidation() {
        let p = Person(firstName: "Aurel")
        XCTAssert(p != nil)
        do {
            try p?.setLastName("Dutu")
            try p?.setEmail("aurel@protv.ro")
            try p?.setPhone("6044207213")
            try p?.setAddress("1 C Ln, Shreveport, LA")
        } catch {
            XCTFail("Validation failed")
        }
    }
    
    func testPseronValidationFailures() {
        let p = Person(firstName: "Aurel")
        XCTAssert(p != nil)
        do {
            try p?.setEmail("J")
             XCTFail("email validation failed")
        } catch {
           
        }
        do {
            try p?.setPhone("J")
            XCTFail("phone validation failed")
        } catch {
            
        }
        do {
            try p?.setAddress("J")
            XCTFail("address validation failed")
        } catch {
            
        }
        do {
            try p?.setFirstName("")
            XCTFail("firstName validation failed")
        } catch {
            
        }
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
