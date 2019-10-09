//
//  BookView.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 04/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

//View that is used in BookCell, with the title of the book, the price and the cover
class BookView: UIView {
    @IBOutlet weak var coverImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    //Initalisation of the xib
    private func commonInit() {
        //Load xib by name
        let contentView = Bundle.main.loadNibNamed(selfName(), owner: self, options: nil)?.first as? UIView ?? UIView()
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.frame = bounds
        addSubview(contentView)
    }

    //Called by owner view, pass book data in parameter to set view
    func setView(book: Book) {
        titleLabel.text = book.title
        priceLabel.text = "\(book.price) €"
        guard let url = URL(string: book.cover) else {
            return
        }
        coverImgView.af_setImage(withURL: url)
    }

    //Get class name and turn it to a string
    private func selfName() -> String {
        let thisType = type(of: self)
        return String(describing: thisType)
    }
}
