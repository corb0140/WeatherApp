//
//  AboutView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var themeManager: ThemeManager

    @State var jump: CGFloat = 0
    @State private var tap: Int = 0

    var body: some View {
        ZStack(alignment: .top) {
            themeManager.isDarkMode ? Color.dark : Color.light

            // App Name
            VStack(alignment: .center, spacing: 35) {
                HStack(spacing: 0) {
                    Text("world")
                        .foregroundStyle(Color.blue)
                    Text("weather.")
                        .foregroundStyle(themeManager.isDarkMode ? Color.light : Color.dark)
                }
                .font(.montserrat(35, weight: .bold))

                // Animation Of Balls Moving Like A Snake
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                        .offset(y: jump)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever(),
                            value: jump
                        )
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .offset(y: jump)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever().delay(0.3),
                            value: jump
                        )
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)
                        .offset(y: jump)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever().delay(0.5),
                            value: jump
                        )
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                        .offset(y: jump)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever().delay(0.7),
                            value: jump
                        )
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 10, height: 10)
                        .offset(y: jump)
                        .animation(
                            .easeInOut(duration: 0.5).repeatForever().delay(0.9),
                            value: jump
                        )
                }

                // Welcome Message
                VStack {
                    HStack {
                        Text("Hey,")
                            .foregroundStyle(Color.blue)
                        Text("Welcome")
                            .foregroundStyle(themeManager.isDarkMode ? Color.light : Color.dark)
                    }

                    Text("To World Weather!")
                        .foregroundStyle(themeManager.isDarkMode ? Color.light : Color.dark)
                }
                .foregroundStyle(Color.customColorLight)
                .font(.montserrat(35, weight: .bold))

                // Description Of App
                VStack(alignment: .leading, spacing: 25) {
                    Text("This is a city weather app, where you can see weather forecast for any city in the world. Get humidity, uv index, temperature, forcast by the hour and more!")
                        .font(.montserrat(15, weight: .regular))
                        .foregroundStyle(themeManager.isDarkMode ? Color.light : Color.dark)

                    Text("Made by Mark Corbin. An aspiring Swift developer @ Algonquin College.")
                        .font(.montserrat(15, weight: .regular))
                        .foregroundStyle(themeManager.isDarkMode ? Color.light : Color.dark)
                }

                // Clickable Image. Switch Image After 3 Clicks
                Image(tap >= 3 ? "babyMark" : "mark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 150)
                    .padding()
                    .onTapGesture {
                        tap = (tap + 1) % 4
                    }

                // Link To Portfolio
                Link(destination: URL(string: "https://portfolio-ruby-nine-59.vercel.app/")!) {
                    HStack {
                        Text("Check out my portfolio")
                            .font(.montserrat(15, weight: .medium))
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                }
            }
            .padding(.top, 120)
            .padding([.leading, .trailing], 20)
            .foregroundStyle(.customColorLight)
            .onAppear {
                jump = -10
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
//    AboutView()
}
