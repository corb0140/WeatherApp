//
//  CityNameManager.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-12-04.
//

import Foundation
import SwiftUI

class CityName: Identifiable {
    var id: Int
    var name: String

    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

class CityRefreshListManager: ObservableObject {
    @Published var citiesRefreshList: [CityName] = []

    func addCityToList(_ cityName: CityName) {
        citiesRefreshList.append(cityName)
    }

    // future reference - make sure you can't add same city

    // future reference - create a remove function
}
