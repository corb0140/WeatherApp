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

    @State var slideLeft: CGFloat = 0
    @State var slideRight: CGFloat = 100
    @State var celciusOpacity: CGFloat = 1
    @State var fahrenheitOpacity: CGFloat = 0

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
                    // Map View. Takes Lat And Lon From Latitude and Longitude Variables
                    MapView(latitude: latitude, longitude: longitude)

                    // Background Transparent View
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

                    // City Name, Temperature And Current Weather
                    VStack(spacing: 50) {
                        VStack {
                            Text(cityName)
                                .foregroundStyle(.white)
                                .font(.montserrat(55, weight: .bold))

                            ZStack {
                                Text("\(String(format: "%.0f", temp_C))ºC")
                                    .foregroundStyle(Color.white)
                                    .font(.montserrat(60, weight: .bold))
                                    .offset(x: slideLeft)
                                    .opacity(celciusOpacity)
                                    .animation(.easeInOut(duration: 0.4), value: slideLeft)
                                    .onTapGesture {
                                        isCelsius.toggle()
                                        slideLeft = -100
                                        slideRight = 0
                                        fahrenheitOpacity = 1
                                        celciusOpacity = 0
                                    }

                                Text("\(String(format: "%.0f", temp_F))ºF")
                                    .foregroundStyle(Color.white)
                                    .font(.montserrat(60, weight: .bold))
                                    .offset(x: slideRight)
                                    .opacity(fahrenheitOpacity)
                                    .animation(.easeInOut(duration: 0.4), value: slideRight)
                                    .onTapGesture {
                                        isCelsius.toggle()
                                        slideLeft = 0
                                        slideRight = 100
                                        fahrenheitOpacity = 0
                                        celciusOpacity = 1
                                    }
                            }

                            Text(description)
                                .foregroundStyle(Color.white)
                                .font(.montserrat(40, weight: .bold))
                        }
                        .padding(.top, 20)

                        // UV Index, Wind and Humidity
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

                        // Hourly Weather Report For The Day
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Today")
                                .font(.montserrat(18, weight: .bold))
                                .foregroundStyle(Color.white)
                                .padding(.leading, 25)

                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 20) {
                                    // Loop Through Hour Array Which Holds Hourly Weather Fetch Data From Weather Api
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
                        // Fetch Data from weatherApi And Pass It To Variables
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

#Preview {
//    CityWeatherDetailView()
}
