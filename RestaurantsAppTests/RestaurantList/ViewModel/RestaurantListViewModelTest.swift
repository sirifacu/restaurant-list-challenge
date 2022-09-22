//
//  RestaurantListViewModelTest.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp
import Nimble
import Quick
import RealmSwift

class RestaurantListViewModelTest: QuickSpec {

    private var webServiceMock: WebServiceMock!
    private var realmMock: Realm!
    private var restaurantListVM: RestaurantListViewModel!

    override func spec() {
        beforeEach {
            self.webServiceMock = WebServiceMock()
            self.realmMock = RealmMock.realm

            do {
                try self.realmMock.write {
                    let firstFavorite = Favorite()
                    firstFavorite.id = "1"
                    self.realmMock.add(firstFavorite)
                }
            } catch {
                print("Could not save or remove favorite, \(error.localizedDescription)")
            }

            self.restaurantListVM = RestaurantListViewModel(self.webServiceMock, self.realmMock)
        }

        afterEach {
            let allFavorites = self.realmMock.objects(Favorite.self)
            do {
                try self.realmMock.write {
                    self.realmMock.delete(allFavorites)
                }
            } catch {
                print("Could not save or remove favorite, \(error.localizedDescription)")
            }
        }

        describe("When RestaurantListViewModel is initialized") {
            context("and getRestaurants method is executed") {
                it("should call web service to fetch the data") {
                    // Given
                    let previousRestaurantsCount = self.restaurantListVM.restaurants.count
                    var completionExecuted = false

                    // When
                    self.restaurantListVM.getRestaurants {
                        completionExecuted = true
                    }

                    // Then
                    expect(self.webServiceMock.resourceReceived).toNot(beNil())
                    expect(previousRestaurantsCount).to(equal(0))
                    expect(self.restaurantListVM.restaurants.count).to(equal(2))
                    expect(completionExecuted).to(beTrue())
                }
            }
        }

        describe("When addOrRemoveFromFavorite method is executed") {
            context("and the id is not marked as favorite") {
                it("should add the id to favorites") {
                    // Given
                    let previousFavoritesCount = self.realmMock.objects(Favorite.self).count

                    // When
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "2")

                    // Then
                    let favorites = self.realmMock.objects(Favorite.self)
                    expect(previousFavoritesCount).to(equal(1))
                    expect(favorites.last?.id).to(equal("2"))
                    expect(favorites.count).to(equal(2))
                }
            }

            context("and the id is already marked as favorite") {
                it("should remove the id from favorites") {
                    // Given
                    let previousFavoritesCount = self.realmMock.objects(Favorite.self).count

                    // When
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "1")

                    // Then
                    let favorites = self.realmMock.objects(Favorite.self)
                    expect(previousFavoritesCount).to(equal(1))
                    expect(favorites.count).to(equal(0))
                }
            }

            context("and there are already 5 favorites") {
                it("should not add the value") {
                    // Given
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "2")
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "3")
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "4")
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "5")
                    let previousFavoritesCount = self.realmMock.objects(Favorite.self).count

                    // When
                    self.restaurantListVM.addOrRemoveFromFavorite(with: "6")

                    // Then
                    let favorites = self.realmMock.objects(Favorite.self)
                    expect(previousFavoritesCount).to(equal(5))
                    expect(favorites.count).to(equal(5))
                    expect(favorites).toNot(containElementSatisfying({ favorite in
                        favorite.id == "6"
                    }))
                }
            }
        }

        describe("When getFavoriteImageName method is executed") {
            context("and the id is marked as favorite") {
                it("should return the image name 'heart.fill'") {
                    // When
                    let imageName = self.restaurantListVM.getFavoriteImageName(with: "1")

                    // Then
                    expect(imageName.rawValue).to(equal("heart.fill"))
                }
            }

            context("and the id is not marked as favorite") {
                it("should return the image name 'heart'") {
                    // When
                    let imageName = self.restaurantListVM.getFavoriteImageName(with: "2")

                    // Then
                    expect(imageName.rawValue).to(equal("heart"))
                }
            }
        }
    }
}
