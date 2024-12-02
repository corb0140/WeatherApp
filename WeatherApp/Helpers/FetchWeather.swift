import Foundation

struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
    let name: String
    let id: Int
    let coord: WeatherCoordinates
}

struct MainWeather: Codable {
    let temp: Double
}

struct WeatherCoordinates: Codable {
    let lat: Double
    let lon: Double
}

struct WeatherCondition: Codable {
    let icon: String
    let description: String
    let main: String
}

struct WeatherData: Identifiable {
    let id: Int
    let name: String
    let temperature: Double
    let icon: String
    let description: String
    let main: String
    let latitude: Double
    let longitude: Double

    init(from response: WeatherResponse) {
        self.id = response.id
        self.name = response.name
        self.temperature = response.main.temp
        self.icon = response.weather.first?.icon ?? ""
        self.description = response.weather.first?.description ?? ""
        self.main = response.weather.first?.main ?? ""
        self.latitude = response.coord.lat
        self.longitude = response.coord.lon
    }
}

enum HTTPClient {
    static func asyncFetchWeatherData(for city: String) async throws -> Result<WeatherData, Error> {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=e312cd37938b1616f1cd19dd89e7325a") else {
            return .failure(URLError(.badURL))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let weatherResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            let weatherData = WeatherData(from: weatherResponse)
            return .success(weatherData)
        } catch {
            print("Error decoding weather data: \(error)")
            return .failure(error)
        }
    }
}
