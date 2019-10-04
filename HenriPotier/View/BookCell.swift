//
//  BookCell.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 04/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class BookCell: UITableViewCell {
    @IBOutlet weak var bookView: BookView!

    func configure(book: BookData) {
        bookView.setView(book: book)
    }
}
