//
//  Hourly.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourlyView: View {
    @State var locationString = ""
    @EnvironmentObject var modelData: ModelData

    var body: some View {
//        VStack {
//            List {
//                ForEach(modelData.forecast!.hourly) { hour in
//                    HourCondition(current: hour)
//
//
//                }
//                .listRowInsets(.init(top: 0, leading: 25, bottom: 0, trailing: 0))
//                    .listRowBackground(Color.clear)
//                    .background {
//                    Color.white
//                        .opacity(0.1)
//                }
//            }
//            .padding()
//
//                .background(Image("background"))
//                .scrollContentBackground(.hidden)
//        }
        ZStack {
            Image("background")
                .resizable()
            VStack {
                Text(locationString)
                    .font(.title)
                List {
                    ForEach(modelData.forecast!.hourly) { hour in
                        HourCondition(current: hour)
                    }
                        .frame(width: 350)
                        .listRowInsets(.init(top: 0, leading: 25, bottom: 0, trailing: 0))
                        .listRowBackground(Color.clear)
                        .background {
                        Color.white
                            .opacity(0.1)
                    }

                }

                    .padding()
                    .background {
                    Color.white
                        .opacity(0.5)
                }
                    .scrollContentBackground(.hidden)
            }
        }
        .onAppear {
            Task.init {
                self.locationString = await getLocFromLatLong(lat: modelData.forecast!.lat, lon: modelData.forecast!.lon)
                
            }
        }
    }
}

struct Hourly_Previews: PreviewProvider {
    static var previews: some View {
        HourlyView().environmentObject(ModelData())
    }
}
