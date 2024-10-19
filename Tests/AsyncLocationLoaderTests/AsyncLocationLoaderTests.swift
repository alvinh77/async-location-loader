//
//  AsyncLocationLoaderTests.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

@testable import AsyncLocationLoader

import CoreLocation
import Testing

struct AsyncLocationLoaderTests {

    @Test(arguments: [
        (CLAuthorizationStatus.notDetermined, AuthorizationStatus.notDetermined),
        (CLAuthorizationStatus.denied, AuthorizationStatus.denied),
        (CLAuthorizationStatus.restricted, AuthorizationStatus.restricted),
        (CLAuthorizationStatus.authorizedAlways, AuthorizationStatus.authorizedAlways),
        (CLAuthorizationStatus.authorizedWhenInUse, AuthorizationStatus.authorizedWhenInUse)
    ])
    func authorizationStatus(
        inputStatus: CLAuthorizationStatus, outputStatus: AuthorizationStatus
    ) async {
        let loader = AsyncLocationLoader(
            locationManager: TestLocationManager(authorizationStatus: inputStatus)
        )
        await #expect(loader.authorizationStatus == outputStatus)
    }

    @Test
    func requestAuthorizationForAlways_callsLocationManager() async {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedAlways)
        let locationLoader = AsyncLocationLoader(locationManager: locationManager)
        let status = await locationLoader.requestAuthorization(for: .always)
        #expect(status == .authorizedAlways)
        #expect(locationManager.requestAlwaysAuthorizationCallsCount == 1)
    }

    @Test
    func requestAuthorizationForWhenInUse_callsLocationManager() async {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedWhenInUse)
        let locationLoader = AsyncLocationLoader(locationManager: locationManager)
        let status = await locationLoader.requestAuthorization(for: .whenInUse)
        #expect(status == .authorizedWhenInUse)
        #expect(locationManager.requestWhenInUseAuthorizationCallsCount == 1)
    }
}
