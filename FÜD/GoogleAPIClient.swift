//
//  GoogleAPIClient.swift
//  FÜD
//
//  Created by Nathan  on 3/22/18.
//  Copyright © 2018 Nathan . All rights reserved.
//

import Foundation
import CoreLocation

protocol GoogleClientRequest {
    
    var googlePlacesKey : String { get set }
    func getGooglePlacesData(keyword: String, location: CLLocation, radius: Float, success: @escaping (GooglePlacesResponse) -> (), failure:@escaping (Error?) -> ())
    func getPhotoData(photoReference: String, maxWidth: String, using completionHandler: @escaping (Data) -> ())
    
}

class GoogleClient: GoogleClientRequest {
    
    let session = URLSession(configuration: .default)
    
    var googlePlacesKey: String = "AIzaSyCypnEeiOVAk9KNafSIuQrPr1dpG4-ZHRI"
    
    func getGooglePlacesData(keyword: String, location: CLLocation,radius: Float, success: @escaping (GooglePlacesResponse) -> (), failure: @escaping (Error?) -> ())  {
        
        let url = googlePlacesDataURL(forKey: googlePlacesKey, location: location, keyword: keyword, radius: Int(radius))
        let task = session.dataTask(with: url) { (responseData, urlResponse, error) in
            if let error = error {
                print(error.localizedDescription)
                failure(error)
                return
            }
            if let httpResponse = urlResponse as? HTTPURLResponse {
                print ("httpResponse \(httpResponse.statusCode)")
            }
            print(responseData!)
            guard let data = responseData,
                let response = try? JSONDecoder().decode(GooglePlacesResponse.self, from: data) else {
                    print("failed codable")
                    failure(nil)
                    return
            }
            success(response)
        }
        task.resume()
    }
    
    func getPhotoData(photoReference: String, maxWidth: String, using completionHandler: @escaping (Data) -> ())  {
        
        let url = googlePhotoDataURL(forKey: googlePlacesKey, photoReference: photoReference, maxWidth: maxWidth)
        let task = session.dataTask(with: url) { (responseData, _, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = responseData else {
                    return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
    func googlePlacesDataURL(forKey apiKey: String, location: CLLocation, keyword: String, radius: Int) -> URL {
        
        let baseURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        let locationString = "location=" + String(location.coordinate.latitude) + "," + String(location.coordinate.longitude)
        let radius = "radius=\(radius)"
        let keywrd = "keyword=" + keyword
        let key = "key=" + apiKey
        
        print(URL(string: baseURL + locationString + "&" + radius + "&" + keywrd + "&" + key)!)
        return URL(string: baseURL + locationString + "&" + radius + "&" + keywrd + "&" + key)!
    }
    
    func googlePhotoDataURL(forKey apiKey: String, photoReference: String, maxWidth: String) -> URL {
        
        let baseURL = "https://maps.googleapis.com/maps/api/place/photo?"
        let maxWidth = "maxwidth=400"
        let photoRef = "photoreference=" + photoReference
        let key = "key=" + apiKey
        
        
        return URL(string: baseURL + maxWidth + "&" + photoRef + "&" + key)!
    }
    
}
