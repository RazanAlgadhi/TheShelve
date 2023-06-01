//
//  Extension+Views.swift
//  BookCatalogue
//
//  Created by pc on 23/05/23.
//

import Foundation
import UIKit

class VerticalScrollView: UIScrollView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        showsVerticalScrollIndicator = false
        
        configureSubviews()
        
        enableContentInsetChangeWithKeyboardAppearance()
    }

    func configureSubviews() {
        addSubview(self.contentView)
        contentView.addConstraintsToFit(self)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: widthAnchor),
        ])
        
       
        let contentViewHeightConstraint = contentView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor)
        contentViewHeightConstraint.priority = UILayoutPriority(rawValue: 250)
        contentViewHeightConstraint.isActive = true
    }
    
    lazy var contentView: UIView = {
        var _contentView = UIView()
        return _contentView
        
    }()
}

extension UIStackView {
    
    @discardableResult
    func addSpace(_ size: CGFloat) -> UIView{
        let space = UIView()
        space.backgroundColor = .clear
        if axis == .horizontal {
            space.widthAnchor.constraint(equalToConstant: size).isActive = true
        } else {
            space.heightAnchor.constraint(equalToConstant: size).isActive = true
        }
        addArrangedSubview(space)
        return space
    }
    
    
}


extension UIView {
    
    func addConstraintsToFit(_ view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: view.leftAnchor),
            rightAnchor.constraint(equalTo: view.rightAnchor),
            topAnchor.constraint(equalTo: view.topAnchor),
            bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension UIScrollView {

    func enableContentInsetChangeWithKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc private func keyboardWillHideNotification(_ notification: Notification) {
        updateContentInsets(shown: false, notification: notification)
    }
    
    @objc private func keyboardWillShowNotification(_ notification: Notification) {
        updateContentInsets(shown: true, notification: notification)
    }
    
    private func updateContentInsets(shown: Bool, notification: Notification) {
        guard bounds.width > 0, bounds.height > 0 else {
            return
        }
        
        guard contentSize.width > 0, contentSize.height > 0 else {
            assertionFailure("Invalid 0 width/height for scrollView.contentSize: \(contentSize)")
            return
        }
        
        guard let info = notification.userInfo,
            let kbSize = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
                return
        }

        let kbFrame = kbSize.cgRectValue
        let yOffset = shown ? kbFrame.height : 0
        
        let newContentInset = UIEdgeInsets(top: contentInset.top,
                                           left: contentInset.left,
                                           bottom: yOffset,
                                           right: contentInset.right)
        contentInset = newContentInset
        scrollIndicatorInsets = newContentInset
    }
}


extension UIViewController {
    func presentAlert(title: String, message: String, buttonTitle: String, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { (_) in
            completion?()
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension UIStackView {
    func removeAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        removedSubviews.forEach({
            $0.removeFromSuperview()
        })
    }
}
