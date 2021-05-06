//
//  NetworkManager.swift
//  MSApps
//
//  Created by Eli Mehaudy on 02/05/2021.
//

import Foundation
import Alamofire

class NetworkManager {    
    func getRequest<T: Codable>(url: String, completion: @escaping ((T?, Error?)->Void)) {
        AF.request(url).response { response in
            guard let data = response.data else {
                print("error, \(response.error?.errorDescription ?? "Error not parsed")")
                completion(nil, response.error)
                return
            }
            let parsedJSON: T? = self.parseJSON(data)
            completion(parsedJSON, nil)
        }
    }
    
    func parseJSON<T: Codable>(_ data: Data) -> T? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}
