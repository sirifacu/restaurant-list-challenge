//
//  Resource.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import Foundation

struct Resource<T> {
    let url: URL
    let parse: (Data) -> T?
}
