//
//  RestaurantListTableViewController.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import UIKit

protocol FavoriteCellManager {
    func addOrRemoveFromFavorite(with id: String)
    func getFavoriteImageCellName(with id: String) -> FavoriteImage
}

// MARK: RestaurantListTableViewController Section

class RestaurantListTableViewController: UITableViewController, FavoriteCellManager {

    private let viewModel: RestaurantListViewModel
    private let statusBar: UIView
    private let screenTitle = "Restaurant List"
    private let cellIdentifier = "restaurantCellIdentifier"

    init(
        _ viewModel: RestaurantListViewModel? = nil,
        _ statusBar: UIView? = nil
    ) {
        self.viewModel = viewModel ?? RestaurantListViewModel()
        self.statusBar = statusBar ?? UIView()
        super.init(style: UITableView.Style.plain)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.viewModel.getRestaurants {
            self.tableView.reloadData()
        }
    }

    private func setupUI() {
        self.setupTableView()
        self.setupNavigationBar()
    }

    private func setupTableView() {
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = .gray
        self.tableView.allowsSelection = false
        self.tableView.register(RestaurantTableViewCell.self, forCellReuseIdentifier: self.cellIdentifier)
    }

    private func setupNavigationBar() {
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .gray
            self.navigationController?.navigationBar.standardAppearance = appearance;
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        }
        let titleAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.titleTextAttributes = titleAttributes
        self.navigationController?.navigationBar.largeTitleTextAttributes = titleAttributes
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = self.screenTitle
        self.setupStatusBar()
    }

    private func setupStatusBar() {
        if let parentView = self.navigationController?.view {
            self.statusBar.backgroundColor = .gray
            self.statusBar.translatesAutoresizingMaskIntoConstraints = false
            parentView.addSubview(self.statusBar)

            self.statusBar.anchor(
                top: parentView.topAnchor,
                left: parentView.leftAnchor,
                bottom: nil,
                right: parentView.rightAnchor,
                paddingTop: 0, paddingLeft: 0,
                paddingBottom: 0,
                paddingRight: 0,
                width: 0,
                height: UIApplication.shared.statusBarFrame.height,
                enableInsets: false
            )
        }
    }

    // MARK: Favorite Cell Manager Methods

    func addOrRemoveFromFavorite(with id: String) {
        self.viewModel.addOrRemoveFromFavorite(with: id)
    }

    func getFavoriteImageCellName(with id: String) -> FavoriteImage {
        self.viewModel.getFavoriteImageName(with: id)
    }
}

// MARK: Tabla Data Source Section

extension RestaurantListTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int ) -> Int {
        return self.viewModel.restaurants.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellIdentifier, for: indexPath) as! RestaurantTableViewCell

        let restaurant = self.viewModel.restaurants[indexPath.row]

        cell.delegate = self
        cell.restaurant = restaurant
        cell.favoriteImageName = self.getFavoriteImageCellName(with: restaurant.id).rawValue

        return cell
    }
}
