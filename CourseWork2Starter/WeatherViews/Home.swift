//
//  HomeView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 10/03/2023.
//

import SwiftUI
import CoreLocation

struct Home: View {

    @EnvironmentObject var modelData: ModelData
    @State var isSearchOpen: Bool = false
    @State var userLocation: String = ""


    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Button { isSearchOpen = true}
                label: {
                    Text("Change Location")
                        .font(.largeTitle)
                }
                Spacer()
                VStack {
                    Spacer()
                    Text(userLocation)
                        .font(.title)
                    Spacer()
                    Text(getFormattedDate(from: modelData.forecast?.current.dt ?? 0, type:0))
                        .font(.title)
                        .bold()
                    Spacer()
                }
                Spacer()
                VStack {
                    Spacer()
                    Text("Temp: \(modelData.forecast?.current.temp.rounded().formatted() ?? "0")°C")
                    Spacer()
                    Text("Humidity: \(modelData.forecast?.current.humidity ?? 0) %")
                    Spacer()
                    Text("Pressure: \(modelData.forecast?.current.pressure ?? 0) hPa")
                    Spacer()
                    HStack {
                        IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png)")
                        Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue ?? "test")
                    }
                }
                .bold()
            }
                .padding()
        }
            .onAppear {
                Task{
                    self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
                }
        }
            .sheet(isPresented: $isSearchOpen, onDismiss: updateLocation) {
                SearchView(isSearchOpen: $isSearchOpen, userLocation: $userLocation)
            }
            

    }
    func updateLocation() {
        Task{
            
            try await Task.sleep(nanoseconds: 3_000_000_000)
            self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
            print("location updated")
        }
    }
}


