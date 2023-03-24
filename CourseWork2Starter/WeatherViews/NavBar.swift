//
//  NavBar.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct NavBar: View {

    var body: some View {
        TabView {
            Home()
                .tabItem {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("City")
                }
            }
            CurrentWeatherView()
                .tabItem {
                VStack {
                    Image(systemName: "sun.max")
                    Text("WeatherNow")
                }
            }

            HourlyView()
                .tabItem {
                VStack {
                    Image(systemName: "clock.fill")
                    Text("Hourly Summary")
                }
            }
            ForecastView()
                .tabItem {
                VStack {
                    Image(systemName: "calendar")
                    Text("Forecast")
                }
            }
            PollutionView()
                .tabItem {
                VStack {
                    Image(systemName: "aqi.high")
                    Text("Pollution")
                }
            }
        }.onAppear {
            UITabBar.appearance().isTranslucent = false
        }

    }

}

