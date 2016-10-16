
//
//  AlertProvider.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//


import UIKit

protocol AlertProvider {
    /// Present Alert for error from viewController parameter.
    func present(_ error: Error, from viewController: UIViewController)
}

class AlertService: AlertProvider {
    static let sharedInstance = AlertService()
    fileprivate init() {}  // Enforce singleton; prevent others from instantiating instances.
    
    func present(_ error: Error, from viewController: UIViewController) {
        let error = error as NSError
        
        let alertController = UIAlertController(
            title: "COULD NOT COMPUTE",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "Ok???", style: .default) { (alertAction) in
            print("do I need to dismiss?")
        }
        
        alertController.addAction(okAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
