//
//  BookListController.swift
//  HenriPotier
//
//  Created by Kévin Courtois on 03/10/2019.
//  Copyright © 2019 Kévin Courtois. All rights reserved.
//

import UIKit

class BookListController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var books = [Book]()
    private var bookTapped: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        //puts uiview instead of empty cells at the end of the tableview
        tableView.tableFooterView = UIView()
        BookService().getBooks(completion: { result in
            switch result {
            case .failure(let error):
                print(error)
                return
            case .success(let res):
                self.books = res
                self.tableView.reloadData()
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Before segue to detail book, pass data to the controller
        if segue.identifier == "BookDetailSegue",
            let bookDetailVC = segue.destination as? BookDetailController {
            if let book = bookTapped {
                bookDetailVC.book = book
            } else {
                return
            }
        }
    }
}

// MARK: - Tableview datasource
extension BookListController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
            as? BookCell else {
                return UITableViewCell()
        }

        let book = books[indexPath.row]
        cell.configure(book: book)

        return cell
    }
}

// MARK: - Tableview delegare
extension BookListController: UITableViewDelegate {
    //On clic, perform segue to detail view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //set book tapped to pass data to the detail controller
        bookTapped = books[indexPath.row]
        //perform segue
        performSegue(withIdentifier: "BookDetailSegue", sender: self)
    }
}
