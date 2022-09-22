//
//  RestaurantListTableViewModel.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import RealmSwift

class RestaurantListViewModel {

    private let webService: WebService
    private let realm: Realm
    private var favorites: Results<Favorite>
    var restaurants: [RestaurantViewModel] = []

    init(
        _ webService: WebService? = nil,
        _ realm: Realm? = nil
    ) {
        self.webService = webService ?? WebService()
        let defaultRealm = try! Realm()
        self.realm = realm ?? defaultRealm
        self.favorites = self.realm.objects(Favorite.self)
    }

    func getRestaurants(completion: @escaping () -> Void) {
        self.webService.fetch(resource: Restaurant.getAll) { response in
            guard let restaurants = response else {
                return
            }
            self.restaurants = restaurants.map(RestaurantViewModel.init)
            completion()
        }
    }

    func addOrRemoveFromFavorite(with id: String) {
        let previousFavorite = self.favorites.first { favorite in
            return favorite.id == id
        }
        do {
            try self.realm.write {
                if let previousFavorite = previousFavorite {
                    self.realm.delete(previousFavorite)
                } else {
                    guard self.favorites.count < 5 else {
                        return
                    }
                    let favorite = Favorite()
                    favorite.id = id
                    self.realm.add(favorite)
                }
            }
        } catch {
            print("Could not save or remove favorite, \(error.localizedDescription)")
        }
    }

    func getFavoriteImageName(with id: String) -> FavoriteImage {
        let isFavorite = self.favorites.first { favorite in
            return favorite.id == id
        }
        return isFavorite != nil ? .filledHeart : .heart
    }
}
