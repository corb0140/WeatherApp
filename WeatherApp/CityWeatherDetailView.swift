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

    @State var uvIndex: Double = 0.0
    @State var humidity: Double = 0.0
    @State var windSpeed: Double = 0.0
    @State var hour: [Hourly] = []
    @State var description: String = ""

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

                    VStack(spacing: 50) {
                        VStack {
                            Text(cityName)
                                .foregroundStyle(.white)
                                .font(.montserrat(55, weight: .bold))

                            Text("\(String(format: "%.0f", temperature))°C")
                                .foregroundStyle(Color.white)
                                .font(.montserrat(60, weight: .bold))

                            Text(description)
                                .foregroundStyle(Color.white)
                                .font(.montserrat(40, weight: .medium))
                        }
                        .padding(.top, 20)

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

                        Spacer()

                        VStack(alignment: .leading, spacing: 20) {
                            Text("Today")
                                .font(.montserrat(18, weight: .medium))

                            List(hour, id: \.time) { hourData in
                                HStack(spacing: 40) {
                                    VStack {
                                        Text("\(hourData.temp_c, specifier: "%.0f")°")

                                        AsyncImage(url: URL(string: "https:\(hourData.condition.icon)")) { image in
                                            image
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                        } placeholder: {
                                            ProgressView()
                                        }

                                        Text(hourData.time)
                                    }
                                    .padding([.top, .bottom], 20)
                                    .padding([.leading, .trailing], 25)
                                    .background(Color.black.opacity(0.5))
                                    .cornerRadius(20)
                                    .onAppear {
                                        description = hourData.condition.text
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 50)
                    }
                }
                .onAppear {
                    Task {
                        let results = try await HTTPClient2.asyncFetchWeatherDayData(for: cityName)
                        switch results {
                            case .success(let weatherDayData):
                                uvIndex = weatherDayData.uv
                                windSpeed = weatherDayData.wind
                                humidity = weatherDayData.humidity
                                hour = weatherDayData.hour

                                print(hour)

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
