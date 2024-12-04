//
//  SearchView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State var citiesList: [String] = []
    @State var city: String = ""

    private var filteredCities: [String] {
        if city.isEmpty {
            return citiesList
        } else {
            return citiesList.filter { $0.localizedCaseInsensitiveContains(city) }
        }
    }

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(spacing: 15) {
                VStack(alignment: .leading) {
                    TextField(
                        "Enter a city name",
                        text: $city
                    )
                    .padding(10)
                    .foregroundStyle(Color.customColorLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(
                                themeManager.isDarkMode ? Color.customColorDark : Color.customColorLight,
                                lineWidth: 2
                            )
                    )
                    .padding(.top, 70)
                    .autocapitalization(.none)
                    .font(.montserrat(15, weight: .regular))
                }
                .frame(width: 350)

                ScrollView {
                    LazyVStack {
                        ForEach(filteredCities, id: \.self) { city in
                            HStack(spacing: 5) {
                                Text(city)
                                    .font(.montserrat(16, weight: .regular))
                                    .foregroundStyle(Color.white)

                                Spacer()

                                Image(systemName: "plus")
                                    .foregroundStyle(Color.blue)
                            }
                            .padding([.leading, .trailing], 20)
                            .padding([.top, .bottom], 10)
                            .frame(width: 370)
                            .background(themeManager.isDarkMode ? .light : Color.gray.opacity(0.1))
                            .cornerRadius(5)
                            .listRowBackground(themeManager.isDarkMode ? Color.dark : Color.light)
                            .listRowSeparator(.hidden)
                        }
                        .scrollContentBackground(.hidden)
                        .listStyle(.plain)
                        .background(themeManager.isDarkMode ? Color.dark : Color.light)
                    }
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                let results = try await CountryAndCityHTTPClient.asyncFetchCities()
                switch results {
                    case .success(let cities):
                        citiesList = cities.data.flatMap { $0.cities }
                    case .failure:
                        break
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
