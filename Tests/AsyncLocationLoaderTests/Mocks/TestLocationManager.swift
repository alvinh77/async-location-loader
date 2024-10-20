//
//  TestLocationManager.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

import AsyncLocationLoader
import CoreLocation

final class TestLocationManager: LocationManaging, @unchecked Sendable {
    var authorizationStatus: CLAuthorizationStatus {
        get { lock.withLock { _authorizationStatus } }
        set { lock.withLock { _authorizationStatus = newValue } }
    }
    var delegate: (any CLLocationManagerDelegate)? {
        get { lock.withLock { _delegate } }
        set { lock.withLock { _delegate = newValue } }
    }
    private var _authorizationStatus: CLAuthorizationStatus
    private var _delegate: (any CLLocationManagerDelegate)?
    private let lock = NSLock()
    private(set) var requestWhenInUseAuthorizationCallsCount = 0
    private(set) var requestAlwaysAuthorizationCallsCount = 0

    init(authorizationStatus: CLAuthorizationStatus = .notDetermined) {
        self._authorizationStatus = authorizationStatus
    }

    func requestWhenInUseAuthorization() {
        lock.withLock {
            requestWhenInUseAuthorizationCallsCount += 1
        }
    }

    func requestAlwaysAuthorization() {
        lock.withLock {
            requestAlwaysAuthorizationCallsCount += 1
        }
    }
}
