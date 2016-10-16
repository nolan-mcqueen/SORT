
//
//  DelegationVC.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//


import UIKit
import MapKit

protocol DelegationVCDelegate {
    func delegationVCDidCancel(_ delegationVC: DelegationVC)
    func delegationVCDidSave(_ delegationVC: DelegationVC)
}

class DelegationVC: UIViewController, MKMapViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subtitleTextField: UITextField!
    @IBOutlet var coordinateLabel: UILabel!
    
    // MARK: - Properties
    
    var SORT: SORT!
    var delegate: DelegationVCDelegate!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        validateDependencies()
        configureMapView()
        setLabels()
    }
    
    // MARK: - Helpers
    
    func validateDependencies() {
        guard SORT != nil else {
            fatalError("\(type(of: self)) did not meet SORT dependency.")
        }
        
        guard delegate != nil else {
            fatalError("\(type(of: self)) did not meet delegate dependency.")
        }
    }
    
    func configureMapView() {
        mapView.delegate = self
        mapView.showAnnotations([SORT], animated: false)
    }
    
    func setLabels() {
        titleTextField.text = SORT.title
        subtitleTextField.text = SORT.subtitle
        coordinateLabel.text = "\(SORT.coordinate.latitude), \(SORT.coordinate.longitude)"
    }
    
    // MARK: - Actions
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        delegate.delegationVCDidCancel(self)
    }
    
    @IBAction func saveTapped(_ sender: AnyObject) {
        SORT.title = self.titleTextField.text
        SORT.subtitle = self.subtitleTextField.text
        
        delegate.delegationVCDidSave(self)
    }

}
