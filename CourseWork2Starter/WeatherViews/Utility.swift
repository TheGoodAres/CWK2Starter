//
//  Utility.swift
//  CourseWork2Starter
//
//  Created by Robert-Dumitru Oprea on 22/03/2023.
//
// utilities used throught the project

import Foundation
import SwiftUI

//func used to get the formatted cuurent date
func getFormattedDate() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM dd','yyyy 'at' HH a"
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let date = Date.now

    return dateFormatter.string(from: date)
}

//function used to get the formatted date from the unix date returned by the api
func getFormattedDate(from date: Int, type: Int) -> String {
    let dateFormatter = DateFormatter()
    if(type == 0) {
        dateFormatter.dateFormat = "MMMM dd','yyyy 'at' HH a"
    } else if(type == 1) {
        dateFormatter.dateFormat = "HH:ss a"
    } else if(type == 2) {
        dateFormatter.dateFormat = "HH a\n EE"
    } else if(type == 3) {
        dateFormatter.dateFormat = "EEEE dd"
    }
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    let date = NSDate(timeIntervalSince1970: TimeInterval(date))

    return dateFormatter.string(from: date as Date)
}

//struct used to get the asyng image from the website
struct IconFromWebsite: View {
    var url: String
    var body: some View {
        return AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(url)@2x.png")) { image in
            image
                .resizable()
                .frame(width: 40, height: 40)

        } placeholder: {
            ProgressView()
        }
    }
}
// Struct used to customise the Label view, it makes the icon and the text stack vertically rather than horizontally
//credit to: https://medium.com/macoclock/make-more-with-swiftuis-label-94ef56924a9d
struct VerticalLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .center, spacing: 8) {
            configuration.icon
            configuration.title
        }
    }
}



struct Location: Identifiable {
    let id: UUID
    let name: String
    let latitude: Double
    let longitude: Double
}
