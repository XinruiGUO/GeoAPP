//
//  GeoPage.swift
//  GeoApp
//
//  Created by Xinrui on 20/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import CoreData
import PCLBlurEffectAlert

class RealTimeController: UIViewController, CLLocationManagerDelegate {
    
    
    typealias Point = (Double, Double, Date)
    typealias markerDot = (Double, Double, String, String)
    
    var timeStamp = Date()
    let locationManager = CLLocationManager()

    var latitude = Double()
    var longitude = Double()
    var count = Int()
    var oldMarkers = [markerDot]()
    var tag = Int()
    
    let googleMapView = GoogleMapView()
    let realTimeDao = RealTimeDao()

    
    func mapTypeAlert() {
        let alertPanel = PCLBlurEffectAlert.Controller(title: "Sélectionnez le map type", message: "", effect: UIBlurEffect(style: .dark), style: .alert)
        let cart2DBtn = PCLBlurEffectAlert.AlertAction(title: "Carte2D", style: .default) { _ in
            self.googleMapView.mapView?.mapType = kGMSTypeNormal
        }

        let HybridBtn = PCLBlurEffectAlert.AlertAction(title: "Satellite", style: .default) { _ in
            self.googleMapView.mapView?.mapType = kGMSTypeHybrid
        }

        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: "Annuler", style: .cancel, handler: nil)
        
        alertPanel.addAction(cart2DBtn)
        alertPanel.addAction(HybridBtn)
        alertPanel.addAction(cancelBtn)
       
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 18), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.configure(buttonTextColor: [.default: .white,
                                               .cancel: .white,
                                               .destructive: .white])
 
        alertPanel.show()
    }
    
    func settingsAlert() {
 
        let alertPanel = PCLBlurEffectAlert.Controller(title: "Sélectionnez l'affichage de location type", message: "", effect: UIBlurEffect(style: .dark), style: .alert)
        let normalModeBtn = PCLBlurEffectAlert.AlertAction(title: "Normale", style: .default) { _ in
            self.tag = 0
        }

        let lineModeBtn = PCLBlurEffectAlert.AlertAction(title: "Trajet ligne", style: .default) { _ in
            self.tag = 1
        }
        
        let dotLineModeBtn = PCLBlurEffectAlert.AlertAction(title: "Trajet ligne avec les points", style: .default) { _ in
            self.tag = 2
        }
        
        let cancelBtn = PCLBlurEffectAlert.AlertAction(title: "Annuler", style: .cancel, handler: nil)
        alertPanel.addAction(normalModeBtn)
        alertPanel.addAction(lineModeBtn)
        alertPanel.addAction(dotLineModeBtn)
        alertPanel.addAction(cancelBtn)
        
        alertPanel.configure(cornerRadius: 30)
        alertPanel.configure(titleFont: UIFont.systemFont(ofSize: 18), titleColor: .white)
        alertPanel.configure(backgroundColor: .blue)
        alertPanel.configure(buttonTextColor: [.default: .white,
                                               .cancel: .white,
                                               .destructive: .white])
        alertPanel.show()
    }


    
    @IBAction func changeMapType(_ sender: Any) {
        mapTypeAlert()
    }
    
    @IBAction func changeShowLocationMode(_ sender: Any) {
        settingsAlert()
    }
    
    @IBAction func back(_ sender: Any) {
        let mainFrameVC  :UIViewController = self.storyboard?.instantiateViewController(withIdentifier: "mainFrameVC") as! MainFrameController
        let navController = UINavigationController(rootViewController: mainFrameVC)
        navController.modalTransitionStyle = .crossDissolve
        self.present(navController, animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        count = 0
        tag = 0
        oldMarkers = []
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        googleMapView.loadMap(latitude: latitude, longitude: longitude)
        self.view = googleMapView.mapView
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location manager did update locations")
        count = (count+1)%5
        let userLocation:CLLocation = locations[0] as CLLocation

        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        var address = ""
        var postalCode = ""
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error)
                
            } else {
                if let placemark = placemarks?[0] {
                    
                    
                    if placemark.subThoroughfare != nil {
                        address += placemark.subThoroughfare! + " "
                    }
                    
                    if placemark.thoroughfare != nil {
                        address += placemark.thoroughfare!
                    }

                    if placemark.postalCode != nil {
                        postalCode += placemark.postalCode! + " "
                    }
                    
                    if placemark.subAdministrativeArea != nil {
                        postalCode += placemark.subAdministrativeArea! + " "
                    }
                    
                    if placemark.country != nil {
                        postalCode += placemark.country!
                    }
                    
                    switch self.tag {
                    case 0:
                        self.googleMapView.mapView?.clear()
                        self.googleMapView.drawMark(latitude: self.latitude, longitude: self.longitude, address: address, postalCode: postalCode)
                        break
                    case 1:
                        self.googleMapView.drawMark(latitude: self.latitude, longitude: self.longitude, address: address, postalCode: postalCode)
                        self.googleMapView.drawPolylineWithPoint(lastPoint: (self.latitude, self.longitude, self.timeStamp))
                        break
                    case 2:
                        self.googleMapView.drawMark(latitude: self.latitude, longitude: self.longitude, address: address, postalCode: postalCode)
                        self.googleMapView.drawPolylineWithPoint(lastPoint: (self.latitude, self.longitude, self.timeStamp))
                        if self.count % 5 == 0 {
                            self.oldMarkers.append((self.latitude, self.longitude, address, postalCode))
                            self.googleMapView.drawMarkArray(oldMarkArray: self.oldMarkers)
                        }
                        break
                    default:
                        break
                    }
                }
            }
        }
        realTimeDao.saveCoordinates(timestamp: timeStamp, latitude: latitude, longitude: longitude)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        print(status)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        print("Error \(error)")
    }
}
