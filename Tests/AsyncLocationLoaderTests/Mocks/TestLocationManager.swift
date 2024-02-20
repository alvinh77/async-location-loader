//
//  TestLocationManager.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

import AsyncLocationLoader
import CoreLocation

final class TestLocationManager: LocationManaging {
    private(set) var requestWhenInUseAuthorizationCallsCount = 0
    private(set) var requestAlwaysAuthorizationCallsCount = 0

    var authorizationStatus: CLAuthorizationStatus

    init(authorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self.authorizationStatus = authorizationStatus
    }

    func requestWhenInUseAuthorization() {
        requestWhenInUseAuthorizationCallsCount += 1
    }

    func requestAlwaysAuthorization() {
        requestAlwaysAuthorizationCallsCount += 1
    }
}
