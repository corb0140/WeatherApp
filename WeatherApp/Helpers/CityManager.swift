//
//  CityManager.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-03.
//

import Foundation
import SwiftUI

class City: Identifiable {
    var id: Int
    var name: String
    var dt: Int
    var temperature: Double
    var icon: String
    var cityDescription: String
    var latitude: Double
    var longitude: Double

    init(id: Int, name: String, dt: Int, temperature: Double, icon: String, cityDescription: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.dt = dt
        self.temperature = temperature
        self.icon = icon
        self.cityDescription = cityDescription
        self.latitude = latitude
        self.longitude = longitude
    }

    var formattedTime: String {
        let date = Date(timeIntervalSince1970: TimeInterval(dt))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

class CityManager: ObservableObject {
    @Published var cities: [City] = []

    func addCity(_ city: City) {
        if !cities.contains(where: { $0.name.caseInsensitiveCompare(city.name) == .orderedSame }) {
            cities.append(city)
        }
    }

    func removeCity(byID id: Int) {
        cities.removeAll { $0.id == id }
    }

    func removeAllCities() {
        cities.removeAll()
    }
}
