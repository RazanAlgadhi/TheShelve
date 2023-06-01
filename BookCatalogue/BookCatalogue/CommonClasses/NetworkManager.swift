//
//  NetworkManager.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import Foundation
import Firebase

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}

    private lazy var session : URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(20)
        configuration.timeoutIntervalForResource = TimeInterval(40)
        let session = URLSession.init(configuration: configuration)
        return session
    }()
    
    func fetchBook(with bookName: String, completion: @escaping ([Book]?, Error?) -> Void) {
            guard let encodedBookName = bookName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
                print("Invalid book name")
                return
            }

            guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(encodedBookName)") else {
                print("Invalid URL")
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    completion(nil, error)
                    return
                }

                guard let data = data else {
                    print("No data received")
                    completion([], nil)
                    return
                }

                do {
                    var books: [Book] = []
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], let items = json["items"] as? [[String: Any]] {
                        for item in items {
                            if let volumeInfo = item["volumeInfo"] as? [String: Any],
                               let title = volumeInfo["title"] as? String,
                               let authors = volumeInfo["authors"] as? [String],
                               let imageLinks = volumeInfo["imageLinks"] as? [String: String], let thumbnailURLString = imageLinks["thumbnail"], let thumbnailURL = URL(string: thumbnailURLString) {

                                print(title, thumbnailURL)
                                let book = Book(title: title, author: authors.joined(separator: ", "), thumbnailURL: thumbnailURL)
                                books.append(book)
                            }
                        }
                        completion(books, nil)
                    } else {
                        completion([], nil)
                        print(response)
                    }
                }
                catch {
                    print("Error parsing JSON: \(error)")
                    completion([], nil)
                }
            }
            task.resume()
        }

    func registerUser(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error registering user: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User registered successfully.")
                completionHandler(authResult, nil)
                // Handle successful user registration, such as navigating to the main app screen
            }
        }
    }

    func loginUser(email: String, password: String, completionHandler: @escaping (AuthDataResult?, Error?)->())  {
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let error = error {
                print("Error logging in: \(error.localizedDescription)")
                completionHandler(nil, error)
            } else {
                print("User logged in successfully.")
                completionHandler(authResult, nil)
            }
        }
    }
}
