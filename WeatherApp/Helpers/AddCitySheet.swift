//
//  AddCitySheet.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-30.
//

import SwiftUI

struct AddCitySheet: View {
    var addCity: (City) -> Void

    @Binding var showAddCitySheet: Bool
    @State private var name: String = ""

    @State private var showErrorMessage: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Section(header: Text("Add City")
                .font(.montserrat(40, weight: .bold))
                .fontWeight(.bold)
                .foregroundColor(.customColorDark)
                .padding(5)
            ) {
                VStack(alignment: .leading, spacing: 15) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Enter A City Name", text: $name)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(Color.customColorDark, lineWidth: 2)
                            )
                            .autocapitalization(.none)
                            .font(.montserrat(15, weight: .regular))
                    }

                    // Add and cancel buttons HStack
                    HStack(alignment: .center) {
                        Spacer()
                        // Add city button
                        Button(
                            action: {
                                Task {
                                    guard !name.isEmpty else {
                                        showErrorMessage = true
                                        return
                                    }

                                    let results = try await OpenWeatherApiHTTPClient.asyncFetchWeatherData(for: name)
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

                                            addCity(newCity)
                                            showAddCitySheet = false

                                        case .failure(let error):
                                            errorMessage = "Failed to fetch weather data: \(error.localizedDescription)"
                                    }
                                }

                            }) {
                                Text("Add City")
                                    .font(.subheadline)
                                    .padding(9)
                                    .foregroundColor(.white)
                                    .frame(width: 120)
                            }
                            .padding(4)
                            .frame(width: 150)
                            .background(Color.blue)
                            .cornerRadius(5)
                            .alert(
                                "Please enter a name", isPresented: $showErrorMessage

                            ) {
                                Button("OK", role: .cancel) {}
                            }

                        // Cancel button
                        Button(action: {
                            showAddCitySheet = false
                        }) {
                            Text("Cancel")
                                .font(.montserrat(15, weight: .medium))
                                .padding(9)
                                .foregroundColor(.white)
                                .frame(width: 120)
                        }
                        .padding(4)
                        .frame(width: 150)
                        .background(.customColorDark)
                        .cornerRadius(5)

                        Spacer()
                    }
                    .padding(10)
                }
            }
            .padding()
        }
    }
}

// #Preview {
//    AddCitySheet()
// }
