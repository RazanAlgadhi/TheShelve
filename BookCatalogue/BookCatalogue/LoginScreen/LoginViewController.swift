//
//  LoginViewController.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import UIKit

class LoginViewController: UIViewController {

    private let loaderView = CustomLoaderView()
    var loginTask: Task<Void, Never>?
    var isPasswordEyeClosed: Bool = true
    private var viewModel: LoginViewModel!
    
    init(viewModel: LoginViewModel) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.layer.cornerRadius = 18.0
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        view.axis = .vertical
        view.spacing = 5
        return view
    }()
    
    private lazy var headerImageView: UIImageView = {
        let view = UIImageView()
        let w = UIScreen.main.bounds.width
        view.image = UIImage(named: "loginBG")
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant:  w),
            view.heightAnchor.constraint(equalToConstant: UIDevice.current.orientation.isLandscape ? 44 : 150),
            
        ])
        return view
    }()


    private lazy var headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerImageView)
        headerViewHeightCons = view.heightAnchor.constraint(equalToConstant: 150)
        NSLayoutConstraint.activate([
            headerImageView.topAnchor.constraint(equalTo: view.topAnchor),
            headerImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            headerViewHeightCons!
        ])
        return view
    }()

     var headerViewHeightCons: NSLayoutConstraint!

    private lazy var loginTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        view.textColor = UIColor.black
        view.text = "Welcome,"
        view.textAlignment = .left
        view.font = UIFont.boldSystemFont(ofSize: 27)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var loginSubTitleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        view.textAlignment = .left
        view.text = "Enter your email and password to continue."
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    private lazy var loginEmailView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter email"
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var loginPasswordView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    private lazy var loginButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(red: 87/255, green: 107/255, blue: 197/255, alpha: 1.0)
        view.setTitle("Login", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(loginTapped))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.layer.cornerRadius = 22
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44)
            
        ])
        return view
    }()

    private lazy var registerButton: UIButton = {
        let view = UIButton()
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = UIColor(red: 87/255, green: 107/255, blue: 197/255, alpha: 1.0)
        view.setTitle("Register", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        let gesture = UITapGestureRecognizer(target: self, action: #selector(registerTapped))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.layer.cornerRadius = 22
        NSLayoutConstraint.activate([
            view.heightAnchor.constraint(equalToConstant: 44)

        ])
        return view
    }()



    private func  loginContainerView(isLandScape: Bool) -> UIView {

        let view = UIView()
        view.addSubview(loginTitleLabel)
        view.addSubview(loginSubTitleLabel)
        view.addSubview(loginEmailView)
        view.addSubview(loginPasswordView)
        view.addSubview(loginButton)
        view.addSubview(registerButton)
        view.translatesAutoresizingMaskIntoConstraints = false

        if !isLandScape {
            NSLayoutConstraint.activate([
                loginTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
                loginTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                loginTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loginTitleLabel.heightAnchor.constraint(equalToConstant: 22.0),

                loginSubTitleLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 8),
                loginSubTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                loginSubTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),


                loginEmailView.topAnchor.constraint(equalTo: loginSubTitleLabel.bottomAnchor, constant: 34),
                loginEmailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginEmailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

                loginPasswordView.topAnchor.constraint(equalTo: loginEmailView.bottomAnchor, constant: 24),
                loginPasswordView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginPasswordView.trailingAnchor.constraint(equalTo: view.trailingAnchor),


                loginButton.topAnchor.constraint(equalTo: loginPasswordView.bottomAnchor, constant: 34),
                loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),


                registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 34),
                registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                loginTitleLabel.topAnchor.constraint(equalTo: view.topAnchor),
                loginTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                loginTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                loginTitleLabel.heightAnchor.constraint(equalToConstant: 22.0),

                loginSubTitleLabel.topAnchor.constraint(equalTo: loginTitleLabel.bottomAnchor, constant: 8),
                loginSubTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                loginSubTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),


                loginEmailView.topAnchor.constraint(equalTo: loginSubTitleLabel.bottomAnchor, constant: 16),
                loginEmailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginEmailView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),

                loginPasswordView.topAnchor.constraint(equalTo: loginEmailView.bottomAnchor, constant: 16),
                loginPasswordView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginPasswordView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),


                loginButton.topAnchor.constraint(equalTo: loginPasswordView.bottomAnchor, constant: 16),
                loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),


                registerButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
                registerButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                registerButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -44),
                registerButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        return view
    }
    
    var appNavigationController: AppNavController? {
        
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else { return nil }
        return sceneDelegate.appNavigationController
    }
    
    
    @objc func loginTapped(tapGestureRecognizer: UIGestureRecognizer) {

        showLoader()
        viewModel.loginUser { [weak self] result, error in
            self?.hideLoader()
            if let error = error {
                self?.presentAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Dismiss")
                return
            }
            self?.appNavigationController?.showHomeViewController()
        }



    }

    @objc func registerTapped(tapGestureRecognizer: UIGestureRecognizer) {

        guard let email = viewModel.email, let password = viewModel.password, !email.isEmpty, !password.isEmpty else {
            self.presentAlert(title: "Error", message: "Please, enter email or password", buttonTitle: "Dismiss")
            return

        }
        showLoader()
        viewModel.registerUser { [weak self] result, error in
            self?.hideLoader()
            if let error = error {
                self?.presentAlert(title: "Error", message: error.localizedDescription, buttonTitle: "Dismiss")
                return
            }
            self?.appNavigationController?.showHomeViewController()
        }



    }
    


    private lazy var scrollView: VerticalScrollView = {
        let view = VerticalScrollView()
        let contentView = view.contentView
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            stackView.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        view.enableContentInsetChangeWithKeyboardAppearance()
        return view
    }()
    
}


