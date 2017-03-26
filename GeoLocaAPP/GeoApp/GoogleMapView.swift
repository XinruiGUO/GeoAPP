//
//  GoogleMapsView.swift
//  GeoApp
//
//  Created by Xinrui on 25/03/17.
//  Copyright © 2017 Xinrui. All rights reserved.
//

import GoogleMaps

class GoogleMapView: UIViewController {
    
    typealias Point = (Double, Double, Date)
    typealias markerDot = (Double, Double, String, String)
    var camera = GMSCameraPosition()
    var mapView: GMSMapView?
    let realtimePath = GMSMutablePath()
    let marker = GMSMarker()
    var oldMarkArray = [markerDot]()
    
    /*** Load map ***/
    func loadMap(latitude: Double, longitude: Double) {
        camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 1)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView?.mapType = kGMSTypeHybrid
    }
    
    func loadReplayMap(bound: CGRect) {
        camera = GMSCameraPosition.camera(withLatitude: 48, longitude: 2, zoom: 10)
        mapView = GMSMapView.map(withFrame: bound, camera: camera)
        mapView?.mapType = kGMSTypeHybrid
    }
    
    
    /*** Autozoom map ***/
    func autozoomWithOnePoint(latitude: Double, longitude: Double) {
        let currentLocation = CLLocationCoordinate2DMake(latitude, longitude)
        let bounds = GMSCoordinateBounds(coordinate: currentLocation, coordinate: currentLocation)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 10.0)
        mapView?.animate(with: update)
    }
    
    func autozoomWithPointArray(startPosition: CLLocationCoordinate2D, endPosition: CLLocationCoordinate2D) {
        let bounds = GMSCoordinateBounds(coordinate: startPosition, coordinate: endPosition)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
        mapView?.animate(with: update)
    }
    
    
    /*** Draw polyline ***/
    func drawPolylineWithPoint(lastPoint: Point){
        realtimePath.add(CLLocationCoordinate2DMake(lastPoint.0, lastPoint.1))
        
        let polyline = GMSPolyline(path: realtimePath)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .orange
        //polyline.geodesic = true
        polyline.map = mapView
        
        autozoomWithOnePoint(latitude: lastPoint.0, longitude: lastPoint.1)
    }
    
    func drawPolylineWithPointArray(coordinates: [Point]){
        let markerStart = GMSMarker()
        let markerEnd = GMSMarker()
        let path = GMSMutablePath()
        
        //Marker on the start point
        markerStart.position = CLLocationCoordinate2DMake((coordinates.first?.0)!,(coordinates.first?.1)!)
        markerStart.title = "Start point"
        markerStart.map = mapView
        
        //Marker on the end point
        markerEnd.position = CLLocationCoordinate2DMake((coordinates.last?.0)!,(coordinates.last?.1)!)
        markerEnd.icon = GMSMarker.markerImage(with: UIColor.green)
        markerEnd.title = "End point"
        markerEnd.map = mapView
        
        for item in coordinates {
            path.add(CLLocationCoordinate2DMake(item.0, item.1))
        }
        
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        polyline.strokeColor = .orange
        polyline.map = mapView
        
        autozoomWithPointArray(startPosition:  markerStart.position, endPosition: markerEnd.position)
    }

    
    /*** Draw marker ***/
    func drawMark(latitude: Double, longitude: Double, address: String, postalCode: String) {
        self.marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        self.marker.title = address
        self.marker.snippet = postalCode
        self.marker.map = mapView
        autozoomWithOnePoint(latitude: latitude, longitude: longitude)
    }
    
    func drawMarkArray(oldMarkArray: [markerDot]) {
        for oldCoordinate in oldMarkArray {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(oldCoordinate.0, oldCoordinate.1)
            
            marker.icon =  UIImage(named: "blue_point")
            marker.title = oldCoordinate.2
            marker.snippet = oldCoordinate.3
            marker.map = mapView
        }
    }
}
