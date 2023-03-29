//
//  LocationHelper.swift
//  Coursework2
//
//  Created by G Lukka.
//

import Foundation

import CoreLocation
func getLocFromLatLong(lat: Double, lon: Double) async -> String
{
    var locationString: String
    var placemarks: [CLPlacemark]
    let center: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)

    let ceo: CLGeocoder = CLGeocoder()

    let loc: CLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
    do {
        placemarks = try await ceo.reverseGeocodeLocation(loc)
        if placemarks.count > 0 {


            if (!placemarks[0].name!.isEmpty) {

                locationString = placemarks[0].name!

            } else {
                locationString = (placemarks[0].locality ?? "No City")
            }

            return locationString
        }
    } catch {
        print("Reverse geodecoe fail: \(error.localizedDescription)")
        locationString = "No City, No Country"

        return locationString
    }

    return "Error getting Location"
}

func getCoordinates(forAddress address: String, completionHandler: @escaping (CLLocationCoordinate2D?, Error?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(address) { (placemarks, error) in
        guard let placemarks = placemarks, let location = placemarks.first?.location else {
            completionHandler(nil, error)
            return
        }
        
        let coordinates = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        completionHandler(coordinates, nil)
    }
}
