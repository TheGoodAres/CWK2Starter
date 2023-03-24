//
//  HourCondition.swift
//  Coursework2
//
//  Created by G Lukka.
//

import SwiftUI

struct HourCondition: View {
    var current: Current

    var body: some View {
        VStack{
            HStack {
                
                Text(getFormattedDate(from: current.dt, type: 2))
                IconFromWebsite(url: current.weather[0].icon)
                Text("\(current.temp.rounded().formatted()) ºC")
                Text(current.weather[0].weatherDescription.rawValue)
                
            }.padding()
        }
    }
}

struct HourCondition_Previews: PreviewProvider {
    static var hourly = ModelData().forecast!.hourly

    static var previews: some View {
        HourCondition(current: hourly[0])
    }
}
