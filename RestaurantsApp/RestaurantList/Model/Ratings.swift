//
//  Ratings.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

struct Ratings: Decodable {
    let thefork: Rating
    let tripadvisor: Rating
}

struct Rating: Decodable {
    let ratingValue: Double
    let reviewCount: Int
}
