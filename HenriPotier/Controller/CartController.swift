//
//  CartController.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class CartController: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var discountPriceLabel: UILabel!
    @IBOutlet weak var finalPriceLabel: UILabel!
    @IBOutlet weak var finalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    private var books = [Book]()
    private let cart = Cart()

    override func viewDidLoad() {
        super.viewDidLoad()
        //puts uiview instead of empty cells at the end of the tableview
        tableView.tableFooterView = UIView()
        //set initial label values for the view
        setLabels()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBookList()
    }

    //set initial label values for the view
    private func setLabels() {
        totalLabel.text = "Total:"
        totalPriceLabel.text = "0 €"
        discountLabel.text = "Remise:"
        discountPriceLabel.text = "0 €"
        finalLabel.text = "Prix final:"
        finalPriceLabel.text = "0 €"
    }

    //fetch books in cart and refresh tableview if needed
    private func refreshBookList() {
        let bookList = cart.getBooksInCart()
        if let bookList = bookList, books != bookList {
            books = bookList
            tableView.reloadData()
            let calculator = DiscountCalculator()
            calculator.applyDiscount(books: books) { (finalPrice) in
                self.totalPriceLabel.text = String(format: "%.02f €", calculator.initialPrice(books: self.books))
                let discount = calculator.initialPrice(books: self.books) - finalPrice
                self.discountPriceLabel.text = String(format: "%.02f €", discount)
                self.finalPriceLabel.text = String(format: "%.02f €", finalPrice)

            }
        } else {
            //If there was an error, show an error message
            self.presentAlert(title: "Erreur",
                              message: "Nous n'avons pas pu accéder à votre panier. " +
                                       "Veuillez réessayer plus tard.")
        }
    }
}

// MARK: - Tableview datasource
extension CartController: UITableViewDataSource, CartCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath)
            as? CartCell else {
                return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(book: books[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        //slide to delete all copies of a book
        if editingStyle == .delete {
            cart.deleteAllCopies(book: books[indexPath.row], completion: { success in
                if success {
                    self.refreshBookList()
                } else {
                    self.presentAlert(title: "Erreur",
                                      message: "Une erreur est survenue. Veuillez réessayer plus tard.")
                }
            })
        }
    }

    func didTap(_ cell: CartCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let index = indexPath?.row {
            let book = books[index]
            if Int(cell.stepper.value) > book.quantity {
                //if stepper increased, add a copy of the book to the cart
                cart.addToCart(book: book, completion: { success in
                    if success {
                        cell.quantityLabel.text = "Qté: \(Int(cell.stepper.value))"
                        self.refreshBookList()
                    } else {
                        self.presentAlert(title: "Erreur",
                                          message: "Une erreur est survenue. Veuillez réessayer plus tard.")
                    }
                })
            } else {
                //else, remove a copy of the book from the cart
                cart.deleteFromCart(book: book, completion: { success in
                    if success {
                        cell.quantityLabel.text = "Qté: \(Int(cell.stepper.value))"
                        self.refreshBookList()
                    } else {
                        self.presentAlert(title: "Erreur",
                                          message: "Une erreur est survenue. Veuillez réessayer plus tard.")
                    }
                })
            }
        }
    }
}
