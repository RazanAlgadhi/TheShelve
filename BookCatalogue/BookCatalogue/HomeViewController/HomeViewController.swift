//
//  HomeViewController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    private var viewModel: HomeViewModel!
    
    
    init(viewModel: HomeViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = HomeViewModel()
    }

    var appNavigationController: AppNavController? {

        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return nil }
        return sceneDelegate.appNavigationController
    }

    private lazy var logoutButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(red: 87/255, green: 107/255, blue: 197/255, alpha: 1.0)
        view.setTitle("Logout", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(logoutTapped))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.layer.cornerRadius = 22
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44)

        ])
        return view
    }()

    @objc func logoutTapped() {
        logout()
    }

    func UpdateUI() {
        self.viewModel.updateUI = {[weak self] in
            if self?.viewModel.books.count ?? 0 == 0 {
                self?.noItemTitle.isHidden = false
            }else{
                self?.noItemTitle.isHidden = true
                self?.collectionView.reloadData()
            }
        }
    }
    
    
    private lazy var noItemTitle: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "no item yet"
        view.textColor = UIColor.black
        view.font = UIFont.boldSystemFont(ofSize: 18.0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.text = "Home"
        view.textColor = UIColor.black
        view.textAlignment = .right
        view.font = UIFont.boldSystemFont(ofSize: 22)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private lazy var collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let  collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.dataSource = self
        collectionview.delegate = self
        collectionview.backgroundColor = UIColor.white
        collectionview.register(HomeBookCollectionViewCell.self, forCellWithReuseIdentifier: "HomeBookCollectionViewCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
    }()

    private lazy var searchbar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .default
        searchBar.placeholder = " Search Book Name....."
        searchBar.sizeToFit()
        return searchBar
    }()




    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.backgroundColor = UIColor.black
        activityIndicator.layer.cornerRadius = 8.0
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.widthAnchor.constraint(equalToConstant: 84.0).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 84.0).isActive = true
        return activityIndicator
    }()
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        viewModel.searchBooks(by: "Herry Potter", completion: { [weak self] error in
            self?.activityIndicator.stopAnimating()
            if let error = error {
                self?.showAlert(title: "Error", message: error.localizedDescription, okAction: {
                    self?.dismiss(animated: true)
                })
            }
        })
    }



    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        UpdateUI()
        self.view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(logoutButton)
        view.addSubview(titleLabel)
        view.addSubview(searchbar)
        view.addSubview(activityIndicator)

        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        searchbar.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

            logoutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            logoutButton.widthAnchor.constraint(equalToConstant: 84),
            logoutButton.heightAnchor.constraint(equalToConstant: 44.0),
            logoutButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: logoutButton.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),

            searchbar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 18),
            searchbar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            searchbar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            searchbar.heightAnchor.constraint(equalToConstant: 44.0),
            collectionView.topAnchor.constraint(equalTo: searchbar.bottomAnchor, constant: 18),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

}


extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeBookCollectionViewCell", for: indexPath) as? HomeBookCollectionViewCell else {
                fatalError("crash")
            }
        let data =  self.viewModel.books[indexPath.item]
        cell.model = data
        
        cell.favHandlerHome = {
            DataManager.shared.saveBooks(book: data)
            self.showToast(message: "Your Image Saved", font: .systemFont(ofSize: 12.0))
        }
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = self.view.bounds.size.width/2 - 24
        return CGSize(width: w, height: 180)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
}

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // Perform search action when the user taps the search button on the keyboard
        if let searchText = searchBar.text, searchText.count > 2 {
            activityIndicator.startAnimating()
            viewModel.searchBooks(by: searchText, completion: { [weak self] error in
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription, okAction: {
                        self?.dismiss(animated: true)
                    })
                }
            })
        }

        // Dismiss the keyboard
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // Clear the search text and dismiss the keyboard when the user taps the cancel button
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text, searchText.count > 2 {
            activityIndicator.startAnimating()
            viewModel.searchBooks(by: searchText, completion: { [weak self] error in
                self?.activityIndicator.stopAnimating()
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription, okAction: {
                        self?.dismiss(animated: true)
                    })
                }
            })
        }

    }
}

extension UIViewController {
    
    func showToast(message : String, font: UIFont) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-130, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.white
        toastLabel.textColor = UIColor.black
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 17.0;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }

extension HomeViewController {


    func logout() {
        do {
                try Auth.auth().signOut()
            appNavigationController?.dismissPresentedViewContrllers()
            appNavigationController?.goToLoginScreen()
                // Additional cleanup or navigation code after logout
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError)")
            }

    }
}
