//
//  LoginPresenter.swift
//  SecureStore
//
//  Created by macSlm on 16.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginPresentationLogic {
    func showAlert(response: Login.ShowAlert.Response)
    func presentUserName(response: Login.Texts.Response)
    func moveToMainlist()
}

class LoginPresenter: LoginPresentationLogic {
   
    func showAlert(response: Login.ShowAlert.Response) {
        let title = ""
        let message = response.errorMessage
        let buttonTitle = "Ok"
        
        let viewModel = Login.ShowAlert.ViewModel(title: title, message: message, buttonTitle: buttonTitle)
        viewController?.clearTextFields()
        viewController?.showAlert(viewModel: viewModel)
        
    }
    

    weak var viewController: LoginDisplayLogic?
  
    // MARK: Do something
    
    func presentUserName(response: Login.Texts.Response) {
        let viewModel = Login.Texts.ViewModel(defaultUserName: response.defaultUserName ?? "")
        viewController?.setupUI(viewModel: viewModel)

    }
    func moveToMainlist() {
        viewController?.moveToMainList()
    }
    
    
}
