//
//  HomeView.swift
//  CWK2_23_GL
//
//  Created by GirishALukka on 10/03/2023.
//

import SwiftUI
import CoreLocation
import CoreLocationUI
struct Home: View {
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var modelData: ModelData
    // variable used to determine if the app should get the current location of the user
    @State var searchedCity = false
    //variable used to determine if the search view is open
    @State var isSearchOpen: Bool = false
    //variable used to store the location of the data used
    @State var userLocation: String = ""
    @State var showLocationSettingsAlert = false



    var body: some View {
        ZStack {
            Image("background2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            VStack {
                Spacer()
                Spacer()
                HStack {
                    //when this button is pressed, the search view will appear
                    //this will also make the app stop updating the data to match the users current location
                    Button {
                        isSearchOpen = true
                        searchedCity = true
                        
                    }
                    label: {
                        Text("Change Location")
                            .font(.largeTitle)
                            .bold()
                    }
                    //when this button is pressed, the app will resume getting the current user location and update the weather data
                    //accordingly
                    Button {
                        if (locationManager.locationManager.authorizationStatus == .denied || locationManager.locationManager.authorizationStatus == .restricted) {
                            showLocationSettingsAlert = true
                        } else {
                            searchedCity = false
                            Task {
                                await loadCurrentLocationData()
                            }
                        }
                    } label: {
                        //when the current location is turned on (searchedCity == false), the icon will be a circle with an arrow
                        //when the current location is turned off (searchedCity == true), the presivious icon will be slashed
                        Image(systemName: searchedCity ? "location.slash.circle" : "location.circle")
                            .resizable()
                            .frame(width: 50, height: 50)
                    }
                }
                Spacer()
                //The following VStack displays the current location of the user and the formatted date from when the Weather Data was received
                VStack {
                    Spacer()
                    Text(userLocation)
                        .font(.title)
                    Spacer()
                    Text(getFormattedDate(from: modelData.forecast?.current.dt ?? 0, type: 0))
                        .font(.title)
                        .bold()
                    Spacer()
                }
                Spacer()
                //The following VStack displays the temperature, humidity, pressure and the weather condition along with the appropriate weather icon
                VStack {
                    Spacer()
                    Text("Temp: \(modelData.forecast?.current.temp.rounded().formatted() ?? "0")°C")
                    Spacer()
                    Text("Humidity: \(modelData.forecast?.current.humidity ?? 0) %")
                    Spacer()
                    Text("Pressure: \(modelData.forecast?.current.pressure ?? 0) hPa")
                    Spacer()
                    HStack {
                        Label {
                            Text(modelData.forecast?.current.weather[0].weatherDescription.rawValue ?? "test")
                        } icon: {
                            IconFromWebsite(url: modelData.forecast?.current.weather[0].icon ?? "01n.png)")
                        }
                    }
                }
                    .fontWeight(.medium)
                    .font(.system(size: 20))
            }
                .padding()
        }
        //when the view appears, if the current location is turned on, load the Weather Data for the current location of the user
        //if the current location is turned off, it will update the location string
        .onAppear {
            Task {

                if !searchedCity {
                    await loadCurrentLocationData()
                }
                else {
                    userLocation = await modelData.updateLocation()
                }

            }


        }
        //when isSearchOpen, the SearchView will show on screen as a sheet, when this view is dismissed, the updateLoocation function will be called
        .sheet(isPresented: $isSearchOpen) {
            SearchView(isSearchOpen: $isSearchOpen, userLocation: $userLocation)
        }
        .onReceive(modelData.$forecast, perform: { forecast in
            if modelData.forecast != nil {
                        Task {
                            await userLocation = modelData.updateLocation()
                        }
                    }
                })
        .alert(isPresented: $showLocationSettingsAlert) {
                    Alert(
                        title: Text("Location Access Required"),
                        message: Text("Please enable location access for this app in Settings."),
                        primaryButton: .default(Text("Open Settings"), action: openAppSettings),
                        secondaryButton: .cancel()
                    )
                }


    }
    //function used to update the location from the current data
//    func updateLocation() {
//        Task {
//            //the delay has been added to allow the system to load the data
//            //the UI won't be
//            self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
//            print("location updated")
//        }
//    }
    //function used to get the weather data for the user's current location
    //if the user has authorized the access to their location, it will get it and get the Weather Data for it and update the location accordingly
    func loadCurrentLocationData() async {
        if !searchedCity {
            if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.locationManager.authorizationStatus == .authorizedAlways {
                if let lat = locationManager.locationManager.location?.coordinate.latitude, let lon = locationManager.locationManager.location?.coordinate.longitude {
                    try? await modelData.loadData(lat: lat, lon: lon)                }
            }
        }
    }
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }
}


