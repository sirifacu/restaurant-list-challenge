//
//  RestaurantViewModel.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import Foundation

struct RestaurantViewModel {
    private let restaurant: Restaurant

    init(with restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    var id: String {
        return self.restaurant.id
    }

    var name: String {
        return self.restaurant.name
    }

    var address: String {
        return self.restaurant.location.street
    }

    var city: String {
        return "\(self.restaurant.location.locality), \(self.restaurant.location.country)"
    }

    var imageUrl: String {
        return self.restaurant.images?.source ?? ""
    }

    var rating: String {
        let theforkTotalRating = self.restaurant.ratings.thefork.ratingValue * Double(self.restaurant.ratings.thefork.reviewCount)
        let tripadvisorTotalRating = self.restaurant.ratings.tripadvisor.ratingValue * 2 * Double(self.restaurant.ratings.tripadvisor.reviewCount)
        let totalRating = theforkTotalRating + tripadvisorTotalRating
        let reviewCount = Double(self.restaurant.ratings.thefork.reviewCount + self.restaurant.ratings.tripadvisor.reviewCount)
        let average = totalRating / reviewCount
        let roundedAverage = Double(Int((average * 10).rounded())) / 10
        return "\(roundedAverage)/10"
    }
}
