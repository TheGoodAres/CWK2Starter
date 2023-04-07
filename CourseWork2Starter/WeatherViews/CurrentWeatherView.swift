//
//  Conditions.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct CurrentWeatherView: View {
    @EnvironmentObject var modelData: ModelData

    @State var locationString: String = "No location"

    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(locationString)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding()
                Spacer()
                
                // Temperature Info
                VStack(spacing:50) {
                    Text("\((Int)(modelData.forecast!.current.temp))ºC")
                        .padding()
                        .font(.largeTitle)
                    VStack(spacing:30) {
                        HStack {
                            Label {
                                Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)
                                    .foregroundColor(.black)

                            } icon: {
                                IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                            }
                        }
                        VStack(spacing: 10) {
                            HStack {
                                Spacer()
                                Text("H: \(modelData.forecast?.daily[0].temp.max.rounded().formatted() ?? "0") ºC")
                                Spacer()
                                Text("L: \(modelData.forecast?.daily[0].temp.min.rounded().formatted() ?? "0") ºC")
                                Spacer()
                            }
                            Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                                .foregroundColor(.black)
                        }
                        Group {
                            VStack(spacing: 40) {

                                HStack {
                                    Spacer()
                                    Text("Wind Speed: \(modelData.forecast!.current.windSpeed.formatted())m/s")
                                    Spacer()
                                    Text("Direction: \(convertDegToCardinal(deg: modelData.forecast!.current.windDeg))")
                                    Spacer()
                                }

                                HStack {
                                    Spacer()
                                    Text("Humidity: \(modelData.forecast!.current.humidity)%")
                                    Spacer()
                                    Text("Pressure: \(modelData.forecast!.current.pressure) hPg")
                                    Spacer()
                                }
                            }
                        }
                        .fontWeight(.medium)
                        HStack {
                            Spacer()
                            Image(systemName: "sunset.fill").renderingMode(.original)
                            Text(getFormattedDate(from: modelData.forecast!.current.sunset ?? 0, type: 1))
                            Spacer()
                            Image(systemName: "sunrise.fill").renderingMode(.original)
                            Text(getFormattedDate(from: modelData.forecast!.current.sunrise ?? 0, type: 1))
                            Spacer()
                        }

                    }
                }
                .font(.system(size:20))
                Spacer()
            }
        }
            .task {
            locationString = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
        }
    }
}

struct Conditions_Previews: PreviewProvider {
    static var previews: some View {
        CurrentWeatherView()
            .environmentObject(ModelData())
    }
}
