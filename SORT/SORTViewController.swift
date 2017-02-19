//
//  SORTViewController.swift
//  SORT
//
//  Created by Nolan McQueen on 10/14/16.
//  Copyright © 2016 Nolan McQueen. All rights reserved.
//

import UIKit
import MapKit

class SORTViewController: UIViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    MKMapViewDelegate,
    DelegationVCDelegate
{
    // MARK: - Dependencies
    var alertProvider: AlertProvider = AlertService.sharedInstance
    var SORTProvider: SORTProvider = SORTService.sharedInstance
    
    // MARK: - Outlets
    
    
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    var SORTs = [SORT]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        
        centerMapOnFurman()
        
        
        
        setupTableView()
        
        reloadSORTsFromDataSource()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupMapView()
        displaySORTAnnotationsOnMap()

    }
    
    // MARK: - Helpers

    //Furman Test
    func centerMapOnFurman() {
        let furmanCoord = CLLocationCoordinate2D(
            latitude: 34.924592,
            longitude: -82.439153
        )
        
        let viewRegion = MKCoordinateRegionMakeWithDistance(
            furmanCoord,
            60000,
            60000
        )
        
        mapView.setRegion(viewRegion, animated: false)
    }
    
    func displaySORTAnnotationsOnMap() {
        // Remove existing annotations
        mapView.removeAnnotations(mapView.annotations)
        
        // Add annotations to map
        mapView.showAnnotations(SORTs, animated: true)
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        // Blur tableView background
        let visualEffect = UIBlurEffect(style: .light)
        let visualEffectView = UIVisualEffectView(effect: visualEffect)
        
        tableView.backgroundView = visualEffectView
        tableView.layer.shadowColor = UIColor.darkGray.cgColor
        tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        tableView.layer.shadowOpacity = 1.0
        tableView.layer.shadowRadius = 2
        tableView.layer.cornerRadius = 30
        
        tableView.layer.masksToBounds = true
    }
    
    func setupMapView() {
        mapView.layoutMargins.bottom = tableView.frame.height
    }
    
    func reloadSORTsFromDataSource() {
        // Fetch SORTs asynchronously from Network or Disk.
        SORTProvider.fetchSORTs(queue: .main) { (result) in
            // Switch on result enumeration; Error or SORTs are accessed via Swift enum associated values.
            switch result {
            case .failure(let error):
                // Display error in AlertView via alertProvider
                self.alertProvider.present(error, from: self)
                
            case .success(let SORTs):
                self.SORTs = SORTs
            }
        }
    }
    
    func updateUIForSORT(_ SORT: SORT) {
        // MapView annotation
        mapView.deselectAnnotation(SORT, animated: false)
        mapView.selectAnnotation(SORT, animated: false)
        
        // TableView row
        if let index = SORTs.index(of: SORT) {
            let indexPath = IndexPath(row: index, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    func updateUI() {
        displaySORTAnnotationsOnMap()
        //drawRouteOverlaysOnMap()
        tableView.reloadData()
    }
    
    /*
     Draws the lines on map 
     TODO: Delete
    */
    func drawRouteOverlaysOnMap() {
        // Remove existing overlays
        mapView.removeOverlays(mapView.overlays)
        
        // Get array of coordinates from SORTs
        var coordinates = SORTs.map { $0.coordinate }
        
        // Add UserLocation coordinate if available.
        if let userLocationCoordinate = mapView.userLocation.location?.coordinate {
            coordinates.insert(userLocationCoordinate, at: 0)
        }
        
        // Add coordinates as MKPolyline overlay
        let overlay = MKPolyline(coordinates: &coordinates, count: coordinates.count)
        mapView.add(overlay, level: .aboveRoads)
        
    }
    
    // MARK: - UITableViewDataSource
    

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.layer.shadowColor = UIColor.darkGray.cgColor
        tableView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        tableView.layer.shadowOpacity = 1.0
        tableView.layer.shadowRadius = 2
        tableView.layer.cornerRadius = 30
        tableView.layer.masksToBounds = true
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SORTs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sortCell", for: indexPath)
        
        let SORT = SORTs[(indexPath as NSIndexPath).row]
        let newImage = resizeImage(image: UIImage(named: SORT.image!)!, toTheSize: CGSize(width:50,height: 50))
        
        let cellImageLayer: CALayer?  = cell.imageView?.layer
        cellImageLayer!.cornerRadius = 25
        cellImageLayer!.masksToBounds = true
        cell.textLabel?.text = SORT.title
        cell.detailTextLabel?.text = SORT.subtitle
        cell.imageView?.image = newImage
        return cell
    }
    //Resizes the profile image
    func resizeImage(image:UIImage, toTheSize size:CGSize)->UIImage{
        
        
        let scale = size.width/image.size.width
        let width:CGFloat  = image.size.width * scale
        let height:CGFloat = image.size.height * scale;
        
        let rr:CGRect = CGRect( x:0, y:0, width: width,height: height);
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        image.draw(in: rr)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return newImage!
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let SORT = SORTs[(indexPath as NSIndexPath).row]
        mapView.selectAnnotation(SORT, animated: true)
    }
    
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Get SORTs sorted by proximity to user location.
        guard let location = userLocation.location else { return }
    
        addRadiusCircle(location: mapView.userLocation.location!)
        // Sort by proximity to current location.
        SORTs = SORTs.ordered(byProximityTo: location)
        
        // Sort by shortest route from current location to all SORTs.
        //        SORTs = SORTs.ordered(byShortestRouteToEachSORTStartingFrom: location)
        
        // Get SORTs sorted by nearest neighbour alogrithm.
        //        SORTs = SORTs.ordered(byNearestNeighbourStartingFrom: location)
        
        // Update UI
        updateUI()
    }
    
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // Return nil (default) for all annotations which are not SORTs. i.e. MKUserLocation
        guard annotation is SORT else { return nil }
        
        // Memory optimization
        let reuseIdentifier = "pinAnnotationView"
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier) as? MKPinAnnotationView ??
            MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        annotationView.canShowCallout = true
        annotationView.image = UIImage(named: SORTs[1].image!)
        // Directions Button
        let leftButton = UIButton(type: .custom)
        let image = UIImage(named: SORTs[1].image!)
        leftButton.setImage(image, for: UIControlState())
        leftButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        leftButton.tintColor = UIColor.white
        leftButton.backgroundColor = self.view.tintColor
        annotationView.leftCalloutAccessoryView = leftButton
        
        
        // Info Button
        let rightButton = UIButton(type: .detailDisclosure)
        annotationView.rightCalloutAccessoryView = rightButton
        
        return annotationView
    }
    
    //Decreases radius on visible map
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        //mapView.layer.cornerRadius = 250
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let selectedSORT = view.annotation as? SORT else { return }
        guard let index = SORTs.index(of: selectedSORT) else { return }
        
        // Select cell at index
        let indexPath = IndexPath(row: index, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    
    
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl)
    {
        let SORT = view.annotation as! SORT
        
        // Take separate actions for left & right accessory controls.
        
        // Directions
        if control == view.leftCalloutAccessoryView {
            getDirectionsForSORT(SORT)
        }
        
        // DelegationVC
        if control == view.rightCalloutAccessoryView {
            // Instantiate view controller from storyboard.
            let storyboard = UIStoryboard(name: "Main", bundle: nil )
            let navController = storyboard.instantiateViewController(
                withIdentifier: "DelegationNC") as! UINavigationController
            
            // Configure DelegationVC before presenting.
            let delegationVC = navController.topViewController as! DelegationVC
            
            delegationVC.SORT = SORT
            delegationVC.delegate = self
            
            // Present as modal
            present(navController, animated: true, completion: nil)
        }
    }
    
    func addRadiusCircle(location: CLLocation){
        self.mapView.delegate = self
        let circle = MKCircle(center: location.coordinate, radius: 100 as CLLocationDistance)
        self.mapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if overlay is MKCircle {
            let circle = MKCircleRenderer(overlay: overlay)
            circle.strokeColor = UIColor.blue
            circle.fillColor = UIColor(red: 0, green: 0, blue: 255, alpha: 0.1)
            circle.lineWidth = 1
            return circle
        } else {
        let lineView = MKPolylineRenderer(overlay: overlay)
        lineView.strokeColor = .blue
        return lineView
        }
    }
    
    // MARK: - DelegationVCDelegate
    
    func delegationVCDidCancel(_ delegationVC: DelegationVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func delegationVCDidSave(_ delegationVC: DelegationVC) {
        let SORT = delegationVC.SORT
        updateUIForSORT(SORT!)
        
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSegueVC" {
            let navController = segue.destination as! UINavigationController
            let segueVC = navController.topViewController as! SegueVC
            let selectedCell = sender as! UITableViewCell
            let selectedIndexPath = tableView.indexPath(for: selectedCell)!
            
            let SORT = SORTs[(selectedIndexPath as NSIndexPath).row]
            segueVC.SORT = SORT
        }
    }
    
    @IBAction func unwindToSORTViewController(_ unwindSegue: UIStoryboardSegue) {
        if let segueVC = unwindSegue.source as? SegueVC {
            let SORT = segueVC.SORT
            updateUIForSORT(SORT!)
        }
    }
    
    // MARK: - Directions
    
    func getDirectionsForSORT(_ SORT: SORT) {
        let placemark = MKPlacemark(
            coordinate: SORT.coordinate,
            addressDictionary: nil
        )
        
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = SORT.title
        
        mapItem.openInMaps(launchOptions: [
            MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
    }
}

