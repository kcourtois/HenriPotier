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
            synopsisDetailLabel.text = book.getSynopsis()
            addToCartButton.setTitle("Ajouter au panier", for: .normal)
        }
    }

    @IBAction func addToCart() {
        if let book = book {
            let storage = BookStorageManager()
            _ = storage.insertBook(book: book)
            storage.save()
        }
    }
}
