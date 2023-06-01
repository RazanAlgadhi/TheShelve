//
//  FavouriteViewController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private var viewModel: FavouriteViewModel!
    
    var books: [BooksDataBaseModel] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
    init(viewModel: FavouriteViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.viewModel = FavouriteViewModel()
    }
  
   
    func UpdateUI() {
        let data = DataManager.shared.getBooks()
        books = data
        if books.count == 0{
            noItemTitle.isHidden = false
        }else{
            noItemTitle.isHidden = true
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
        view.text = "Favourite Books"
        view.textColor = UIColor.black
        view.textAlignment = .left
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
        collectionview.register(FavouriteBookCollectionViewCell.self, forCellWithReuseIdentifier: "FavouriteBookCollectionViewCell")
        collectionview.showsVerticalScrollIndicator = false
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        return collectionview
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
        return activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        view.addSubview(titleLabel)
        view.addSubview(collectionView)
        view.addSubview(noItemTitle)
        noItemTitle.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noItemTitle.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
        
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
        
        ])
        
        DataManager.shared.getBooks().forEach { img in
            print(img.title ?? "")
        }
        
        
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UpdateUI()
    }

}


extension FavouriteViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteBookCollectionViewCell", for: indexPath) as? FavouriteBookCollectionViewCell else {
                fatalError("crash")
            }
        let data =  self.books[indexPath.item]
        cell.model = data
        cell.favHandler = { [weak self] in
            if let url = data.url{
                DataManager.shared.deleteImages(index: url)
                self?.UpdateUI()
                self?.showToast(message: "Your Image Deleted", font: .systemFont(ofSize: 12.0))
            }
        }
        
        return cell
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteBookCollectionViewCell", for: indexPath) as? FavouriteBookCollectionViewCell else {
                fatalError("crash")
            }
          let data =  self.books[indexPath.item]
        

        
    }
}

extension FavouriteViewController: UICollectionViewDelegateFlowLayout {
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

