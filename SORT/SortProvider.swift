
//
//  SortProvider.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//


import CoreLocation

/// Define protocol (interface) for providing SORTs to application.
protocol SORTProvider {
    /// Asynchonously fetch SORTs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
    func fetchSORTs(queue: OperationQueue, completion: @escaping (Result<SORT>)->())
}

/// Singleton instance of this class is used as default SORTProvider in ViewControllers, etc.
class SORTService: SORTProvider {
    /// Asynchonously fetch SORTs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
    //internal func fetchSORTs(queue: OperationQueue, completion: (Result<SORT>) -> ()) {
       
    //}

    /// Asynchonously fetch SORTs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
//   internal func fetchSORTs(queue: OperationQueue, completion: (Result<SORT>) -> ()) {
//    }

    /// Asynchonously fetch SORTs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
//    internal func fetchSORTs(queue: OperationQueue, completion: (Result<SORT>) -> ()) {
//  
//    }

    static let sharedInstance = SORTService()
    fileprivate init() {} // Enforces Singleton. No other object can instantiate instances.
    
    /// Asynchonously fetch SORTs from disk or network which can take multiple seconds to complete.
    /// Completion handler executes on provided queue.
    internal func fetchSORTs(queue: OperationQueue, completion: @escaping (Result<SORT>)->()) {
        
        // Simulate network or disk I/O lag, then return results via completion handler.
        delay(inSeconds: 1) {
            let SORTs = SeedData.makeSORTs()
            let result = Result.success(SORTs)
            queue.addOperation { completion(result) }        }
    }
}
