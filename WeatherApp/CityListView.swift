//
//  CityListView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftData
import SwiftUI

@Model
final class City {
    var id: Int
    var name: String
    var temperature: Double
    var icon: String
    var cityDescription: String
    var latitude: Double
    var longitude: Double

    init(id: Int, name: String, temperature: Double, icon: String, cityDescription: String, latitude: Double, longitude: Double) {
        self.id = id
        self.name = name
        self.temperature = temperature
        self.icon = icon
        self.cityDescription = cityDescription
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct CityListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Query var cities: [City]
    @Environment(\.modelContext) var context
    @State private var showAddCitySheet: Bool = false
    @State private var cityName: String = ""
    @State private var cityTemp: Double = 0.0
    @State private var cityIcon: String = ""
    @State private var latitude: Double = 0
    @State private var longitude: Double = 0
    @State private var showRemoveCitiesActionSheet: Bool = false
    @State private var showRemoveCityActionSheet: Bool = false
    @Binding var isDetailActive: Bool

    var body: some View {
        ZStack(alignment: .topTrailing) {
            themeManager.isDarkMode ? Color.dark : Color.light
            VStack(spacing: 0) {
                HStack {
                    Spacer()

                    VStack(alignment: .trailing) {
                        VStack {
                            Toggle("", isOn: $themeManager.isDarkMode)
                                .animation(
                                    .easeOut(duration: 0.8),
                                    value: themeManager.isDarkMode
                                )
                                .toggleStyle(ThemeManager.CustomToggleStyle())
                                .onTapGesture {
                                    themeManager.isDarkMode.toggle()
                                }
                                .padding(.trailing)
                        }

                        HStack {
                            Spacer()

                            Button {
                                showAddCitySheet = true

                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                            }
                            .sheet(isPresented: $showAddCitySheet) {
                                AddCitySheet(
                                    showAddCitySheet: $showAddCitySheet
                                )
                                .environment(\.modelContext, context)
                                .presentationDetents(
                                    [.fraction(0.5), .medium, .large]
                                )
                                .presentationDragIndicator(.visible)
                            }

                            Button {
                                showRemoveCitiesActionSheet = true

                            } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.title)
                                    .accentColor(.red)
                            }.actionSheet(isPresented: $showRemoveCitiesActionSheet) {
                                ActionSheet(
                                    title: Text("Delete Cities"),
                                    message: Text(
                                        "Are you sure you want to delete all cities"
                                    ),
                                    buttons: [
                                        .destructive(Text("Delete")) {
                                            do {
                                                for city in cities {
                                                    context.delete(city)
                                                }
                                                try context.save()
                                                cityIcon = ""
                                                cityName = ""
                                            } catch {
                                                print("Error deleting cities: \(error)")
                                            }

                                        },
                                        .cancel(Text("Cancel"))
                                    ]
                                )
                            }

                            Text("World Weather App")
                                .font(.montserrat(20, weight: .bold))
                                .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                                .textCase(.uppercase)
                                .padding()

                            Spacer()
                        }

                        HStack(alignment: .center) {
                            Spacer()

                            VStack(alignment: .center) {
                                if let weatherSymbol = symbolsMatch(from: cityIcon) {
                                    Image(systemName: weatherSymbol.rawValue)
                                        .font(.system(size: 100))
                                        .symbolRenderingMode(.multicolor)
                                        .background(
                                            ZStack {
                                                Color.clear
                                                    .background(.ultraThinMaterial)
                                                    .clipShape(Circle())
                                            }
                                            .blur(radius: 100)
                                        )
                                } else {
                                    Text("No Icon Found")
                                }

                                if !cityName.isEmpty {
                                    Text(cityName)
                                        .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                                        .font(.montserrat(25, weight: .medium))
                                        .padding(.top, 5)
                                }

                                if !cityName.isEmpty {
                                    NavigationLink(
                                        destination: CityWeatherDetailView(
                                            isDetailActive: $isDetailActive,
                                            cityName: cityName,
                                            temperature: cityTemp,
                                            latitude: latitude,
                                            longitude: longitude
                                        )
                                    ) {
                                        Text("View Details")
                                            .foregroundStyle(
                                                themeManager.isDarkMode ? .customColorDark : .customColorLight
                                            )
                                            .padding(12)
                                            .font(.montserrat(20, weight: .medium))
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
                                        Text("Please click on city ")
                                            .padding(12)
                                            .foregroundStyle(Color.red)
                                            .font(.system(size: 16, weight: .medium))
                                    }
                                }
                            }
                            .padding()

                            Spacer()
                        }
                    }
                }
                .background(themeManager.isDarkMode ? Color.dark : Color.light)

                List(cities) {
                    city in
                    VStack(spacing: 0) {
                        HStack {
                            Text(city.name)
                                .foregroundStyle(Color.blue)
                                .font(.montserrat(22, weight: .medium))

                            Spacer()
                        }

                        HStack {
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(city.icon)@2x.png")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            } placeholder: {
                                ProgressView()
                            }

                            Spacer()

                            Text(city.cityDescription)
                                .foregroundStyle(Color.white)
                                .font(.montserrat(20, weight: .medium))

                            Spacer()

                            Text("\(String(format: "%.0f", city.temperature))°C")
                                .foregroundStyle(Color.white)
                                .font(.montserrat(20, weight: .medium))
                        }
                        .padding(.top, 10)
                    }
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 10)
                    .background(themeManager.isDarkMode ? .light : Color.gray.opacity(0.1))
                    .cornerRadius(20)
                    .listRowBackground(themeManager.isDarkMode ? Color.dark : Color.light)
                    .listRowSeparator(.hidden)
                    .onTapGesture {
                        cityName = city.name
                        cityTemp = city.temperature
                        cityIcon = city.icon
                        latitude = city.latitude
                        longitude = city.longitude
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
                .background(themeManager.isDarkMode ? Color.dark : Color.light)
            }
        }
    }
}

// #Preview {
//    CityListView()
// }
