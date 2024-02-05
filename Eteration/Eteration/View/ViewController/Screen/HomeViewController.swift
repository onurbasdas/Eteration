//
//  HomeViewController.swift
//  Eteration
//
//  Created by Onur on 2.02.2024.
//

import UIKit
import SnapKit
import UIScrollView_InfiniteScroll

class HomeViewController: BaseViewController {
 
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        return searchBar
    }()
    
    lazy var filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filters:"
        return label
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Select Filter", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [filterLabel, filterButton])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.backgroundColor = .white
        return stackView
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()
    
    var homeViewModel = HomeViewModel()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchMoreData()
        setupInfiniteScroll()
    }
    
    func fetchMoreData() {
        homeViewModel.fetchMoreProducts { [weak self] in
            guard let self = self else { return }
            self.isLoading = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.finishInfiniteScroll()
            }
        }
    }
    
    func setupInfiniteScroll() {
        collectionView.addInfiniteScroll { [weak self] collectionView in
            guard let self = self else { return }
            if !self.isLoading {
                self.isLoading = true
                self.fetchMoreData()
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = UIColor(named: "BgColor")
        self.navigationItem.title = "E-Market"
        
        // Add SearchBar
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }
        
        // Add Horizontal StackView
        view.addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        // Add UICollectionView
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCell")
    }
    
    @objc func filterButtonTapped() {
        
    }
}

extension HomeViewController: ProductCollectionViewCellDelegate {
    func didSelectFavorite(cell: ProductCollectionViewCell) {
        if let indexPath = collectionView.indexPath(for: cell) {
            let selectedProduct = homeViewModel.homeModels[indexPath.row]
            let isInCart = CartManager.shared.isProductInCart( homeViewModel.homeModels[indexPath.row])
            if isInCart {
                CartManager.shared.removeFromCart(item: selectedProduct)
                showAlert(message: "Product removed from cart!")
                cell.addToCartButton.titleLabel?.text = "Add to Card"
            } else {
                CartManager.shared.addToCart(item: selectedProduct)
                showAlert(message: "Product added to cart!")
                cell.addToCartButton.titleLabel?.text = "Remove to Card"
            }
        }
        self.collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeViewModel.homeModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        let model = homeViewModel.homeModels[indexPath.item]
        cell.delegate = self
        cell.configure(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2 - 30
        let cellHeight = CGFloat(300)
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedProduct = homeViewModel.homeModels[indexPath.item]
        navigateToProductDetail(selectedProduct)
    }
}

extension HomeViewController {
    func navigateToProductDetail(_ selectedProduct: HomeModel) {
        let productDetailVC = DetailViewController()
        productDetailVC.selectedProduct = selectedProduct
        navigationController?.pushViewController(productDetailVC, animated: true)
    }
}
