//
//  AsyncLocationLoaderTests.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

@testable import AsyncLocationLoader

import CoreLocation
import Testing

struct AsyncLocationManagerTests {

    @Test(arguments: [
        (CLAuthorizationStatus.notDetermined, AuthorizationStatus.notDetermined),
        (CLAuthorizationStatus.denied, AuthorizationStatus.denied),
        (CLAuthorizationStatus.restricted, AuthorizationStatus.restricted),
        (CLAuthorizationStatus.authorizedAlways, AuthorizationStatus.authorizedAlways),
        (CLAuthorizationStatus.authorizedWhenInUse, AuthorizationStatus.authorizedWhenInUse)
    ])
    func authorizationStatus(inputStatus: CLAuthorizationStatus, outputStatus: AuthorizationStatus) {
        let manager = AsyncLocationManager(
            locationManager: TestLocationManager(authorizationStatus: inputStatus)
        )
        #expect(manager.authorizationStatus == outputStatus)
    }

    @Test
    func authorizationStatusStream() async {
        let locationManager = TestLocationManager(authorizationStatus: .notDetermined)
        let (asyncStream, continuation) = AsyncStream<AuthorizationStatus>.makeStream()
        let manager = AsyncLocationManager(
            locationManager: locationManager,
            asyncStreamTuple: (asyncStream, continuation)
        )
        #expect(locationManager.delegate === manager)
        var statuses: [AuthorizationStatus] = []
        Task {
            manager.locationManagerDidChangeAuthorization(.init())
            locationManager.authorizationStatus = .authorizedWhenInUse
            manager.locationManagerDidChangeAuthorization(.init())
            locationManager.authorizationStatus = .authorizedAlways
            manager.locationManagerDidChangeAuthorization(.init())
            continuation.finish()
        }
        for await authorizationStatus in manager.authorizationStatusStream {
            statuses.append(authorizationStatus)
        }
        #expect(statuses == [.notDetermined, .authorizedWhenInUse, .authorizedAlways])
    }

    @Test
    func requestAuthorizationForAlways_callsLocationManager() {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedAlways)
        let manager = AsyncLocationManager(locationManager: locationManager)
        manager.requestAuthorization(for: .always)
        #expect(locationManager.requestAlwaysAuthorizationCallsCount == 1)
    }

    @Test
    func requestAuthorizationForWhenInUse_callsLocationManager() {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedWhenInUse)
        let manager = AsyncLocationManager(locationManager: locationManager)
        manager.requestAuthorization(for: .whenInUse)
        #expect(locationManager.requestWhenInUseAuthorizationCallsCount == 1)
    }
}
