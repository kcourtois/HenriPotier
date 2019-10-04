//
//  BookDetailController.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class BookDetailController: UIViewController {
    @IBOutlet weak var bookView: BookView!
    @IBOutlet weak var synopsisTitleLabel: UILabel!
    @IBOutlet weak var synopsisDetailLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!

    var book: BookData?

    override func viewDidLoad() {
        super.viewDidLoad()
        synopsisDetailLabel.textAlignment = .justified
        if let book = book {
            bookView.setView(book: book)
            synopsisTitleLabel.text = "Synopsis:"
            var synopsis = ""
            for text in book.synopsis {
                synopsis += "\(text)\n\n"
            }
            synopsisDetailLabel.text = synopsis
            addToCartButton.setTitle("Ajouter au panier", for: .normal)
        }
    }
}
