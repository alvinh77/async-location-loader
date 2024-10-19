//
//  TestLocationManager.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

import AsyncLocationLoader
import CoreLocation

final class TestLocationManager: LocationManaging, @unchecked Sendable {
    private let lock = NSLock()
    private(set) var requestWhenInUseAuthorizationCallsCount = 0
    private(set) var requestAlwaysAuthorizationCallsCount = 0

    let authorizationStatus: CLAuthorizationStatus

    init(authorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self.authorizationStatus = authorizationStatus
    }

    func requestWhenInUseAuthorization() {
        lock.lock()
        requestWhenInUseAuthorizationCallsCount += 1
        lock.unlock()
    }

    func requestAlwaysAuthorization() {
        lock.lock()
        requestAlwaysAuthorizationCallsCount += 1
        lock.unlock()
    }
}
