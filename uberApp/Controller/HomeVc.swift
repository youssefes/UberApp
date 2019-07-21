//
//  ViewController.swift
//  uberApp
//
//  Created by youssef on 7/12/19.
//  Copyright © 2019 youssef. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import RevealingSplashView
import Firebase

class HomeVc: UIViewController{

    var currentUserId : String?
    @IBOutlet weak var distnationcircal: cornerView!
    @IBOutlet weak var distanationTextField: UITextField!
    var reduisRegion : CLLocationDistance = 1000
    var manger : CLLocationManager = CLLocationManager()
    var matchingItem : [MKMapItem] = [MKMapItem]()
    var route: MKRoute!
    
    var recealingSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width: 80.0, height: 80.0), backgroundColor: UIColor.white)
    
    
    var selectedItemPlace : MKPlacemark? = nil
    var tableView = UITableView()
    var delegate :CenterVCDeleget?
    @IBOutlet weak var activeBtn: RoundShasowButton!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        currentUserId = Auth.auth().currentUser?.uid
        
        distanationTextField.delegate = self
        
        DataService.instance.REF_DRIVERS.observe(.value) { (snapchat) in
            self.loadDriverAnnotaionFromFB()
        }
        self.view.addSubview(recealingSplashView)
        recealingSplashView.animationType = .heartBeat
        recealingSplashView.startAnimation()
        recealingSplashView.heartAttack = true
        
        checkLocationManger()
        
        UpdataService.instance.observerTrip { (tripDict) in
            if let tripDict = tripDict{
                let pickUpcoordinateArray = tripDict["pickUpCoordinate"] as! NSArray
                let tripKey = tripDict["passangerKey"] as! String
                let tripAcceptStatus = tripDict["tripAccept"] as! Bool
                
                if tripAcceptStatus == false{
                    DataService.instance.DriverIsAvailable(Key: self.currentUserId!, handler: { (avalible) in
                        if avalible {
                            let storyBord = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let pickupVc = storyBord.instantiateViewController(withIdentifier: "PickupVC") as? PickupVC
                            
                            pickupVc?.initData(coordinate: CLLocationCoordinate2D(latitude: pickUpcoordinateArray[0] as! CLLocationDegrees, longitude: pickUpcoordinateArray[1] as! CLLocationDegrees), passangerKey: tripKey)
                            self.present(pickupVc!, animated: true, completion: nil)
                        }
                    })
                   
                }
            }
        }
       
        
    }

    @IBAction func centerUserLocation(_ sender: Any) {
        DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for usre in userSnapshot{
                    if usre.key == Auth.auth().currentUser?.uid{
                        if usre.hasChild("TripCoordinate"){
                            self.zoom(toFitAnnotationFromMapView: self.mapView)
                        }else{
                            self.centerUserLocation()
                        }
                    }
                }
            }
        }
        
        

    }
    
    @IBAction func activeBtnPress(_ sender: Any) {
        UpdataService.instance.updataTripsWithCoordinateUponRequest()
        activeBtn.animateButton(shouldLoad: true, WithMessage: nil)
        self.view.endEditing(true)
    }
    @IBAction func menuAction(_ sender: Any) {
        delegate?.togelleftPanel()
    }
    
    
    func setupLocationManger(){
        manger.delegate = self
        manger.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationManger(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManger()
            self.checkAuthorizationStaus()
        }else{
            print("do not allow")
        }
        
    }
    
    func loadDriverAnnotaionFromFB(){
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
            if let userSnapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for driver in userSnapshot{
                    if driver.hasChild("coordinate"){
                        if driver.childSnapshot(forPath: "isPickupModeEnable").value as? Bool == true{
                            if let driverDict = driver.value as? Dictionary<String,Any>{
                                if let coordinateArray = driverDict["coordinate"] as? NSArray{
                                    let driverAnnotationCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                                    let annotation = DriverAnntation(coordinate: driverAnnotationCoordinate, withKey: driver.key)
                                    var driverIsVisable : Bool{
                                        return self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                            if let driverAnnotation = annotation as?DriverAnntation{
                                                if driverAnnotation.key == driver.key{
                                                    driverAnnotation.update(AnnotationPosition: driverAnnotation, withCoordinate: driverAnnotationCoordinate)
                                                    return true
                                                }
                                               
                                            }
                                             return false
                                        })
                                        
                                        
                                        
                                    }
                                    if !driverIsVisable{
                                        self.mapView.addAnnotation(annotation)
                                    }
                                    
                                }
                            }
                        }else{
                            for annotation in self.mapView.annotations{
                                if annotation.isKind(of: DriverAnntation.self){
                                    if let annotation = annotation as? DriverAnntation{
                                        if annotation.key == driver.key{
                                            self.mapView.removeAnnotation(annotation)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func centerUserLocation(){
        let coordinateRegin = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: reduisRegion * 2.0, longitudinalMeters:reduisRegion * 2.0 )
        mapView.setRegion(coordinateRegin, animated: true)
    }
}

extension HomeVc: CLLocationManagerDelegate{
    func checkAuthorizationStaus(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            manger.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        case .denied:
            break
        case .notDetermined:
            manger.requestAlwaysAuthorization()
        case .restricted:
            break
        case .authorizedAlways:
            manger.startUpdatingLocation()
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationStaus()
    }
}

extension HomeVc : MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        UpdataService.instance.UpdataUserLocation(withCoordinate: userLocation.coordinate)
        UpdataService.instance.updataDriverLocation(withCoordinate: userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotaion = annotation as? DriverAnntation{
            let identifier = "drivers"
            let view : MKAnnotationView = MKAnnotationView(annotation: annotaion, reuseIdentifier: identifier)
            view.image = UIImage(named: "driverAnnotation")
            return view
        }else if let annotaion = annotation as? PassangerAnnotaion {
            let identifier = "passanger"
            let view : MKAnnotationView = MKAnnotationView(annotation: annotaion, reuseIdentifier: identifier)
            view.image = UIImage(named: "currentLocationAnnotation")
            return view
        }else if let annotaion = annotation as? MKPointAnnotation{
            let identifier = "distnation"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if annotationView == nil{
                annotationView = MKAnnotationView(annotation: annotaion, reuseIdentifier: identifier)
            }else{
                annotationView?.annotation = annotaion
            }
            annotationView?.image = UIImage(named: "destinationAnnotation")
            return annotationView
        }
        return nil
    }
    
    func performSearch(){
        matchingItem.removeAll()
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = distanationTextField.text
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { (respond, error) in
            if error != nil{
                print(error.debugDescription)
            }else if respond?.mapItems.count == 0{
                print("no result")
            }else{
                for mapItem in respond!.mapItems{
                    self.matchingItem.append(mapItem as MKMapItem)
                    self.tableView.reloadData()
                    self.shouldPresentViewLoading(false)
                }
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let lineRenderer = MKPolylineRenderer(overlay: self.route.polyline)
        lineRenderer.strokeColor = UIColor(red: 216/255, green: 71/255, blue: 30/255, alpha: 0.75)
        lineRenderer.lineWidth = 3
        zoom(toFitAnnotationFromMapView: self.mapView)
        return lineRenderer
        
    }
    
    
    func dropPin(forPlaceMark placeMark: MKPlacemark){
        selectedItemPlace = placeMark
        
        for annotation in mapView.annotations{
            if annotation.isKind(of: MKPointAnnotation.self){
                mapView.removeAnnotation(annotation)
            }
            
        }
        let annotaion = MKPointAnnotation()
        annotaion.coordinate = placeMark.coordinate
        mapView.addAnnotation(annotaion)
    }
    
    
    func searchMapKitWithResultPolyline(formapItem mapitem : MKMapItem){
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapitem
        request.transportType = MKDirectionsTransportType.automobile
        
        let direction = MKDirections(request: request)
        direction.calculate { (respond, error) in
            guard let respond = respond else{
                print(error.debugDescription)
                return
            }
            self.route = respond.routes[0]
            self.mapView.addOverlay(self.route.polyline)
            self.shouldPresentViewLoading(false)
        }
        
    }
    
    func zoom(toFitAnnotationFromMapView mapView : MKMapView ){
        if mapView.annotations.count == 0{
            return
        }
        
        var topleftcoordinate = CLLocationCoordinate2D(latitude: -90 , longitude: 180)
        var bottonrightcoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for annotation in mapView.annotations where !annotation.isKind(of: DriverAnntation.self){
            topleftcoordinate.longitude = fmin(topleftcoordinate.longitude, annotation.coordinate.longitude)
            topleftcoordinate.latitude = fmax(topleftcoordinate.latitude, annotation.coordinate.latitude)
            bottonrightcoordinate.longitude = fmax(bottonrightcoordinate.longitude, annotation.coordinate.longitude)
            bottonrightcoordinate.latitude = fmin(bottonrightcoordinate.latitude, annotation.coordinate.latitude)
        }
        
        var regoin = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topleftcoordinate.latitude - (topleftcoordinate.latitude - bottonrightcoordinate.latitude) * 0.5, topleftcoordinate.longitude + (bottonrightcoordinate.longitude - topleftcoordinate.longitude) * 0.5), span: MKCoordinateSpan(latitudeDelta: fabs(topleftcoordinate.latitude - bottonrightcoordinate.latitude) * 2.0, longitudeDelta: fabs(bottonrightcoordinate.longitude - topleftcoordinate.longitude) * 2.0))
        
        regoin = mapView.regionThatFits(regoin)
        
        self.mapView.setRegion(regoin, animated: true)
    }
}
extension HomeVc : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == distanationTextField{
            tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
            tableView.layer.cornerRadius = 5.0
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tag = 18
            tableView.rowHeight = 60
            view.addSubview(tableView)
            animateTableView(shouldShow: true)
            
            UIView.animate(withDuration: 0.2) {
                self.distnationcircal.backgroundColor = UIColor.red
                self.distnationcircal.bordercolor = UIColor.init(red: 199/255, green: 0/255, blue: 0/255, alpha: 1.0)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == distanationTextField{
            performSearch()
            shouldPresentViewLoading(true)
            view.endEditing(true)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == distanationTextField{
            if distanationTextField.text == ""{
                distnationcircal.backgroundColor = UIColor.lightGray
                distnationcircal.bordercolor = UIColor.darkGray
            }
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        matchingItem = []
        tableView.reloadData()
        
        mapView.removeOverlays(mapView.overlays)
        DataService.instance.REF_USERS.child(currentUserId!).child("TripCoordinate").removeValue()
        //animateTableView(shouldShow: false)
        for annotation in mapView.annotations{
            if let annotation = annotation as? MKPointAnnotation{
                mapView.removeAnnotation(annotation)
            }else if annotation.isKind(of: PassangerAnnotaion.self){
                mapView.removeAnnotation(annotation)
            }
            
        }
        centerUserLocation()
        return true
    }
    
    func animateTableView(shouldShow: Bool){
        UIView.animate(withDuration: 0.2) {
            if shouldShow{
                self.tableView.frame = CGRect(x: 20, y: 170, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
            }else{
                UIView.animate(withDuration: 0.2, animations: {
                    self.tableView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - 170)
                }, completion: { (finished) in
                    if finished{
                        for subView in self.view.subviews{
                            if subView.tag == 18{
                                subView.removeFromSuperview()
                            }
                        }
                    }
                })
                
            }
           
        }
    }
}

extension HomeVc: UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItem.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
        let mapItem = matchingItem[indexPath.row]
        
        cell.textLabel?.text = mapItem.name
        cell.detailTextLabel?.text = mapItem.placemark.title
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        shouldPresentViewLoading(true)
        let passangerlocation = mapView.userLocation.coordinate
        if currentUserId != nil{
            let passangerannotation = PassangerAnnotaion(coordinate: passangerlocation, withKey: currentUserId!)
            mapView.addAnnotation(passangerannotation)
            
            distanationTextField.text = tableView.cellForRow(at: indexPath)?.textLabel?.text
            let selectTrip = matchingItem[indexPath.row]
            
            dropPin(forPlaceMark: selectTrip.placemark)
            searchMapKitWithResultPolyline(formapItem: selectTrip)
            
            if let currentId : String = self.currentUserId{
                DataService.instance.REF_USERS.child(currentId).updateChildValues(["TripCoordinate" : [selectTrip.placemark.coordinate.latitude,selectTrip.placemark.coordinate.longitude]])
            }
            
            
            animateTableView(shouldShow: false)
        }
        
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if distanationTextField.text == ""{
            animateTableView(shouldShow: false)
        }
    }
}

extension HomeVc: UITableViewDelegate{
    
}

