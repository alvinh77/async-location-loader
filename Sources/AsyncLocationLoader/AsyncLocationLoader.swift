//
//  AsyncLocationLoader.swift
//  AsyncLocationLoader
//
//  Created by Alvin He on 20/2/2024.
//

public enum AuthorizationStatus {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case unknown
}

public enum AuthorizationType {
    case whenInUse
    case always
}

public protocol AsyncLocationLoading {
    var authorizationStatus: AuthorizationStatus { get }
    func requestAuthorization(for type: AuthorizationType) async -> AuthorizationStatus
}

public struct AsyncLocationLoader: AsyncLocationLoading {
    private let locationManager: LocationManaging

    public init(locationManager: LocationManaging) {
        self.locationManager = locationManager
    }

    public var authorizationStatus: AuthorizationStatus {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return .notDetermined
        case .restricted:
            return .restricted
        case .denied:
            return .denied
        case .authorizedAlways, .authorized:
            return .authorizedAlways
        case .authorizedWhenInUse:
            return .authorizedWhenInUse
        @unknown default:
            return .unknown
        }
    }

    public func requestAuthorization(for type: AuthorizationType) async -> AuthorizationStatus {
        switch type {
        case .whenInUse:
            locationManager.requestWhenInUseAuthorization()
        case .always:
            locationManager.requestAlwaysAuthorization()
        }
        return authorizationStatus
    }
}
