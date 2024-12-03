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

// other weather api

struct OtherWeatherResponse: Codable {
    let forecast: Forecast
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let day: Day
}

struct Day: Codable {
    let maxwind_mph: Double
    let avghumidity: Double
    let uv: Double
}

struct WeatherDayData: Identifiable {
    let id: UUID
    let uv: Double
    let wind: Double
    let humidity: Double

    init(from response: OtherWeatherResponse) {
        self.id = UUID()
        self.uv = response.forecast.forecastday.first?.day.uv ?? 0.0
        self.wind = response.forecast.forecastday.first?.day.maxwind_mph ?? 0.0
        self.humidity = response.forecast.forecastday.first?.day.avghumidity ?? 0.0
    }
}

enum HTTPClient2 {
    static func asyncFetchWeatherDayData(for city: String) async throws -> Result<WeatherDayData, Error> {
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=0f1ef32d400b4032afe02431240902&q=\(city)&days=1&aqi=no&alerts=no")
        else {
            return .failure(URLError(.badURL))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let otherWeatherResponse = try JSONDecoder().decode(OtherWeatherResponse.self, from: data)
            let weatherData = WeatherDayData(from: otherWeatherResponse)
            return .success(weatherData)
        } catch {
            print("Error decoding weather data: \(error)")
            return .failure(error)
        }
    }
}
