//
//  AirStructures.swift
//  CourseWork2Starter-main
//
//  Created by Robert-Dumitru Oprea on 28/03/2023.
//  Partially created with quicktype.io adjusted to fit the purpose

import Foundation

// MARK: - AirQuality
struct AirQuality: Codable {
    let coord: [Int]
    let list: [ListData]
}

// MARK: - List
struct ListData: Codable {
    let dt: Int
    let main: MainData
    let components: [String: Double]
}

// MARK: - Main
struct MainData: Codable {
    let aqi: Int
}


