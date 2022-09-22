//
//  Location.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

struct Location: Decodable {
    let street: String
    let postalCode: String
    let locality: String
    let country: String
}
