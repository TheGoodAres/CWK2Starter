//
//  AirData.swift
//  CourseWork2Starter-main
//
//  Created by Robert-Dumitru Oprea on 28/03/2023.
//

import Foundation
class AirData: ObservableObject {
    @Published var forecast: Forecast?
    @Published var userLocation: String = ""
    let apiKey = "d23f70c3225fd0fa59564d2ffaded0fa"
    init() {
        self.forecast = load("london.json")
    }


    func loadData(lat: Double, lon: Double) async throws -> Forecast {
        let url = URL(string: "http://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(API key}")
        let session = URLSession(configuration: .default)

        let (data, _) = try await session.data(from: url!)

        do {
            print(data)
            let forecastData = try JSONDecoder().decode(Forecast.self, from: data)
            DispatchQueue.main.async {
                self.forecast = forecastData
            }

            return forecastData
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
}
