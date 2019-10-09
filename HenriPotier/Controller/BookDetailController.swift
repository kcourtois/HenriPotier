//
//  BookDetailController.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit
import RealmSwift

class BookDetailController: UIViewController {
    @IBOutlet weak var bookView: BookView!
    @IBOutlet weak var synopsisTitleLabel: UILabel!
    @IBOutlet weak var synopsisDetailLabel: UILabel!
    @IBOutlet weak var addToCartButton: UIButton!

    var book: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        synopsisDetailLabel.textAlignment = .justified
        if let book = book {
            bookView.setView(book: book)
            synopsisTitleLabel.text = "Synopsis:"
            synopsisDetailLabel.text = book.synopsis
            addToCartButton.setTitle("Ajouter au panier", for: .normal)
        }
    }

    @IBAction func addToCart() {
        if let book = book {
            let cart = Cart()
            cart.addToCart(book: book)
            presentAlertDelay(title: "Ajout au panier",
                              message: "Votre livre a été ajouté au panier avec succès",
                              delay: 2)
        } else {
            //TODO: Error
        }
    }

    //Creates an alert with a title and a message that stays on screen for given delay
    func presentAlertDelay(title: String, message: String, delay: Double) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        let when = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: when) {
            alert.dismiss(animated: true, completion: nil)
        }
    }
}
