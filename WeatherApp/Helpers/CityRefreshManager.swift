//
//  CityNameManager.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-04.
//

import Foundation
import SwiftUI

class CityName: Identifiable {
    var id: UUID
    var name: String

    init(id: Int, name: String) {
        self.id = UUID()
        self.name = name
    }
}

class CityRefreshManager: ObservableObject {
    @Published var citiesRefreshList: [CityName] = []

    func addCityToList(_ cityName: CityName) {
        if !citiesRefreshList.contains(where: { $0.name.caseInsensitiveCompare(cityName.name) == .orderedSame }) {
            citiesRefreshList.append(cityName)
        }
    }

    func removeCities() {
        citiesRefreshList.removeAll()
    }

    func removeCity(byName name: String) {
        citiesRefreshList.removeAll { $0.name.caseInsensitiveCompare(name) == .orderedSame }
    }
}
