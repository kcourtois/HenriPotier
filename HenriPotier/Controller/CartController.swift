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
        //Notification observer for didUpdateBookQuantity
        NotificationCenter.default.addObserver(self, selector: #selector(onDidSendUpdateBookQuantity),
                                               name: .didSendUpdateBookQuantity, object: nil)
        refreshBookList()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //remove observers on view disappear
        NotificationCenter.default.removeObserver(self, name: .didSendUpdateBookQuantity, object: nil)
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
        if books != bookList {
            books = bookList
            tableView.reloadData()
            let calculator = DiscountCalculator()
            calculator.applyDiscount(books: books) { (finalPrice) in
                self.totalPriceLabel.text = String(format: "%.02f €", calculator.initialPrice(books: self.books))
                let discount = calculator.initialPrice(books: self.books) - finalPrice
                self.discountPriceLabel.text = String(format: "%.02f €", discount)
                self.finalPriceLabel.text = String(format: "%.02f €", finalPrice)

            }
        }
    }

    //Triggers on notification didSendUpdateBookQuantity
    @objc private func onDidSendUpdateBookQuantity(_ notification: Notification) {
        refreshBookList()
    }
}

// MARK: - Tableview datasource
extension CartController: UITableViewDataSource {
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

        cell.configure(book: books[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        //slide to delete all copies of a book
        if editingStyle == .delete {
            cart.deleteAllCopies(book: books[indexPath.row])
            refreshBookList()
        }
    }
}
