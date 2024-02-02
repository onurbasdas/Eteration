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
    
    func fetchProducts(completion: @escaping () -> Void) {
        productService.fetchProducts { [weak self] (products) in
            guard let self = self, let products = products else { return }
            self.homeModels = products
            completion()
        }
    }
}
