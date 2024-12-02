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

    var body: some View {
        NavigationView {
            if let color = colorsMatch(from: 35) {
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

                    VStack(spacing: -5) {
                        Spacer()

                        HStack {
                            HStack {
                                VStack(alignment: .center, spacing: 10) {
                                    HStack(spacing: 5) {
                                        Image(systemName: "sun.max.fill")

                                        Text("UV Index")
                                            .font(.montserrat(12, weight: .medium))
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
                                            .font(.montserrat(12, weight: .medium))
                                    }

                                    Text("12 m/s")
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
                                            .font(.montserrat(12, weight: .medium))
                                    }

                                    Text("49%")
                                        .font(.montserrat(15, weight: .medium))
                                }
                                .foregroundStyle(.white)
                            }
                            .padding()
                            .frame(width: 320, height: 150)
                            .background(color.color)
                            .cornerRadius(20)
                        }
                        .padding()
                        .frame(width: 360, height: 200)
                        .background(Color.white)
                        .cornerRadius(20)

                        HStack {
                            HStack {}
                                .padding()
                                .frame(width: 320, height: 150)
                                .background(color.color)
                                .cornerRadius(20)
                        }
                        .padding()
                        .frame(width: 360, height: 200)
                        .background(Color.white)
                        .cornerRadius(20)
                    }
                    .padding(.bottom, 70)
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
