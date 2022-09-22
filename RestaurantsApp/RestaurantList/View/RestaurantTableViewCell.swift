//
//  RestaurantTableViewCell.swift
//  RestaurantsApp
//
//  Created by Facundo Andrés Siri on 20/09/2022.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    var delegate: FavoriteCellManager?

    var restaurant: RestaurantViewModel? {
        didSet {
            if let restaurant = restaurant {
                self.nameLabel.text = restaurant.name
                self.addressLabel.text = restaurant.address
                self.cityLabel.text = restaurant.city
                self.setupRestaurantImage(with: restaurant.imageUrl)
                self.ratingLabel.text = restaurant.rating
            }
        }
    }

    var favoriteImageName: String {
        get {
            guard
                let delegate = self.delegate,
                let id = self.restaurant?.id
            else {
                return FavoriteImage.heart.rawValue
            }
            return delegate.getFavoriteImageCellName(with: id).rawValue
        }
        set {
            self.favoriteImage.image = UIImage(systemName: newValue)?
                .withTintColor(.red,renderingMode: .alwaysOriginal)
        }
    }

    let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.8
        return label
    }()

    let addressLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()

    let cityLabel : UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()

    let restaurantImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    let ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .left
        return label
    }()

    let favoriteImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.separatorInset.left = 15
        self.separatorInset.right = 15

        self.addSubview(self.restaurantImage)
        self.addSubview(self.nameLabel)
        self.addSubview(self.addressLabel)
        self.addSubview(self.cityLabel)
        self.addSubview(self.ratingLabel)
        self.addSubview(self.favoriteImage)

        let favouriteImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.favoriteImageTapped))

        self.favoriteImage.addGestureRecognizer(favouriteImageTapGesture)
        self.favoriteImage.isUserInteractionEnabled = true

        self.setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func favoriteImageTapped() {
        guard let restaurant = self.restaurant else {
            print("Restaurant not asigned")
            return
        }

        if let delegate = self.delegate {
            delegate.addOrRemoveFromFavorite(with: restaurant.id)
            self.favoriteImageName = delegate.getFavoriteImageCellName(with: restaurant.id).rawValue
        }
    }

    private func setupRestaurantImage(with imageUrl: String) {
        self.restaurantImage.image = UIImage(named: "placeholder")
        ImageLoader.shared.loadFrom(url: imageUrl) { [weak self] image in
            if let image = image {
                DispatchQueue.main.async {
                    self?.restaurantImage.image = image
                }
            }
        }
    }

    private func setupConstraints() {
        self.restaurantImage.anchor(
            top: self.topAnchor,
            left: self.leftAnchor,
            bottom: nil,
            right: nil,
            paddingTop: 15,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 0,
            width: 100,
            height: 100,
            enableInsets: false
        )

        self.nameLabel.anchor(
            top: topAnchor,
            left: self.restaurantImage.rightAnchor,
            bottom: nil,
            right: self.rightAnchor,
            paddingTop: 20,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 20,
            width: 0,
            height: 0,
            enableInsets: false
        )

        self.addressLabel.anchor(
            top: self.nameLabel.bottomAnchor,
            left: self.restaurantImage.rightAnchor,
            bottom: nil,
            right: self.rightAnchor,
            paddingTop: 5,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 20,
            width: 0,
            height: 0,
            enableInsets: false
        )

        self.cityLabel.anchor(
            top: self.addressLabel.bottomAnchor,
            left: self.restaurantImage.rightAnchor,
            bottom: nil,
            right: nil,
            paddingTop: 5,
            paddingLeft: 20,
            paddingBottom: 0,
            paddingRight: 0,
            width: 180,
            height: 0,
            enableInsets: false
        )

        self.ratingLabel.anchor(
            top: nil,
            left: self.restaurantImage.rightAnchor,
            bottom: self.bottomAnchor,
            right: nil,
            paddingTop: 0,
            paddingLeft: 20,
            paddingBottom: 15,
            paddingRight: 0,
            width: 50,
            height: 0,
            enableInsets: false
        )

        self.favoriteImage.anchor(
            top: nil,
            left: nil,
            bottom: self.bottomAnchor,
            right: self.rightAnchor,
            paddingTop: 0,
            paddingLeft: 0,
            paddingBottom: 10,
            paddingRight: 30,
            width: 30,
            height: 30,
            enableInsets: false
        )
    }
}
