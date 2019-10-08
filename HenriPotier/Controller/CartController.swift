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
    private var books = [BookData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //puts uiview instead of empty cells at the end of the tableview
        tableView.tableFooterView = UIView()
        totalLabel.text = "Total:"
        discountLabel.text = "Remise:"
        finalLabel.text = "Prix final:"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //todo books = bookdata
        let bookList = BookStorageManager().fetchBookData()
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
        if editingStyle == .delete {
            self.books.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
