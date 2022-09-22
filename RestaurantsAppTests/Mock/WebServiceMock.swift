//
//  WebServiceMock.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp

class WebServiceMock: WebService {

    private(set) var resourceReceived: Resource<[Restaurant]>?

    override func fetch<T>(resource: Resource<T>, completion: @escaping (T?) -> Void) {
        self.resourceReceived = (resource as! Resource<[Restaurant]>)

        let firstLocation = Location(street: "Street 1", postalCode: "1234", locality: "City 1", country: "Country 1")
        let firstRating = Rating(ratingValue: 8, reviewCount: 10)
        let secondRating = Rating(ratingValue: 9, reviewCount: 15)
        let firstRatings = Ratings(thefork: firstRating, tripadvisor: secondRating)
        let firstImages = Images(source: "www.firstfakeurl.com")
        let firstRestaurant = Restaurant(id: "1", name: "Test 1", location: firstLocation, ratings: firstRatings, images: firstImages)

        let secondLocation = Location(street: "Street 2", postalCode: "5678", locality: "City 2", country: "Country 2")
        let thirdRating = Rating(ratingValue: 8, reviewCount: 10)
        let fourthRating = Rating(ratingValue: 9, reviewCount: 15)
        let secondRatings = Ratings(thefork: thirdRating, tripadvisor: fourthRating)
        let secondImages = Images(source: "www.secondfakeurl.com")
        let secondRestaurant = Restaurant(id: "2", name: "Test 2", location: secondLocation, ratings: secondRatings, images: secondImages)

        completion(([firstRestaurant, secondRestaurant] as! T))
    }
}
