//
//  HomeViewModel.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import Foundation

class HomeViewModel {
    
    private let productService = ProductService()
    
    var homeModels: [HomeModel] = []
    
    func fetchMoreProducts(completion: @escaping () -> Void) {
        productService.fetchMoreProducts { [weak self] (newProducts) in
            guard let self = self, let newProducts = newProducts else {
                completion()
                return
            }
            self.homeModels.append(contentsOf: newProducts)
            completion()
        }
    }
}
