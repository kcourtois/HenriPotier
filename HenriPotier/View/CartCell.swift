//
//  CartCell.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 08/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

protocol CartCellDelegate: class {
    //func that is called when stepper is tapped
    func didTap(_ cell: CartCell)
}

class CartCell: UITableViewCell {
    @IBOutlet weak var bookView: BookView!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var quantityLabel: UILabel!
    weak var delegate: CartCellDelegate?

    //setup of the cell labels and views
    func configure(book: Book) {
        bookView.setView(book: book)
        quantityLabel.text = "Qté: \(book.quantity)"
        stepper.value = Double(book.quantity)
    }

    //call delegate func when stepper tapped
    @IBAction func stepperTapped(_ sender: Any) {
        delegate?.didTap(self)
    }
}
