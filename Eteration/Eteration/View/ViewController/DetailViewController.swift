//
//  DetailViewController.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import UIKit
import SnapKit
import SDWebImage
import CoreData

class DetailViewController: BaseViewController {
    
    // Image view for product image
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Title label for product name
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Description label for product description
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    // Horizontal stack view for price and add to cart button
    let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 100
        return stackView
    }()
    
    // Vertical stack view for price information
    let priceStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    // Label for "Price:"
    let priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Price:"
        return label
    }()
    
    // Label for displaying price value
    let priceValueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    // Button for "Add to Cart"
    let addToCartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add to Cart", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addToCartButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var selectedProduct: HomeModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = selectedProduct?.name
        setupUI()
    }
    
    private func setupUI() {
        
        // Add subviews to the view
        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(horizontalStackView)
        
        // Set constraints using SnapKit
        imageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-100)
        }
        
        // Add subviews to the horizontal stack view
        horizontalStackView.addArrangedSubview(priceStackView)
        horizontalStackView.addArrangedSubview(addToCartButton)
        
        // Add subviews to the vertical stack view
        priceStackView.addArrangedSubview(priceLabel)
        priceStackView.addArrangedSubview(priceValueLabel)
        
        // Configure UI elements
        configureUI()
        detailButtonConfigureUI(button: addToCartButton)
    }
    
    private func configureUI() {
        if let imageUrl = selectedProduct?.image, let url = URL(string: imageUrl) {
            imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        } else {
            imageView.image = UIImage(named: "placeholder")
        }
        titleLabel.text = selectedProduct?.name
        descriptionLabel.text = selectedProduct?.description
        priceValueLabel.text = "\(selectedProduct?.price ?? "")₺"
    }
    
    @objc func addToCartButtonTapped() {
        showButton()
    }
    
    func showButton() {
        guard let selectedProduct = selectedProduct else { return }
        
        let isInCart = CartManager.shared.isProductInCart(selectedProduct)
        
        if isInCart {
            // If the product is already in the cart, remove it
            CartManager.shared.removeFromCart(item: selectedProduct)
            showAlert(message: "Product removed from cart!")
            addToCartButton.titleLabel?.text = "Add to Card"
        } else {
            // If the product is not in the cart, add it
            CartManager.shared.addToCart(item: selectedProduct)
            showAlert(message: "Product added to cart!")
            addToCartButton.titleLabel?.text = "Remove to Card"
        }
        
        detailButtonConfigureUI(button: addToCartButton)
    }
    
    func detailButtonConfigureUI(button: UIButton) {
        if let selectedProduct = selectedProduct {
            if CartManager.shared.isProductInCart(selectedProduct) {
                button.setTitle("Remove from Cart", for: .normal)
            } else {
                button.setTitle("Add to Cart", for: .normal)
            }
        }
    }
}
