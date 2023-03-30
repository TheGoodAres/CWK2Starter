//
//  AirData.swift
//  CourseWork2Starter-main
//
//  Created by Robert-Dumitru Oprea on 29/03/2023.
//

import Foundation
class AirData: ObservableObject {
    @Published var airQuality: AirQuality?
    @Published var userLocation: String = ""
    let apiKey = "d23f70c3225fd0fa59564d2ffaded0fa"
    init() {
        self.airQuality = load("air_pollution.json")
    }


    func loadData(lat: Double, lon: Double) async throws -> AirQuality {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&units=metric&appid=\(apiKey)")
        let session = URLSession(configuration: .default)

        let (data, _) = try await session.data(from: url!)

        do {
            //print(data)
            let airData = try JSONDecoder().decode(AirQuality.self, from: data)
            DispatchQueue.main.async {
                self.airQuality = airData
                print(airData.self)
            }

            return airData
        } catch {
            print(error)
            throw error
        }
    }

    func load<AirQuality: Decodable>(_ filename: String) -> AirQuality {
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
}
