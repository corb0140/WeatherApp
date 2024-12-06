import Foundation

// openweatherapi
struct WeatherResponse: Codable {
    let main: MainWeather
    let weather: [WeatherCondition]
    let name: String
    let id: Int
    let dt: Int
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
    let dt: Int
    let temperature: Double
    let icon: String
    let description: String
    let main: String
    let latitude: Double
    let longitude: Double

    init(from response: WeatherResponse) {
        self.id = response.id
        self.name = response.name
        self.dt = response.dt
        self.temperature = response.main.temp
        self.icon = response.weather.first?.icon ?? ""
        self.description = response.weather.first?.description ?? ""
        self.main = response.weather.first?.main ?? ""
        self.latitude = response.coord.lat
        self.longitude = response.coord.lon
    }
}

enum OpenWeatherApiHTTPClient {
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

// weatherapi
struct OtherWeatherResponse: Codable {
    let forecast: Forecast
    let current: Current
}

struct Current: Codable {
    let temp_c: Double
    let temp_f: Double
    let wind_mph: Double
    let humidity: Double
    let uv: Double
}

struct Forecast: Codable {
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    let hour: [Hourly]
}

struct Hourly: Codable {
    let time: String
    let temp_c: Double
    let condition: Condition
}

struct Condition: Codable {
    let text: String
    let icon: String
}

struct WeatherDayData: Identifiable {
    let id: UUID
    let uv: Double
    let wind: Double
    let humidity: Double
    let hour: [Hourly]
    let temp_c: Double
    let temp_f: Double

    init(from response: OtherWeatherResponse) {
        self.id = UUID()
        self.uv = response.current.uv
        self.wind = response.current.wind_mph
        self.humidity = response.current.humidity
        self.hour = response.forecast.forecastday.first?.hour ?? []
        self.temp_c = response.current.temp_c
        self.temp_f = response.current.temp_f
    }
}

enum WeatherApiHTTPClient {
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

// countries & cities

struct CityResponse: Codable {
    let data: [Data]
    let msg: String
}

struct Data: Codable {
    let cities: [String]
}

struct CityResponseList: Codable {
    let msg: String
    let data: [Data]

    init(from response: CityResponse) {
        self.msg = response.msg
        self.data = response.data
    }
}

enum CountryAndCityHTTPClient {
    static func asyncFetchCities() async throws -> Result<CityResponseList, Error> {
        guard let url = URL(string: "https://countriesnow.space/api/v0.1/countries")
        else {
            return .failure(URLError(.badURL))
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let cityResponse = try JSONDecoder().decode(CityResponse.self, from: data)
            let cityResponseData = CityResponseList(from: cityResponse)
            return .success(cityResponseData)
        } catch {
            print("Error decoding city data: \(error)")
            return .failure(error)
        }
    }
}
