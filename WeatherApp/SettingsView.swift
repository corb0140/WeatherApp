//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cityManager: CityManager
    @EnvironmentObject var cityRefreshManager: CityRefreshManager

    @State private var errorMessage: String = ""

    @AppStorage("refreshInterval") private var refreshInterval: Double = 300.0

    let intervals = [300.0, 600.0, 1800.0, 3600.0]

    @State var timer = Timer.publish(every: 60.0, on: .main, in: .common).autoconnect()

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(spacing: 15) {
                VStack {
                    Text("Switch Theme")
                        .font(.montserrat(18, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .customColorDark : .customColorLight)

                    Toggle("", isOn: $themeManager.isDarkMode)
                        .animation(
                            .easeOut(duration: 0.8),
                            value: themeManager.isDarkMode
                        )
                        .toggleStyle(ThemeManager.CustomToggleStyle())
                        .onTapGesture {
                            themeManager.isDarkMode.toggle()
                        }
                }

                VStack(spacing: 10) {
                    Text("Refresh Interval")
                        .font(.montserrat(18, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .customColorDark : .customColorLight)

                    Text("Current: \(Int(refreshInterval / 60)) minutes")
                        .font(.montserrat(16))
                        .foregroundColor(themeManager.isDarkMode ? .customColorDark : .customColorLight)

                    HStack(spacing: 15) {
                        ForEach(intervals, id: \.self) { interval in
                            Button(action: {
                                updateRefreshInterval(interval)
                            }) {
                                VStack(spacing: 10) {
                                    Text("\(Int(interval / 60))")

                                    Text("mins")
                                }
                                .padding()
                                .background(
                                    interval == refreshInterval
                                        ? Color.blue
                                        : (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3))
                                )
                                .font(.montserrat(15, weight: .medium))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.top, 30)

                NavigationLink(destination: AboutView()) {
                    Text("About")
                        .foregroundStyle(Color.customColorLight)
                        .padding([.leading, .trailing], 55)
                        .padding([.top, .bottom], 15)
                        .font(.montserrat(20, weight: .bold))
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
            .padding()
        }
        .ignoresSafeArea()
        .onReceive(timer, perform: { _ in
            refreshCities()
        })
    }

    private func updateRefreshInterval(_ interval: Double) {
        refreshInterval = interval
        timer = Timer.publish(every: refreshInterval, on: .main, in: .common).autoconnect()
    }

    private func refreshCities() {
        cityManager.removeAllCities()

        for city in cityRefreshManager.citiesRefreshList {
            Task {
                let results = try await OpenWeatherApiHTTPClient.asyncFetchWeatherData(for: city.name)
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

                        await MainActor.run {
                            cityManager.addCity(newCity)
                        }
                    case .failure(let error):
                        await MainActor.run {
                            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                        }
                }
            }
        }
    }
}

#Preview {
//    SettingsView()
}
