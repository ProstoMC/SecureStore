//
//  LoginInteractor.swift
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

protocol LoginBusinessLogic {
    func login(request: Login.Login.Request)
    func signUp(request: Login.SignUp.Request)
//    func toggleLanguage()
    func getDefaultUserName()
}

protocol LoginDataStore {
    var user: User? { get }
}

class LoginInteractor: LoginBusinessLogic, LoginDataStore {
    
    var user: User?
    
    var presenter: LoginPresentationLogic?
    var worker: LoginWorker?
    var router: LoginRouter?
    
    
    
    // MARK: - LOGIN
    
    func login(request: Login.Login.Request) {
        
        worker = LoginWorker()
        router = LoginRouter()
        
        let userName = request.userName
        let password = request.password
        let passwordHash = CoreDataManager.shared.encryptString(string: password ?? "")
        
        user = worker?.compareUsers(userName: userName ?? "", passwordHash: passwordHash)
        
        if user != nil {
            //Saving to User defaults -> We dont save username to userDafaults with login
            //GlobalSettings.shared.saveUserNameToDefaults(userName: userName!)
            presenter?.moveToMainlist()
        }
        else {
            let errorMessage = "Error Login".localized()
            let alert = Login.ShowAlert.Response(title: "", errorMessage: errorMessage)
            presenter?.showAlert(response: alert)
        }
        

        

    }
    
    // MARK: - SIGN UP
    
    func signUp(request: Login.SignUp.Request) {
     
        worker = LoginWorker()
        
        let userName = request.userName
        let password = request.password
        let confirmPassword = request.confirmPassword
        
        //Checking fields
        
        var errorMessage = worker?.check3Fields(userName: userName, password: password, confirmPassword: confirmPassword)
        
        if errorMessage != "Success".localized() {
            let alert = Login.ShowAlert.Response(title: "", errorMessage: errorMessage ?? "")
            presenter?.showAlert(response: alert)
            return
        }
        
        //Checking username in store
        
        guard worker?.checkUserInStore(userName: userName ?? "") == true else {
            errorMessage = "User name already taken".localized()
            let alert = Login.ShowAlert.Response(title: "", errorMessage: errorMessage ?? "")
            presenter?.showAlert(response: alert)
            return
        }
        
        //Encrypting Password
        
         let passwordHash = CoreDataManager.shared.encryptString(string: password!) 
 
        //Making User

        user = CoreDataManager.shared.saveUser(name: userName!, passwordHash: passwordHash)
        if user == nil {
            errorMessage = "Making user error".lowercased()
            let alert = Login.ShowAlert.Response(title: "", errorMessage: errorMessage ?? "")
            presenter?.showAlert(response: alert)
            return
        }
        
        //Login
        
        let request = Login.Login.Request(userName: userName, password: password)
        login(request: request)
        

    }
    
    // MARK: - TOGGLE LANGUAGE
    
//    func toggleLanguage() {
//        GlobalSettings.shared.toggleLanguage()
//        let userName = GlobalSettings.shared.fetchUserNameFromeDefaults()
//        let response = Login.Texts.Response(defaultUserName: userName)
//        presenter?.getLanguage(response: response)
//    }
    func getDefaultUserName() {
        let userName = GlobalSettings.shared.fetchUserNameFromDefaults()
        let response = Login.Texts.Response(defaultUserName: userName)
        presenter?.presentUserName(response: response)
    }

    
}
