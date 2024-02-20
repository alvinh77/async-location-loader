//
//  AsyncLocationLoaderTests.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

@testable import AsyncLocationLoader

import XCTest

final class AsyncLocationLoaderTests: XCTestCase {
    func test_authorizationStatus() {
        XCTAssertEqual(
            AsyncLocationLoader(
                locationManager: TestLocationManager(authorizationStatus: .notDetermined)
            ).authorizationStatus,
            .notDetermined
        )
        XCTAssertEqual(
            AsyncLocationLoader(
                locationManager: TestLocationManager(authorizationStatus: .restricted)
            ).authorizationStatus,
            .restricted
        )
        XCTAssertEqual(
            AsyncLocationLoader(
                locationManager: TestLocationManager(authorizationStatus: .denied)
            ).authorizationStatus,
            .denied
        )
        XCTAssertEqual(
            AsyncLocationLoader(
                locationManager: TestLocationManager(authorizationStatus: .authorizedAlways)
            ).authorizationStatus,
            .authorizedAlways
        )
        XCTAssertEqual(
            AsyncLocationLoader(
                locationManager: TestLocationManager(authorizationStatus: .authorizedWhenInUse)
            ).authorizationStatus,
            .authorizedWhenInUse
        )
    }

    func test_requestAuthorizationForAlways_callsLocationManager() async {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedAlways)
        let locationLoader = AsyncLocationLoader(locationManager: locationManager)
        let status = await locationLoader.requestAuthorization(for: .always)
        XCTAssertEqual(status, .authorizedAlways)
        XCTAssertEqual(locationManager.requestAlwaysAuthorizationCallsCount, 1)
    }

    func test_requestAuthorizationForWhenInUse_callsLocationManager() async {
        let locationManager = TestLocationManager(authorizationStatus: .authorizedWhenInUse)
        let locationLoader = AsyncLocationLoader(locationManager: locationManager)
        let status = await locationLoader.requestAuthorization(for: .whenInUse)
        XCTAssertEqual(status, .authorizedWhenInUse)
        XCTAssertEqual(locationManager.requestWhenInUseAuthorizationCallsCount, 1)
    }
}
