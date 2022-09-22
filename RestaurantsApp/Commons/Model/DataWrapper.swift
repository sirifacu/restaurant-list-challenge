//
//  DataWrapper.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

struct DataWrapper<T: Decodable>: Decodable {
    let data: T
}
