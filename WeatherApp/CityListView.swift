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
    var name: String
    var degree: String
    var image: String

    init(name: String, degree: String, image: String) {
        self.name = name
        self.degree = degree
        self.image = image
    }
}

struct CityListView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @Query var cities: [City]
    @Environment(\.modelContext) var context

    var body: some View {
        ZStack(alignment: .topTrailing) {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(spacing: 0) {
                Spacer()
                    .frame(height: 60)

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
                                let city = City(name: "other", degree: "12º", image: "test")

                                do {
                                    context.insert(city)
                                    try context.save()
                                } catch {
                                    print("Error saving city: \(error)")
                                }

                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title)
                            }

                            Text("World Weather App")
                                .font(.montserrat(20, weight: .bold))
                                .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                                .textCase(.uppercase)
                                .padding()

                            Spacer()
                        }
                    }
                }
                .background(themeManager.isDarkMode ? Color.dark : Color.light)
                .padding(.bottom, 8)

                NavigationStack {
                    List(cities) {
                        city in VStack {
                            Text(city.name)
                                .foregroundStyle(themeManager.isDarkMode ? .light : .dark)
                        }
                        .listRowBackground(themeManager.isDarkMode ? Color.dark : Color.light)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                    .background(themeManager.isDarkMode ? Color.dark : Color.light)
                }
                .padding(.top)
            }
        }
        .ignoresSafeArea()
    }
}

// #Preview {
//    CityListView()
// }
