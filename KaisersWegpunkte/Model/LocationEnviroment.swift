//
//  LocationEnviroment.swift
//  KaisersWegpunkte
//
//  Created by Bennet Panzek on 05.01.24.
//

import Foundation
import CoreLocation

class LocationEnviroment: NSObject, CLLocationManagerDelegate, ObservableObject{
    var locationManager: CLLocationManager
    
    @Published var gpsLocation = CLLocation()
    
    override init(){ //weil NSObject schon init hat
        self.locationManager = CLLocationManager()
        
        super.init()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()
        
        locationManager.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let lat = locations.last?.coordinate.latitude //holt letzte Kordinate
        let lon = locations.last?.coordinate.longitude //?, weil kann sein das array leer ist
        print("location: <\(lat ?? 0), \(lon ?? 0)>")
        
        gpsLocation = locations.last ?? CLLocation()
        
    }
    
}
