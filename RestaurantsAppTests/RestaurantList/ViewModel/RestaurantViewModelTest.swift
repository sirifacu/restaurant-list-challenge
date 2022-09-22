//
//  RestaurantViewModelTest.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp
import Nimble
import Quick

class RestaurantViewModelTest: QuickSpec {

    private var restaurant: Restaurant!

    override func spec() {
        beforeEach {
            let location = Location(street: "Mock Street 123", postalCode: "1234", locality: "Mock City", country: "Fakeland")
            let firstRating = Rating(ratingValue: 8, reviewCount: 10)
            let secondRating = Rating(ratingValue: 4.5, reviewCount: 15)
            let ratings = Ratings(thefork: firstRating, tripadvisor: secondRating)
            let images = Images(source: "www.fakeurl.com")
            self.restaurant = Restaurant(id: "1", name: "Test 1", location: location, ratings: ratings, images: images)
        }

        describe("When a RestaurantViewModel inits") {
            context("from a restaurant") {
                it("should assign its properties properly") {
                    // Given
                    let restaurantVM = RestaurantViewModel(with: self.restaurant)

                    // Then
                    expect(restaurantVM.id).to(equal("1"))
                    expect(restaurantVM.name).to(equal("Test 1"))
                    expect(restaurantVM.address).to(equal("Mock Street 123"))
                    expect(restaurantVM.city).to(equal("Mock City, Fakeland"))
                    expect(restaurantVM.imageUrl).to(equal("www.fakeurl.com"))
                    expect(restaurantVM.rating).to(equal("8.6/10"))
                }
            }
        }
    }
}
