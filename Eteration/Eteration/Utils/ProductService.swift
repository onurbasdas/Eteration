//
//  ProductService.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import Foundation

class ProductService {
    static let shared = ProductService()
    init() {}

    func fetchProducts(completion: @escaping ([HomeModel]?) -> Void) {
        guard let url = URL(string: "https://5fc9346b2af77700165ae514.mockapi.io/products") else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            do {
                let decoder = JSONDecoder()
                let products = try decoder.decode([HomeModel].self, from: data)
                completion(products)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
