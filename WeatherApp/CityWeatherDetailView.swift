//
//  CityWeatherDetailView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import MapKit
import SwiftUI

struct CityWeatherDetailView: View {
    @Binding var isDetailActive: Bool

    @State var cityName: String = ""
    @State var temperature: Double = 0.0
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0

    @State private var errorMessage: String = ""

//    @State var id: UUID
    @State var uvIndex: Double = 0.0
    @State var humidity: Double = 0.0
    @State var windSpeed: Double = 0.0

    var body: some View {
        NavigationView {
            if let color = colorsMatch(from: Int(humidity)) {
                ZStack(alignment: .top) {
                    MapView(latitude: latitude, longitude: longitude)

                    VStack {}
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .black.opacity(0.20), location: 0.2),
                                    .init(color: color.color, location: 0.9)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )

                    VStack {
                        Text(cityName)
                            .foregroundStyle(.white)
                            .font(.montserrat(55, weight: .bold))

                        Text("\(String(format: "%.0f", temperature))°C")
                            .foregroundStyle(Color.white)
                            .font(.montserrat(60, weight: .bold))
                    }
                    .padding(.top, 20)

                    VStack(spacing: 5) {
                        Spacer()

                        HStack {
                            VStack(alignment: .center, spacing: 10) {
                                HStack(spacing: 5) {
                                    Image(systemName: "sun.max.fill")

                                    Text("UV Index")
                                        .font(.montserrat(15, weight: .medium))
                                }

                                Text("0")
                                    .font(.montserrat(15, weight: .medium))
                            }
                            .foregroundStyle(.white)

                            Spacer()

                            Rectangle()
                                .frame(width: 2, height: 60)
                                .foregroundStyle(Color.white.opacity(0.4))

                            Spacer()

                            VStack(alignment: .center, spacing: 10) {
                                HStack(spacing: 5) {
                                    Image(systemName: "wind")

                                    Text("Wind")
                                        .font(.montserrat(15, weight: .medium))
                                }

                                Text(String(windSpeed))
                                    .font(.montserrat(15, weight: .medium))
                            }
                            .foregroundStyle(.white)

                            Spacer()

                            Rectangle()
                                .frame(width: 2, height: 60)
                                .foregroundStyle(Color.white.opacity(0.4))

                            Spacer()

                            VStack(alignment: .center, spacing: 10) {
                                HStack(spacing: 5) {
                                    Image(systemName: "humidity.fill")
                                    Text("Humidity")
                                        .font(.montserrat(15, weight: .medium))
                                }

                                Text(String(humidity))
                                    .font(.montserrat(15, weight: .medium))
                            }
                            .foregroundStyle(.white)
                        }
                        .padding()
                        .frame(width: 360, height: 100)
                        .background(color.color)
                        .cornerRadius(20)
                    }
                    .padding(.bottom, 70)
                }
                .onAppear {
                    Task {
                        let results = try await HTTPClient2.asyncFetchWeatherDayData(for: cityName)
                        switch results {
                            case .success(let weatherDayData):
//                                id = weatherDayData.id
                                uvIndex = weatherDayData.uv
                                windSpeed = weatherDayData.wind
                                humidity = weatherDayData.humidity

                                print(weatherDayData.humidity)

                            case .failure(let error):
                                errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                        }
                    }
                }
                .navigationBarHidden(true)

            } else {
                Text("No Color Match")
            }
        }
    }
}

// #Preview {
//    CityWeatherDetailView(cityName: "Ottawa")
// }
