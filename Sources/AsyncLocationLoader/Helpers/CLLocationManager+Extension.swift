//
//  CLLocationManager+Extension.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

import CoreLocation

public protocol LocationManaging {
    var authorizationStatus: CLAuthorizationStatus { get }
    var delegate: CLLocationManagerDelegate? { get set }
    func requestWhenInUseAuthorization()
    func requestAlwaysAuthorization()
}

extension CLLocationManager: LocationManaging {}
