//
//  CityListView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct CityListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var cityManager: CityManager
    @EnvironmentObject var cityRefreshManager: CityRefreshManager

    // Values To Store Data Gained From Fetching OpenWeatherApi
    @State private var cityId: Int = 0
    @State private var cityName: String = ""
    @State private var cityTemp: Double = 0.0
    @State private var cityIcon: String = ""
    @State private var cityDescription: String = ""
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var showRemoveAllCitiesActionSheet: Bool = false
    @State private var showRemoveCityActionSheet: Bool = false

    @Binding var isDetailActive: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            themeManager.isDarkMode ? Color.dark : Color.light

            // View VStack
            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    // App Name, Current City, Delete and View More Buttons VStack
                    VStack {
                        // App Name, Current City Delete All Cities
                        VStack {
                            HStack(spacing: 0) {
                                if !cityManager.cities.isEmpty {
                                    // Delete All Cities Button
                                    Button {
                                        showRemoveAllCitiesActionSheet = true
                                    } label: {
                                        Image(systemName: "minus.circle")
                                            .font(.system(size: 15))
                                            .foregroundColor(Color.red)
                                    }
                                    .padding(.trailing, 10)
                                    .actionSheet(isPresented: $showRemoveAllCitiesActionSheet) { ActionSheet(
                                        title: Text("Delete all cities"),
                                        message: Text(
                                            "Are you sure you want to delete all city"
                                        ),
                                        buttons: [
                                            .destructive(Text("Delete")) {
                                                cityIcon = ""
                                                cityName = ""

                                                cityManager.removeAllCities()
                                                cityRefreshManager.removeCities()
                                            },
                                            .cancel(Text("Cancel"))
                                        ]
                                    ) }
                                }

                                Text("World")
                                    .font(.montserrat(20, weight: .bold))
                                    .foregroundStyle(Color.blue)
                                    .textCase(.uppercase)

                                Text("Weather App")
                                    .font(.montserrat(20, weight: .bold))
                                    .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                                    .textCase(.uppercase)
                            }
                        }
                        .padding(.top, 30)

                        // Current Weather Icon For City, View More Button, Delete City
                        // Show Stack Only When City Array Isn't Empty. Else Show Message To Search For City
                        if !cityManager.cities.isEmpty {
                            HStack(alignment: .center) {
                                Spacer()

                                VStack(alignment: .center) {
                                    // Weather Symbol For Current City. Shows Symbol When Api Icon Data Matches Name in SymbolsMatch
                                    if let weatherSymbol = symbolsMatch(from: cityIcon) {
                                        HStack {
                                            Spacer()

                                            Image(systemName: weatherSymbol.rawValue)
                                                .font(.system(size: 100))
                                                .symbolRenderingMode(.multicolor)
                                                .background(
                                                    ZStack {
                                                        themeManager.isDarkMode ? Color.black.opacity(0.5)
                                                            .background(.ultraThinMaterial)
                                                            .clipShape(Circle()) : Color.clear.background(.ultraThinMaterial)
                                                            .clipShape(Circle())
                                                    }
                                                    .blur(radius: 100)
                                                )

                                            Spacer()
                                        }
                                    } else {
                                        Text("No City Selected")
                                            .font(.montserrat(25, weight: .bold))
                                            .foregroundStyle(Color.white)
                                    }

                                    // City Name
                                    if !cityName.isEmpty {
                                        Text(cityName)
                                            .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                                            .font(.montserrat(25, weight: .medium))
                                            .padding(.top, 5)
                                    }

                                    // Navigate To CityDetailsView
                                    if !cityName.isEmpty {
                                        NavigationLink(
                                            destination: CityWeatherDetailView(
                                                isDetailActive: $isDetailActive,
                                                cityName: cityName,
                                                description: cityDescription,
                                                latitude: latitude,
                                                longitude: longitude
                                            )
                                        ) {
                                            Text("More Details")
                                                .foregroundStyle(
                                                    themeManager.isDarkMode ? .customColorDark : .customColorLight
                                                )
                                                .padding([.leading, .trailing], 15)
                                                .padding([.top, .bottom], 8)
                                                .font(.montserrat(16, weight: .medium))
                                                .background(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.blue.opacity(0))
                                                )
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .stroke(Color.blue, lineWidth: 2)
                                                )
                                        }
                                    } else {
                                        VStack {
                                            Text("Please click on a city name")
                                                .padding(12)
                                                .foregroundStyle(Color.blue)
                                                .font(.montserrat(16, weight: .medium))
                                        }
                                    }
                                }
                                .padding()

                                Spacer()
                            }
                        } else {
                            VStack(alignment: .center) {
                                Spacer()

                                Text("Search for a city to get started")
                                    .font(.montserrat(18, weight: .bold))
                                    .foregroundStyle(Color.blue)
                                    .textCase(.uppercase)

                                Spacer()
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                }
                .background(themeManager.isDarkMode ? Color.dark : Color.light)

                // List Of Cities Saved In cityManager ObservableObject
                List {
                    ForEach(cityManager.cities) { city in
                        VStack(spacing: 10) {
                            HStack {
                                Text(city.name)
                                    .foregroundStyle(
                                        themeManager.isDarkMode ? Color.customColorLight : Color.blue
                                    )
                                    .font(.montserrat(30, weight: .medium))
                                    .onTapGesture {
                                        // Pass Fetch Data To State Variables
                                        cityId = city.id
                                        cityName = city.name
                                        cityDescription = city.cityDescription
                                        cityIcon = city.icon
                                        latitude = city.latitude
                                        longitude = city.longitude
                                    }

                                Spacer()

                                // Weather Symbol For Current City. Shows Symbol When Api Icon Data Matches Name in SymbolsMatch
                                if let weatherSymbol = symbolsMatch(from: city.icon) {
                                    Image(systemName: weatherSymbol.rawValue)
                                        .font(.system(size: 30))
                                        .symbolRenderingMode(.multicolor)
                                        .background(
                                            ZStack {
                                                Color.clear
                                                    .background(.ultraThinMaterial)
                                                    .clipShape(Circle())
                                            }
                                            .blur(radius: 60)
                                        )
                                } else {
                                    Text("No Icon Found")
                                }
                            }
                            .padding(.bottom, 5)

                            HStack {
                                Text(city.formattedTime)
                                    .foregroundStyle(Color.white)
                                    .font(.montserrat(18, weight: .regular))

                                Spacer()

                                Text(city.cityDescription)
                                    .foregroundStyle(Color.white)
                                    .font(.montserrat(20, weight: .medium))

                                Spacer()

                                Text("\(String(format: "%.0f", city.temperature))°C")
                                    .foregroundStyle(Color.white)
                                    .font(.montserrat(18, weight: .medium))
                            }
                            .padding(.top, 10)
                        }
                        .frame(height: 100)
                        .cornerRadius(5)
                        .listRowBackground(
                            themeManager.isDarkMode ? Color.blue : Color.gray
                                .opacity(0.1)
                        )
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                cityIcon = ""
                                cityName = ""

                                cityManager.removeCity(byID: city.id)
                                cityRefreshManager.removeCity(byName: city.name)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .onMove { indices, newOffset in
                        // Reorder The Cities List By Dragging And Dropping
                        cityManager.cities.move(fromOffsets: indices, toOffset: newOffset)
                    }
                }
                .listStyle(.plain)
                .listRowSpacing(10)
                .padding(5)
            }
        }
    }
}

#Preview {
    // CityListView()
}
