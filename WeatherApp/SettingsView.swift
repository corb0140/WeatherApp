//
//  SettingsView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    @AppStorage("refreshInterval") private var refreshInterval: Int = 5

    let intervals = [5, 10, 30, 60]

    var body: some View {
        ZStack {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(spacing: 15) {
                VStack(spacing: 10) {
                    Text("Refresh Interval")
                        .font(.montserrat(18, weight: .bold))
                        .foregroundColor(themeManager.isDarkMode ? .customColorDark : .customColorLight)

                    Text("Current: \(refreshInterval) minutes")
                        .font(.montserrat(16))
                        .foregroundColor(themeManager.isDarkMode ? .customColorDark : .customColorLight)

                    HStack(spacing: 15) {
                        ForEach(intervals, id: \.self) { interval in
                            Button(action: {
                                refreshInterval = interval
                                UserDefaults.standard.set(interval, forKey: "refreshInterval")
                            }) {
                                Text("\(interval) min")
                                    .padding()
                                    .background(
                                        interval == refreshInterval
                                            ? Color.blue
                                            : (themeManager.isDarkMode ? Color.gray.opacity(0.6) : Color.gray.opacity(0.3))
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.top, 30)

                NavigationLink(destination: AboutView()) {
                    Text("About")
                        .foregroundStyle(
                            themeManager.isDarkMode ? .customColorDark : .customColorLight
                        )
                        .padding([.leading, .trailing], 25)
                        .padding([.top, .bottom], 12)
                        .font(.montserrat(20, weight: .bold))
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.top, 20)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SettingsView()
}
