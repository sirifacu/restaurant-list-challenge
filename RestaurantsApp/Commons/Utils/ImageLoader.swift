//
//  ImageLoader.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import UIKit

class ImageLoader {
    
    private init() {}

    static let shared = ImageLoader()
    private let webService = WebService()
    private var cacheImages: [URL: UIImage] = [:]

    func loadFrom(
        url: String,
        completion: @escaping (UIImage?) -> Void
    ) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }

        if let cacheImage = self.cacheImages[imageUrl] {
            completion(cacheImage)
            return
        }

        let resource = Resource(url: imageUrl) { data in
            return data
        }

        self.webService.fetch(resource: resource) { [weak self] response in
            guard
                let data = response,
                let imageFromData = UIImage(data: data)
            else {
                completion(nil)
                return
            }
            self?.cacheImages[imageUrl] = imageFromData
            completion(imageFromData)
        }
    }
}
