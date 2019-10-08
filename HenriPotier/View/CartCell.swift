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

    func configure(book: BookData) {
        bookView.setView(book: book)
        if let qte = book.quantity {
            quantityLabel.text = "Qté: \(qte)"
        } else {
            quantityLabel.text = "Qté: \(0)"
        }
    }

    @IBAction func stepperTapped(_ sender: Any) {
        quantityLabel.text = "Qté: \(Int(stepper.value))"
    }
}
