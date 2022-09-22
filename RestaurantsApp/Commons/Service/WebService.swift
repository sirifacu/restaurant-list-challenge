//
//  WebService.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import Foundation

class WebService {

    func fetch<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        URLSession.shared.dataTask(with: resource.url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let response = response as? HTTPURLResponse,
                response.statusCode != 404
            else {
                return completion(nil)
            }
            DispatchQueue.main.async {
                completion(resource.parse(data))
            }
        }.resume()
    }
}
