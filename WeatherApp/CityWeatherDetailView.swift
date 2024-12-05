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
    @State var description: String = ""
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0

    @State private var errorMessage: String = ""

    @State var uvIndex: Double = 0.0
    @State var humidity: Double = 0.0
    @State var windSpeed: Double = 0.0
    @State var hour: [Hourly] = []
    @State var temp_C: Double = 0.0
    @State var temp_F: Double = 0.0

    @State private var isCelsius: Bool = true

    var body: some View {
        NavigationView {
            if let color = colorsMatch(from: Int(temp_C)) {
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

                            Text("\(String(format: "%.0f", isCelsius ? temp_C : temp_F))°\(isCelsius ? "C" : "F")")
                                .foregroundStyle(Color.white)
                                .font(.montserrat(60, weight: .bold))
                                .onTapGesture {
                                    isCelsius.toggle()
                                }

                            Text(description)
                                .foregroundStyle(Color.white)
                                .font(.montserrat(40, weight: .bold))
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
                                .font(.montserrat(18, weight: .bold))
                                .foregroundStyle(Color.white)
                                .padding(.leading, 25)

                            // future reference - fix so it shows current hourly and next 6 hours
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    ForEach(hour, id: \.time) { hourData in
                                        VStack {
                                            Text("\(hourData.temp_c, specifier: "%.0f")°")
                                                .foregroundStyle(Color.white)

                                            AsyncImage(url: URL(string: "https:\(hourData.condition.icon)")) { image in
                                                image
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                            } placeholder: {
                                                ProgressView()
                                            }

                                            let timeOnly = hourData.time.split(separator: " ").last ?? ""
                                            Text(String(timeOnly))
                                                .foregroundStyle(Color.white)
                                        }
                                        .padding([.top, .bottom], 20)
                                        .padding([.leading, .trailing], 25)
                                        .background(Color.black.opacity(0.6))
                                        .cornerRadius(20)
                                    }
                                }
                            }
                            .padding([.leading, .trailing], 20)
                        }
                        .padding(.bottom, 50)
                    }
                }
                .onAppear {
                    Task {
                        let results = try await WeatherApiHTTPClient.asyncFetchWeatherDayData(for: cityName)
                        switch results {
                            case .success(let weatherDayData):
                                uvIndex = weatherDayData.uv
                                windSpeed = weatherDayData.wind
                                humidity = weatherDayData.humidity
                                hour = weatherDayData.hour
                                temp_C = weatherDayData.temp_c
                                temp_F = weatherDayData.temp_f

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
