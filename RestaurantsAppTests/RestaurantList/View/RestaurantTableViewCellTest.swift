//
//  RestaurantTableViewCellTest.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp
import Nimble
import Quick

class RestaurantTableViewCellTest: QuickSpec {

    private var delegateMock: RestaurantListTableViewControllerMock!
    private var restaurantCell: RestaurantTableViewCell!

    override func spec() {
        beforeEach {
            let location = Location(street: "Mock Street 123", postalCode: "1234", locality: "Mock City", country: "Fakeland")
            let firstRating = Rating(ratingValue: 8, reviewCount: 10)
            let secondRating = Rating(ratingValue: 4.5, reviewCount: 15)
            let ratings = Ratings(thefork: firstRating, tripadvisor: secondRating)
            let images = Images(source: "www.fakeurl.com")
            let restaurant = Restaurant(id: "1", name: "Test 1", location: location, ratings: ratings, images: images)
            let resturantVM = RestaurantViewModel(with: restaurant)

            self.delegateMock = RestaurantListTableViewControllerMock()

            self.restaurantCell = RestaurantTableViewCell(style: .default, reuseIdentifier: "restaurantCellIdentifier")

            self.restaurantCell.delegate = self.delegateMock
            self.restaurantCell.restaurant = resturantVM
            self.restaurantCell.favoriteImageName = FavoriteImage.heart.rawValue

        }

        describe("When RestaurantTableViewCell is initialized") {
            context("and the restaurant property is setted") {
                it("should have added the subviews with its proper data") {
                    // Then
                    expect(self.restaurantCell.subviews.count).to(equal(7))
                    expect(self.restaurantCell.nameLabel.text).to(equal("Test 1"))
                    expect(self.restaurantCell.addressLabel.text).to(equal("Mock Street 123"))
                    expect(self.restaurantCell.cityLabel.text).to(equal("Mock City, Fakeland"))
                    expect(self.restaurantCell.ratingLabel.text).to(equal("8.6/10"))
                    expect(self.restaurantCell.favoriteImage.image).toNot(beNil())
                    expect(self.restaurantCell.restaurantImage.image).toNot(beNil())
                }
            }
        }

        describe("When favoriteImageName is accessed") {
            context("and it is setted with a new value") {
                it("should change the favoriteImage as well") {
                    // When
                    let previousImage = self.restaurantCell.favoriteImage.image
                    self.restaurantCell.favoriteImageName = FavoriteImage.filledHeart.rawValue

                    // Then
                    expect(self.restaurantCell.favoriteImage.image).toNot(be(previousImage))
                }
            }

            context("and getter method is called with an existing delegate and restaurant assigned") {
                it("should call the delegate method and return its value") {
                    // When
                    let imageName = self.restaurantCell.favoriteImageName

                    // Then
                    expect(imageName).to(equal("heart.fill"))
                    expect(self.delegateMock.timesGetFavoriteImageCellNameWasCalled).to(equal(1))
                    expect(self.delegateMock.idReceived).to(equal("1"))
                }
            }

            context("and getter method is called with a non-existing delegate or not assigned restaurant") {
                it("should return its default value") {
                    // Given
                    let cell = RestaurantTableViewCell(
                        style: .default,
                        reuseIdentifier: "restaurantCellIdentifier"
                    )

                    // When
                    let imageName = cell.favoriteImageName

                    // Then
                    expect(imageName).to(equal("heart"))
                }
            }
        }

        describe("When a tap gesture begins") {
            context("and the favorite image is tapped") {
                it("should call the delegate method with the proper id") {
                    // When
                    TestUtils.checkTapGestureRecognizerAndCallAction(of: self.restaurantCell.favoriteImage)

                    // Then
                    expect(self.delegateMock.timesAddOrRemoveFromFavoriteWasCalled).to(equal(1))
                    expect(self.delegateMock.idReceived).to(equal("1"))
                }

            }
        }
    }
}

class RestaurantListTableViewControllerMock: RestaurantListTableViewController {

    private(set) var timesGetFavoriteImageCellNameWasCalled = 0
    private(set) var timesAddOrRemoveFromFavoriteWasCalled = 0
    private(set) var idReceived: String?

    override func getFavoriteImageCellName(with id: String) -> FavoriteImage {
        self.timesGetFavoriteImageCellNameWasCalled += 1
        self.idReceived = id

        return FavoriteImage.filledHeart
    }

    override func addOrRemoveFromFavorite(with id: String) {
        self.timesAddOrRemoveFromFavoriteWasCalled += 1
        self.idReceived = id
    }
}
