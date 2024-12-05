//
//  SearchView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cityManager: CityManager
    @EnvironmentObject var cityRefreshListManager: CityRefreshListManager

    @State var citiesList: [String] = []
    @State var city: String = ""

    @State private var showErrorMessage: Bool = false
    @State private var errorMessage: String = ""

    @Binding var selectedTab: Int

    private var filteredCities: [String] {
        if city.isEmpty {
            return citiesList
        } else {
            return citiesList.filter { $0.localizedCaseInsensitiveContains(city) }
        }
    }

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(spacing: 15) {
                VStack(alignment: .leading) {
                    TextField(
                        "Enter a city name",
                        text: $city
                    )
                    .padding(10)
                    .background(Color.white)
                    .foregroundStyle(Color.customColorDark)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                themeManager.isDarkMode ? Color.customColorDark : Color.customColorLight,
                                lineWidth: 2
                            )
                    )
                    .padding(.top, 70)
                    .autocapitalization(.none)
                    .font(.montserrat(15, weight: .regular))
                }
                .frame(width: 350)

                ScrollView {
                    LazyVStack {
                        ForEach(filteredCities, id: \.self) { city in
                            HStack {
                                Text(city)
                                    .font(.montserrat(16, weight: .regular))
                                    .foregroundStyle(Color.white)

                                Spacer()

                                Button {
                                    Task {
                                        let results = try await OpenWeatherApiHTTPClient.asyncFetchWeatherData(for: city)
                                        switch results {
                                            case .success(let weatherData):
                                                let newCity = City(
                                                    id: weatherData.id,
                                                    name: weatherData.name,
                                                    dt: weatherData.dt,
                                                    temperature: weatherData.temperature,
                                                    icon: weatherData.icon,
                                                    cityDescription: weatherData.description,
                                                    latitude: weatherData.latitude,
                                                    longitude: weatherData.longitude
                                                )

                                                cityManager.addCity(newCity)
                                                selectedTab = 0

                                            case .failure(let error):
                                                errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                                        }
                                    }
                                } label: {
                                    Image(systemName: "plus.circle")
                                        .foregroundStyle(Color.blue)
                                        .font(.system(size: 25))
                                }
                            }
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 15)
                            .frame(width: 370)
                            .background(themeManager.isDarkMode ? Color.black.opacity(0.8) : Color.gray.opacity(0.1))
                            .cornerRadius(5)
                        }
                        .background(themeManager.isDarkMode ? Color.dark : Color.light)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                let results = try await CountryAndCityHTTPClient.asyncFetchCities()
                switch results {
                    case .success(let cities):
                        citiesList = cities.data.flatMap { $0.cities }
                    case .failure:
                        break
                }
            }
        }
    }
}

// #Preview {
//    SearchView()
// }
