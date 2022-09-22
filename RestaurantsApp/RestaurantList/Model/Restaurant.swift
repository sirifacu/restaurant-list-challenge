//
//  Restaurant.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import Foundation

struct Restaurant: Decodable {
    let id: String
    let name: String
    let location: Location
    let ratings: Ratings
    let images: Images?

    private enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case name
        case location = "address"
        case ratings = "aggregateRatings"
        case images = "mainPhoto"
    }

    static let getAll: Resource<[Restaurant]> = {
        let url = URL(string: "https://alanflament.github.io/TFTest/test.json")!

        let resource = Resource<[Restaurant]>(
            url: url
        ) { data in
            let decoder = JSONDecoder()
            let restaurantsResponse = try? decoder.decode(
                DataWrapper<[Restaurant]>.self,
                from: data
            )
            return restaurantsResponse?.data
        }

        return resource
    }()
}
