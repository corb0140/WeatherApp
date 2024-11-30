//
//  ThemeChangeView.swift
//  WeatherApp
//
//  Created by Mark Corbin on 2024-11-30.
//

import SwiftUI

class ThemeManager: ObservableObject {
    @Published var isDarkMode: Bool = false
}

struct ThemeChangeView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        VStack {
            Toggle("", isOn: $themeManager.isDarkMode)
                .toggleStyle(CustomToggleStyle())
        }
    }
}

struct CustomToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .foregroundColor(configuration.isOn ? .black : .white)
                .frame(width: 90, height: 40)

            Image(systemName: configuration.isOn ? "sun.max.fill" : "moon.fill")
                .foregroundColor(configuration.isOn ? .white : .black)
                .font(.title2)
                .offset(x: configuration.isOn ? -20 : 20)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.8)) {
                configuration.isOn.toggle()
            }
        }
    }
}

#Preview {
    ThemeChangeView()
        .environmentObject(ThemeManager())
}
