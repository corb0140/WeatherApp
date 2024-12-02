//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct CityWeatherDetailView: View {
    @Binding var isDetailActive: Bool

    var cityName: String = ""

    var body: some View {
        Text(cityName)
    }
}

// #Preview {
//    CityWeatherDetailView(cityName: "Ottawa")
// }