extension LoginViewController {
    
    func configureAppearance() {
        self.view.backgroundColor = UIColor.white
    }
    
    func configureSubviews() {
        view.addSubview(scrollView)
        view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: topLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
        ])

    }

}




//MARK:- API call
extension LoginViewController {
    
    
    private func login() {
        
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var tf = textField.text else{
            return true
        }
        if let textRange = Range(range,in: tf) {
            tf = tf.replacingCharacters(in: textRange, with: string)
        }
        //email
        if loginEmailView == textField {
            viewModel.email = tf
        }
        //password
        if loginPasswordView == textField {
            viewModel.password = tf
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == loginEmailView, let email = textField.text {
            viewModel.email = email
        }
        
        if textField == loginPasswordView, let pass = textField.text {
            viewModel.password = pass
        }
    }
    
}

extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureSubviews()
        setupLoaderView()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.hideLoader()
        NotificationCenter.default.addObserver(self, selector: #selector(self.orientationChanged), name: UIApplication.didChangeStatusBarOrientationNotification, object: nil)

        if UIApplication.shared.statusBarOrientation == .landscapeLeft {
            applyLandscapeConstraints()
        } else {

            applyPortraitConstraints()
        }

    }
    @objc func orientationChanged(notification: NSNotification) {
            let deviceOrientation = UIApplication.shared.statusBarOrientation

            switch deviceOrientation {
            case .portrait:
                fallthrough
            case .portraitUpsideDown:
                print("Portrait")
                self.applyPortraitConstraints()

            case .landscapeLeft:
                fallthrough
            case .landscapeRight:
                print("landscape")
                self.applyLandscapeConstraints()
            case .unknown:
                print("unknown orientation")
            @unknown default:
                print("unknown case in orientation change")
            }
        }

    func applyPortraitConstraints() {
        stackView.removeAllArrangedSubviews()
        stackView.addSpace(24)
        let loginContainerView = loginContainerView(isLandScape: false)
        headerViewHeightCons.constant = 150
        stackView.addArrangedSubview(loginContainerView)
    }

    func applyLandscapeConstraints() {
        stackView.removeAllArrangedSubviews()
        stackView.addSpace(24)
        let loginContainerView = loginContainerView(isLandScape: true)
        headerViewHeightCons.constant = 44
        stackView.addArrangedSubview(loginContainerView)
    }

    private func setupLoaderView() {
        loaderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loaderView)

        NSLayoutConstraint.activate([
            loaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loaderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loaderView.widthAnchor.constraint(equalToConstant: 100),
            loaderView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    private func showLoader() {
        loaderView.startAnimating()
    }

    private func hideLoader() {
        loaderView.stopAnimating()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // reset password text if logout happens or every time screen appears
        loginPasswordView.text = ""

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
