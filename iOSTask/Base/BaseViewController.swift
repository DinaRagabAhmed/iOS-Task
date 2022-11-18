//
//  BaseViewController.swift
//  iOSTask
//
//  Created by Dina Ragab on 15/11/2022.
//

import UIKit
import Toast_Swift

class BaseViewController: UIViewController {
    
    var activityView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setupBindings(baseViewModel: BaseViewModel) {
        baseViewModel.isActivityIndicatorHidden.observe(on: self) { [weak self] shouldHideLoading in
            shouldHideLoading ? self?.hideLoading() : self?.showLoading()
        }
        
        //Errors observable to handle different kinds of errors
        baseViewModel.errorsObservable.observe(on: self) { [weak self] error in
            self?.handleErrors(error: error)
        }
        
        //Messages Observable to show message to user
        baseViewModel.messagesObservable.observe(on: self) { [weak self] message in
            if let message = message {
                self?.showMessageToUser(message: message)
            }
        }
    }
    
    func handleErrors(error: NetworkError?) {
        DispatchQueue.main.async { [weak self] in
            if let error = error {
                switch error {
                case .networkError:
                    self?.showToast(message: "networkError".localized())
                default:
                    self?.showToast(message: "generalError".localized())
                }
            }
        }
    }
    
    func showMessageToUser(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.showToast(message: message)
        }
    }
    
    func showLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = false
            self.activityView = UIActivityIndicatorView(style: .large)
            self.activityView?.center = self.view.center
            self.view.addSubview(self.activityView!)
            self.activityView?.startAnimating()
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.view.isUserInteractionEnabled = true
            if (self.activityView != nil){
                self.activityView?.stopAnimating()
                self.activityView = nil
            }
        }
    }
    
    func showToast(message: String) {
        self.view.makeToast(message)
    }
}
