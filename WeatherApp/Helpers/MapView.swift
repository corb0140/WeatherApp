//
//  MapView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-01.
//

import MapKit
import SwiftUI

struct MapView: View {
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var region: MKCoordinateRegion

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        ))
    }

    var body: some View {
        Map(initialPosition: .region(region))
    }
}

// #Preview {
//    MapView()
// }
