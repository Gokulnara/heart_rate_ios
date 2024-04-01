//
//  APIHandler.swift
//  WeatherApp
//
//  Created by Haris Madhavan on 07/09/23.
//

import Foundation
import UIKit


class APIHandler {
    static var shared: APIHandler = APIHandler()
    
    init() {}
    
    func getAPIValues<T:Codable>(type: T.Type, apiUrl: String, method: String, onCompletion: @escaping (Result<T, Error>) -> Void) {
                
        guard let url = URL(string: apiUrl) else {
                    let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
                    onCompletion(.failure(error))
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        onCompletion(.failure(error))
                        return
                    }
                    
                    guard let data = data else {
                        let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                        onCompletion(.failure(error))
                        return
                    }
                    
                    do {
                        let decodedData = try JSONDecoder().decode(type, from: data)
                        onCompletion(.success(decodedData))
                        print(decodedData)
                    } catch {
                        onCompletion(.failure(error))
                    }
                }
                
                task.resume()
            }
    
    func postAPIValues<T: Codable>(
        type: T.Type,
        apiUrl: String,
        method: String,
        formData: [String: String], // Dictionary for form data parameters
        onCompletion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = URL(string: apiUrl) else {
            let error = NSError(domain: "Invalid URL", code: 0, userInfo: nil)
            onCompletion(.failure(error))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // Construct the form data string
        var formDataString = ""
        for (key, value) in formData {
            formDataString += "\(key)=\(value)&"
        }
        formDataString = String(formDataString.dropLast()) // Remove the trailing "&"
        
        // Set the request body
        request.httpBody = formDataString.data(using: .utf8)
        
        // Set the content type to "application/x-www-form-urlencoded"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "No data received", code: 1, userInfo: nil)
                onCompletion(.failure(error))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(type, from: data)
                onCompletion(.success(decodedData))
                print(decodedData)
            } catch {
                onCompletion(.failure(error))
            }
        }
        
        task.resume()
    }


    
        }
        
