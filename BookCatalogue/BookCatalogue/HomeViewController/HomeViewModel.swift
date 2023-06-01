//
//  HomeViewModel.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import Foundation

struct Book {
    let title: String
    let author: String
    let thumbnailURL: URL
}

class HomeViewModel {
    var updateUI:(()->())?
    
    var books: [Book] = [] {
        didSet {
            updateUI?()
        }
    }
    
    func searchBooks(by bookName: String, completion: @escaping (Error?)-> Void) {
        NetworkManager.shared.fetchBook(with: bookName) {[weak self] bookData, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }

            DispatchQueue.main.async {
                completion(nil)
                self?.books = bookData ?? []
            }

        }
    }
}
