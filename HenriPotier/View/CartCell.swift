//
//  CartCell.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 08/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {
    @IBOutlet weak var bookView: BookView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!

    var book: Book?

    func configure(book: Book) {
        self.book = book
        bookView.setView(book: book)
        quantityLabel.text = "Qté: \(book.quantity)"
        stepper.value = Double(book.quantity)
    }

    @IBAction func stepperTapped(_ sender: Any) {
        if let book = book {
            let cart = Cart()
            if Int(stepper.value) > book.quantity {
                cart.addToCart(book: book)
            } else {
                cart.deleteFromCart(book: book)
            }
            quantityLabel.text = "Qté: \(Int(stepper.value))"
        }
        postUpdateBookQuantityNotification()
    }

    //send sign in notification
    private func postUpdateBookQuantityNotification() {
        NotificationCenter.default.post(name: .didSendUpdateBookQuantity, object: nil, userInfo: nil)
    }
}
