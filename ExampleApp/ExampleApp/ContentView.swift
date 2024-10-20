//
//  ContentView.swift
//  ExampleApp
//
//  Created by Alvin He on 20/10/2024.
//

import AsyncLocationLoader
import CoreLocation
import SwiftUI

struct ContentView: View {
    private let locationManager: AsyncLocationManaging
    @State private var authorizationStatus: AuthorizationStatus

    public init(
        locationManager: AsyncLocationManaging = AsyncLocationManager(locationManager: CLLocationManager())
    ) {
        self.locationManager = locationManager
        self.authorizationStatus = locationManager.authorizationStatus
    }

    var body: some View {
        VStack(spacing: 16) {
            authorizationStatusText
            if authorizationStatus == .notDetermined {
                requestWhenInUseAccessButton

            }
            if authorizationStatus == .authorizedWhenInUse {
                requestAlwaysAccessButton
            }
        }
        .navigationTitle("Example App")
        .task {
            for await status in locationManager.authorizationStatusStream {
                authorizationStatus = status
            }
        }
    }

    private var authorizationStatusText: Text {
        return Text("Authorization Status: ").bold()
        + Text("\(authorizationStatus)").foregroundStyle(.indigo)
    }

    private var requestWhenInUseAccessButton: some View {
        Button("Request .whenInUse Access") {
            locationManager.requestAuthorization(for: .whenInUse)
        }
        .tint(.white)
        .padding()
        .background(Color.indigo.clipShape(RoundedRectangle(cornerRadius: 16)))
    }

    private var requestAlwaysAccessButton: some View {
        Button("Request .always Access") {
            locationManager.requestAuthorization(for: .always)
        }
        .tint(.white)
        .padding()
        .background(Color.indigo.clipShape(RoundedRectangle(cornerRadius: 16)))
    }
}

#Preview {
    ContentView()
}
