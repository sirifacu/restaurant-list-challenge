//
//  RestaurantListTableViewControllerTest.swift
//  RestaurantsAppTests
//
//  Created by Facundo Andrés Siri on 21/09/2022.
//

@testable import RestaurantsApp
import Nimble
import Quick
import UIKit

class RestaurantListTableViewControllerTest: QuickSpec {

    private var statusBar: UIView!
    private var viewModelMock: RestaurantListViewModelMock!
    private var restaurantListTVC: RestaurantListTableViewController!
    private var navigationController: UINavigationController!

    override func spec() {
        beforeEach {
            self.statusBar = UIView()
            self.viewModelMock = RestaurantListViewModelMock()
            self.restaurantListTVC = RestaurantListTableViewController(self.viewModelMock, self.statusBar)

            self.navigationController = UINavigationController(rootViewController: self.restaurantListTVC)
        }

        describe("When RestaurantListTableViewController is initialized") {
            context("and view did load") {
                it("should set up the ui properly") {
                    // When
                    self.restaurantListTVC.loadViewIfNeeded()
                    
                    // Then
                    expect(self.restaurantListTVC.tableView.separatorStyle).to(equal(.singleLine))
                    expect(self.restaurantListTVC.tableView.separatorColor).to(equal(.gray))
                    expect(self.restaurantListTVC.tableView.allowsSelection).to(beFalse())
                    expect(self.restaurantListTVC.navigationController?.navigationBar.prefersLargeTitles).to(beTrue())
                    expect(self.restaurantListTVC.navigationItem.title).to(equal("Restaurant List"))
                }

                it("should should call the view model method to get restaurants") {
                    // When
                    self.restaurantListTVC.loadViewIfNeeded()
                    self.restaurantListTVC.tableView.reloadData()

                    // Then
                    expect(self.viewModelMock.timesGetRestaurantsWasCalled).to(equal(1))
                    expect(self.viewModelMock.completionReceived).toNot(beNil())
                    expect(self.restaurantListTVC.tableView.numberOfRows(inSection: 0)).to(equal(2))
                }
            }
        }

        describe("When table view reloads") {
            context("and cellForRowAt is called") {
                it("should call the view model to get the favorite image name properly") {
                    // Given
                    let firstIndexPath = IndexPath(item: 0, section: 0)
                    let secondIndexPath = IndexPath(item: 1, section: 0)

                    // When
                    self.restaurantListTVC.loadViewIfNeeded()
                    _ = self.restaurantListTVC.tableView(self.restaurantListTVC.tableView, cellForRowAt: firstIndexPath)
                    _ = self.restaurantListTVC.tableView(self.restaurantListTVC.tableView, cellForRowAt: secondIndexPath)

                    // Then
                    expect(self.viewModelMock.timesGetFavoriteImageNameWasCalled).toEventually(equal(2))
                    expect(self.viewModelMock.idsGetFavoriteImageNameWasCalledWith[0]).to(equal("1"))
                    expect(self.viewModelMock.idsGetFavoriteImageNameWasCalledWith[1]).to(equal("2"))
                }
            }
        }

        describe("When a favorite image in a cell is tapped") {
            context("and the delegate method is called") {
                it("should call the view model to get add or remove the restaurant from favorites") {
                    // Given
                    let indexPath = IndexPath(item: 0, section: 0)

                    // When
                    self.restaurantListTVC.loadViewIfNeeded()
                    let cell = self.restaurantListTVC.tableView(self.restaurantListTVC.tableView, cellForRowAt: indexPath) as! RestaurantTableViewCell
                    TestUtils.checkTapGestureRecognizerAndCallAction(of: cell.favoriteImage)
                    

                    // Then
                    expect(self.viewModelMock.timesAddOrRemoveFromFavoriteWasCalled).toEventually(equal(1))
                    expect(self.viewModelMock.idReceived).to(equal("1"))
                }
            }
        }
        
    }
}
