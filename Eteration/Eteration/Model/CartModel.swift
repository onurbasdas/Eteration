//
//  CartModel.swift
//  Eteration
//
//  Created by Onur on 5.02.2024.
//

import Foundation

struct CartModel {
    var name: String
    var price: String
    var id: UUID

    init(name: String, price: String, id: UUID) {
        self.name = name
        self.price = price
        self.id = id
    }
}
