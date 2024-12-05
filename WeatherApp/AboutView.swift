//
//  AboutView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-28.
//

import SwiftUI

struct AboutView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        ZStack(alignment: .top) {
            themeManager.isDarkMode ? Color.dark : Color.light

            VStack(alignment: .center, spacing: 35) {
                HStack(spacing: 0) {
                    Text("world")
                        .foregroundStyle(Color.blue)
                    Text("weather.")
                        .foregroundStyle(Color.white)
                }
                .font(.montserrat(35, weight: .bold))

                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(Color.yellow)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                    Circle()
                        .fill(Color.pink)
                        .frame(width: 10, height: 10)
                }

                VStack {
                    HStack {
                        Text("Hey,")
                            .foregroundStyle(Color.blue)
                        Text("Welcome")
                    }

                    Text("To World Weather!")
                }
                .foregroundStyle(Color.customColorLight)
                .font(.montserrat(35, weight: .bold))

                VStack(alignment: .leading, spacing: 25) {
                    Text("This is a city weather app, where you can see weather forecast for any city in the world. Get humidity, uv index, temperature, forcast by the hour and more!")
                        .font(.montserrat(15, weight: .regular))

                    Text("Made by Mark Corbin. An aspiring Swift developer @ Algonquin College.")
                        .font(.montserrat(15, weight: .regular))
                }

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
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AboutView()
}
