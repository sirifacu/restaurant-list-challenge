//
//  RestaurantListViewModelMock.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp

class RestaurantListViewModelMock: RestaurantListViewModel {

    private(set) var timesGetRestaurantsWasCalled = 0
    private(set) var completionReceived: (() -> Void)?
    private(set) var timesGetFavoriteImageNameWasCalled = 0
    private(set) var idsGetFavoriteImageNameWasCalledWith: [String] = []
    private(set) var timesAddOrRemoveFromFavoriteWasCalled = 0
    private(set) var idReceived: String?

    override func getRestaurants(completion: @escaping () -> Void) {
        let firstLocation = Location(street: "Street 1", postalCode: "1234", locality: "City 1", country: "Country 1")
        let firstRating = Rating(ratingValue: 8, reviewCount: 10)
        let secondRating = Rating(ratingValue: 9, reviewCount: 15)
        let firstRatings = Ratings(thefork: firstRating, tripadvisor: secondRating)
        let firstImages = Images(source: "www.firstfakeurl.com")
        let firstRestaurant = Restaurant(id: "1", name: "Test 1", location: firstLocation, ratings: firstRatings, images: firstImages)
        let firstRestaurantVM = RestaurantViewModel(with: firstRestaurant)

        let secondLocation = Location(street: "Street 2", postalCode: "5678", locality: "City 2", country: "Country 2")
        let thirdRating = Rating(ratingValue: 8, reviewCount: 10)
        let fourthRating = Rating(ratingValue: 9, reviewCount: 15)
        let secondRatings = Ratings(thefork: thirdRating, tripadvisor: fourthRating)
        let secondImages = Images(source: "www.secondfakeurl.com")
        let secondRestaurant = Restaurant(id: "2", name: "Test 2", location: secondLocation, ratings: secondRatings, images: secondImages)
        let secondRestaurantVM = RestaurantViewModel(with: secondRestaurant)

        self.timesGetRestaurantsWasCalled += 1
        self.restaurants = [firstRestaurantVM, secondRestaurantVM]
        self.completionReceived = completion
    }

    override func addOrRemoveFromFavorite(with id: String) {
        self.timesAddOrRemoveFromFavoriteWasCalled += 1
        self.idReceived = id
    }

    override func getFavoriteImageName(with id: String) -> FavoriteImage {
        self.timesGetFavoriteImageNameWasCalled += 1
        self.idsGetFavoriteImageNameWasCalledWith.append(id)

        return FavoriteImage.heart
    }
}
