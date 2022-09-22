//
//  RealmMock.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

import RealmSwift

class RealmMock {
   static var realm: Realm {
      get {
         var realm: Realm
         let identifier = "realmMock"
         let config = Realm.Configuration(inMemoryIdentifier: identifier)
         do {
            realm = try Realm(configuration: config)
            return realm
         } catch let error {
            fatalError("Error: \(error.localizedDescription)")
         }
      }
   }
}
