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
            //Add book to the cart
            cart.addToCart(book: book, completion: { success in
                if success {
                    //If it was a success, show an alert for success
                    self.presentAlertDelay(title: "Ajout au panier",
                                      message: "Votre livre a été ajouté au panier avec succès",
                                      delay: 2)
                } else {
                    //If there was an error, show an error message
                    self.presentAlert(title: "Erreur",
                                      message: "Nous n'avons pas pu ajouter ce livre à votre panier. " +
                                               "Veuillez réessayer plus tard")
                }
            })
        } else {
            //If there was an error, show an error message
            self.presentAlert(title: "Erreur",
                              message: "Nous n'avons pas pu ajouter ce livre à votre panier. " +
                                       "Veuillez réessayer plus tard")
        }
    }
}
