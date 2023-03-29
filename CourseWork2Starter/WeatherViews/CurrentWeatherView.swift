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
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(locationString)
                Spacer()
                //          Temperature Info
                VStack {
                    Text("\((Int)(modelData.forecast!.current.temp))ºC")
                        .padding()
                        .font(.largeTitle)
                    HStack {
                        IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png")
                        Text(modelData.forecast!.current.weather[0].weatherDescription.rawValue.capitalized)
                            .foregroundColor(.black)
                    }
                    HStack {
                        Text("H: ºC")
                        Text("L: ºC")
                    }
                    Text("Feels Like: \((Int)(modelData.forecast!.current.feelsLike))ºC")
                        .foregroundColor(.black)
                    HStack {
                        Text("Wind Speed: \(modelData.forecast!.current.windSpeed.formatted())m/s")
                        Text("Direction: \(convertDegToCardinal(deg:modelData.forecast!.current.windDeg))")
                    }
                    HStack {
                        Text("Humidity: \(modelData.forecast!.current.humidity)%")
                        Text("Pressure: \(modelData.forecast!.current.pressure) hPg")
                    }
                    HStack{
                        // TODO: find sunrise and sunset images
                        Image(systemName: "minus")
                        Text(getFormattedDate(from: modelData.forecast!.current.sunset ?? 0, type: 1))
                        Image(systemName: "plus")
                        Text(getFormattedDate(from: modelData.forecast!.current.sunrise ?? 0, type: 1))
                    }
                }
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
