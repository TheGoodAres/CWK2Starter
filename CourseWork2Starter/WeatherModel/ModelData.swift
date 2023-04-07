import Foundation
class ModelData: ObservableObject {
    @Published var forecast: Forecast?
    @Published var airQuality: AirQuality?
    @Published var locationName  = ""
    private var cacheExpirationDate: Date = Date()
    private var lastFetchedLocation: Location? = nil
    
    let apiKey = "d23f70c3225fd0fa59564d2ffaded0fa"
    init() {
        loadUserDefaults()
    }

    func loadCurrentLocationData(locationManager: LocationManager, searchedCity: Bool) async {
            if !searchedCity {
                if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.locationManager.authorizationStatus == .authorizedAlways {
                    if let lat = locationManager.locationManager.location?.coordinate.latitude, let lon = locationManager.locationManager.location?.coordinate.longitude {
                        try? await loadData(lat: lat, lon: lon)
                    }
                }
            }
        }
    
    func updateLocation() async -> String {
            if let forecast = forecast {
                let locationName = await getLocFromLatLong(lat: forecast.lat, lon: forecast.lon)
                return locationName
            }
            return ""
        }
    
    func loadData(lat: Double, lon: Double) async throws -> Forecast {
        let url = URL(string: "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)")
        let session = URLSession(configuration: .default)

        let (data, _) = try await session.data(from: url!)

        do {
            let forecastData = try JSONDecoder().decode(Forecast.self, from: data)
            DispatchQueue.main.async {
                self.forecast = forecastData
                self.saveToUserDefaults()
            }
            print("loaded weather data")

            return forecastData
        } catch {
            print(error)
            throw error
        }
    }

    func loadAirData(lat: Double, lon: Double) async throws -> AirQuality {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)")
        let session = URLSession(configuration: .default)

        let (data, _) = try await session.data(from: url!)

        do {
            print(data)
            let airData = try JSONDecoder().decode(AirQuality.self, from: data)
            DispatchQueue.main.async {
                self.airQuality = airData
                self.saveToUserDefaults()
            }

            return airData
        } catch {
            print(error)
            throw error
        }
    }

    func load<Forecast: Decodable>(_ filename: String) -> Forecast {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(Forecast.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(Forecast.self):\n\(error)")
        }
    }

    func loadLocalAir<AirQuality: Decodable>(_ filename: String) -> AirQuality {
        let data: Data

        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }

        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(AirQuality.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(AirQuality.self):\n\(error)")
        }
    }

    func saveToUserDefaults() {
        if let encodedForecast = try? JSONEncoder().encode(forecast) {
            UserDefaults.standard.set(encodedForecast, forKey: "forecast")
        }
        if let encodedAirQuality = try? JSONEncoder().encode(airQuality) {
            UserDefaults.standard.set(encodedAirQuality, forKey: "airQuality")
        }

    }
    
    func loadUserDefaults() {
        var forecastAvailable = false
        var airQualityAvailable = false

        var availableUserDefaults: Bool {
            get {
                forecastAvailable && airQualityAvailable
            }
        }


        if let savedForecast = UserDefaults.standard.data(forKey: "forecast") {
            if let decodedItems = try? JSONDecoder().decode(Forecast.self, from: savedForecast) {
                forecast = decodedItems
                forecastAvailable = true
                return
            }
        }
        if let savedAirQuality = UserDefaults.standard.data(forKey: "airQuality") {
            if let decodedItems = try? JSONDecoder().decode(AirQuality.self, from: savedAirQuality) {
                airQuality = decodedItems
                airQualityAvailable = true
                return
            }
        }
        if (!availableUserDefaults) {
            self.forecast = load("london.json")
            self.airQuality = loadLocalAir("air_pollution.json")
        }

    }
}
