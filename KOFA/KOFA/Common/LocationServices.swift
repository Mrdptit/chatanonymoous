//
//  LocationServices.swift
//  globallocator
//
//  Created by Nik Psaragkathos on 08/02/2017.
//  Copyright © 2017 NIK PSARAGKATHOS. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

protocol LocationServicesDelegate {
    func tracingLocation(_ currentLocation: CLLocation)
    func tracingLocationDidFailWithError(_ error: NSError)
    func tracingHeading( _ currentHeading: CLHeading)
}

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance: LocationServices = {
        let instance = LocationServices()
        return instance
    }()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var heading : CLHeading?
    var delegate: LocationServicesDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        self.requestPermission()
    }
    
    func requestPermission(){
        guard let locationManager = self.locationManager else {
            return
        }
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            print("Authorized When in Use ")
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways:
            print("Authorized Always")
            locationManager.requestAlwaysAuthorization()
        case .notDetermined:
            print("Not Determined")
            locationManager.requestAlwaysAuthorization()
        case .restricted, .denied:
            print("Authorization Restricted or Denied")
            locationManager.requestAlwaysAuthorization()
            alertMessage()
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation // The accuracy of the location data
        locationManager.distanceFilter = 2.0 // The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
        locationManager.delegate = self
        locationManager.activityType = CLActivityType.fitness
        locationManager.headingFilter = 1 //The minimum angular change (measured in degrees) required
    }
    
    func getAddressFromLocation(location: CLLocation, completion: @escaping (_ result: Bool,_ reponse :NSDictionary?)->()){
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if error != nil {
                completion(false, nil)
            } else {
                var placeMark: CLPlacemark!
                placeMark = placemarks?[0]
                guard let address = placeMark.addressDictionary as NSDictionary? else {
                    return
                }
                completion(true, address)
            }
        }
    }
    
    func startUpdatingLocation() {
        print("Starting Location Updates")
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        print("Stop Location Updates")
        self.locationManager?.stopUpdatingLocation()
    }
    
    func startUpdatingHeading(){
        print("Starting Compass Updates")
        self.locationManager?.startUpdatingHeading()
    }
    
    func stopUpdatingHeading(){
        print("Stoping Compass Updates")
        self.locationManager?.stopUpdatingHeading()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }
        
        // singleton for get last(current) location
        currentLocation = location
        // use for real time update location
        updateLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // do on error
        updateLocationDidFailWithError(error as NSError)
    }
    
    //Updating Heading
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = newHeading
        
        updateHeading(heading!)
    }
    
    // Private function
    fileprivate func updateLocation(_ currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation)
    }
    
    fileprivate func updateLocationDidFailWithError(_ error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error)
    }
    
    fileprivate func updateHeading( _ currentHeading: CLHeading){
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingHeading(currentHeading)
    }
    
    
    fileprivate func alertMessage() {
        
        let alertController = UIAlertController(title: "Location Access Disabled", message: "In order to be notified about location changes, please open this app's settings and set location access to 'When In Use'.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION") {
                // If general location settings are disabled then open general location settings
                UIApplication.shared.openURL(url)
            }
        }
        alertController.addAction(settingsAction)
        
        var rootViewController = UIApplication.shared.keyWindow?.rootViewController
        if let navigationController = rootViewController as? UINavigationController {
            rootViewController = navigationController.viewControllers.first
        }
        if let tabBarController = rootViewController as? UITabBarController {
            rootViewController = tabBarController.selectedViewController
        }
        rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
