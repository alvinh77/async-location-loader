//
//  AsyncLocationLoader.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

import CoreLocation
import Foundation

public enum AuthorizationStatus: Sendable {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case unknown

    public init(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        case .denied:
            self = .denied
        case .authorizedAlways:
            self = .authorizedAlways
        case .authorizedWhenInUse:
            self = .authorizedWhenInUse
        @unknown default:
            self = .unknown
        }
    }
}

public enum AuthorizationType: Sendable {
    case whenInUse
    case always
}

public protocol AsyncLocationManaging: Sendable {
    var authorizationStatus: AuthorizationStatus { get }
    var authorizationStatusStream: AsyncStream<AuthorizationStatus> { get }
    func requestAuthorization(for type: AuthorizationType)
}

public final class AsyncLocationManager:
    NSObject, AsyncLocationManaging, CLLocationManagerDelegate, @unchecked Sendable {
    private var locationManager: LocationManaging
    private let continuation: AsyncStream<AuthorizationStatus>.Continuation
    private let lock = NSRecursiveLock()
    public let authorizationStatusStream: AsyncStream<AuthorizationStatus>

    public init(
        locationManager: LocationManaging,
        asyncStreamTuple: (AsyncStream<AuthorizationStatus>, AsyncStream<AuthorizationStatus>.Continuation)
        = AsyncStream<AuthorizationStatus>.makeStream()
    ) {
        self.locationManager = locationManager
        (self.authorizationStatusStream, self.continuation) = asyncStreamTuple
        super.init()
        self.locationManager.delegate = self
    }

    public var authorizationStatus: AuthorizationStatus {
        lock.withLock {
            AuthorizationStatus(locationManager.authorizationStatus)
        }
    }

    public func requestAuthorization(for type: AuthorizationType) {
        lock.lock()
        switch type {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .always:
            locationManager.requestAlwaysAuthorization()
        }
        lock.unlock()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        lock.lock()
        continuation.yield(authorizationStatus)
        lock.unlock()
    }
}
