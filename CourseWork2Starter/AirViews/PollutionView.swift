//
//  PollutionView.swift
//  Coursework2
//
//  Created by GirishALukka on 30/12/2022.
//

import SwiftUI

struct PollutionView: View {
    @EnvironmentObject var modelData: ModelData
    @State var userLocation: String = ""

    var body: some View {

        ZStack {
            Image("background")
                .resizable()
            // Use ZStack for background images

            VStack {
                VStack(spacing: 50) {
                    Spacer()
                    Text(userLocation)
                        .font(.largeTitle)
                        .fontWeight(.medium)

                    // Temperature Info
                    VStack(spacing: 50) {
                        Text("\((Int)(modelData.forecast!.current.temp))ºC")
                            .padding()
                            .font(.largeTitle)
                        VStack(spacing: 30) {
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

                            VStack(spacing: 40) {

                                Text("Air Quality Data:")
                            }
                                .font(.system(size: 40, weight: .heavy))

                                .fontWeight(.medium)
                            HStack {
                                Label {
                                    Text("\(modelData.airQuality?.list[0].components.no2.rounded().formatted() ?? "0.0")")
                                } icon: {
                                    Image("so2")
                                        .resizable()
                                        .scaledToFit()
                                }.labelStyle(VerticalLabelStyle())
                                    .padding()

                                Label {
                                    Text("\(modelData.airQuality?.list[0].components.no.rounded().formatted() ?? "0.0")")
                                } icon: {
                                    Image("no")
                                        .resizable()
                                        .scaledToFit()
                                }.labelStyle(VerticalLabelStyle())
                                    .padding()

                                Label {
                                    Text("\(modelData.airQuality?.list[0].components.co.rounded().formatted() ?? "0.0")")
                                } icon: {
                                    Image("voc")
                                        .resizable()
                                        .scaledToFit()
                                }.labelStyle(VerticalLabelStyle())
                                    .padding()

                                Label {
                                    Text("\(modelData.airQuality?.list[0].components.pm2_5.rounded().formatted() ?? "0.0")")
                                } icon: {
                                    Image("pm")
                                        .resizable()
                                        .scaledToFit()
                                }.labelStyle(VerticalLabelStyle())
                                    .padding()
                            }
                            

                        }
                    }
                        .font(.system(size: 20))
                    Spacer()
                }

            }


                .foregroundColor(.black)
                .shadow(color: .black, radius: 0.5)

                .onAppear {
                Task {
                    self.userLocation = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
                }
            }
        }.ignoresSafeArea(edges: [.top, .trailing, .leading])
    }
}



