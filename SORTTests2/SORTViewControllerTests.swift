
//
//  SORTViewControllerTests.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//


import XCTest
@testable import SORT

class SORTViewControllerTests: XCTestCase {
    
    // MARK: - Stored Properties
    
    var SORTViewController: SORTViewController!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Load SORTViewController from Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        SORTViewController = storyboard.instantiateInitialViewController() as! SORTViewController
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testControllerIsLoadedForTesting() {
        XCTAssertNotNil(SORTViewController)
    }
    
    func testSORTsAreLoadedFromSORTProviderOnViewDidLoad() {
        let expected = SeedData.makeSORTs()
        
        // Create and assign mock SORTProvider.
        struct MockSORTProvider: SORTProvider {
            var SORTs: [SORT]
            
            func fetchSORTs(queue: OperationQueue, completion: (Result<SORT>) -> ()) {
                let result = Result.success(SORTs)
                queue.addOperation { completion(result) }
            }
        }
        
        let mockSORTProvider = MockSORTProvider(SORTs: expected)
        SORTViewController.SORTProvider = mockSORTProvider
        
        // We need an test expectation because the load happens asynchronously... which makes me feel like maybe I shouldn't be testing this in the first place. Oh well, this is just a demo!
        let expectation = self.expectation(description: "testSORTsAreLoadedFromSORTProviderOnViewDidLoad")
        
        // Trigger viewDidLoad()
        let _ = SORTViewController.view
        
        // Delay Assertion to allow async fetch to complete, should only take 1 tick of the run loop; which is why a delay of 0.0 works.
        delay(inSeconds: 1.0) {
            // Assertions
            XCTAssertEqual(expected, self.SORTViewController.SORTs)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    
    func testAlertControllerIsPresentedOnError() {
        let expectedError = SORT.Error.unitTest
        
        // Create and assign MockSORTProvider.
        struct MockSORTProvider: SORTProvider {
            var error: SORT.Error
            
            func fetchSORTs(queue: OperationQueue, completion: (Result<SORT>) -> ()) {
                let result = Result<SORT>.failure(error)
                queue.addOperation { completion(result) }
            }
        }
        
        let mockSORTProvider = MockSORTProvider(error: expectedError)
        SORTViewController.SORTProvider = mockSORTProvider
        
        
        // Create and assign MockAlertProvider.
        class MockAlertProvider: AlertProvider {
            var errorPresented: Error?
            var viewControllerToPresentFrom: UIViewController?
            
            func present(_ error: Error, from viewController: UIViewController) {
                errorPresented = error
                viewControllerToPresentFrom = viewController
            }
        }
        
        let mockAlertProvider = MockAlertProvider()
        SORTViewController.alertProvider = mockAlertProvider
        
        // Expectation required because loading happend asynchronously.
        let expectation = self.expectation(description: "testAlertControllerIsPresentedOnError")
        
        // Trigger viewDidLoad()
        let _ = SORTViewController.view
        
        // Delay Assertion to allow async fetch to complete, should only take 1 tick of the run loop; which is why a delay of 0.0 works.
        delay(inSeconds: 1.0) {
            
            // Defer blocks are run as soon as execution exits this scope.
            defer { expectation.fulfill() }
            
            // Assertions
            XCTAssertNotNil(mockAlertProvider.errorPresented)
            
            guard let actualError = mockAlertProvider.errorPresented as? SORT.Error else {
                XCTFail("ErrorPresented should have been instance of Error.")
                return
            }
            
            XCTAssertEqual(expectedError, actualError)
            
            XCTAssertNotNil(mockAlertProvider.viewControllerToPresentFrom)
            
            guard let actualViewController = mockAlertProvider.viewControllerToPresentFrom else {
                XCTFail("viewControllerToPresentFrom should have been valid instance.")
                return
            }
            
            XCTAssertEqual(self.SORTViewController, actualViewController)
        }
        
        waitForExpectations(timeout: 3, handler: nil)
    }
}
