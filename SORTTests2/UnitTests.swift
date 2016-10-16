//
//  UnitTests.swift
//  SORT
//
//  Created by Nolan McQueen on 10/15/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//

import XCTest
import CoreLocation
@testable import SORT

class UnitTests: XCTestCase {
    
    // MARK: - Stored Properties
    
    // Set default values in setUp()
    var SORTs: [SORT]!
    var location: CLLocation!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        SORTs = SeedData.makeSORTs()
        location = SeedData.makeLocation()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Unit Tests
    
    func testSORTsCanBeOrderedByPromixityToLocation() {
        // Input values are being set in setUp().
        
        // Expected
        let expected = [
            SeedData.makeAngelsSORT(),
            SeedData.makeBiffsSORT(),
            SeedData.makeErnestsSORT(),
            SeedData.makeDarlenesSORT(),
            SeedData.makeCathysSORT()
        ]
        
        // Actual
        let actual = SORTs.ordered(byProximityTo: location)
        
        // Assertions
        XCTAssertNotEqual(SORTs, actual) // Make sure the input doesn't pass the test.
        XCTAssertEqual(expected, actual)
    }
    
    func testSORTsOrderedByShortestRouteFromLocation() {
        // Input values are being set in setUp().
        
        // Expected
        let expected = [
            SeedData.makeDarlenesSORT(),
            SeedData.makeErnestsSORT(),
            SeedData.makeAngelsSORT(),
            SeedData.makeBiffsSORT(),
            SeedData.makeCathysSORT()
        ]
        
        // Actual
        let actual = SORTs.ordered(byShortestRouteToEachSORTStartingFrom: location)
        
        // Assertions
        XCTAssertNotEqual(SORTs, actual) // Make sure the input doesn't pass the test.
        XCTAssertEqual(expected, actual)
    }
    
    // MARK: - Performance Tests
    
    func testPerformanceOfOrderByShortestRoute() {
        let randomSORTs = SeedData.makeRandomSORTs(count: 5)
        
        self.measure {
            // Put the code you want to measure the time of here.
            randomSORTs.ordered(byShortestRouteToEachSORTStartingFrom: self.location)
        }
    }
    
    func testPerformanceOfOrderByNearestNeighbour() {
        let randomSORTs = SeedData.makeRandomSORTs(count: 100)
        
        self.measure {
            // Put the code you want to measure the time of here.
            randomSORTs.ordered(byNearestNeighbourStartingFrom: self.location)
        }
    }
    
    // MARK: - Async Tests
    
    func testAsyncOrderByShortestRoute() {
        // Input values are being set in setUp().
        
        // Expected result
        let expected = [
            SeedData.makeDarlenesSORT(),
            SeedData.makeErnestsSORT(),
            SeedData.makeAngelsSORT(),
            SeedData.makeBiffsSORT(),
            SeedData.makeCathysSORT()
        ]
        
        // Create an XCTestExpectation in order to run test asynchronously.
        let expectation = self.expectation(description: "Execute completion closure.")
        
        // Perform Async operation.
        SORTs.ordered(byShortestRouteToEachSORTStartingFrom: location, queue: .main()) { (result) in
            switch result {
            case .failure: XCTFail("Expected success")
            case .success(let actual):
                // Assertions
                XCTAssertNotEqual(self.SORTs, actual) // Make sure initial values would not pass the test.
                XCTAssertEqual(expected, actual)
            }
            
            // Fulfill the expectation in order to signal the tests are complete.
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
}
}
