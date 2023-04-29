//
//  LoginModels.swift
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

enum Login
{
  // MARK: Use cases
  
    enum Login
    {
        struct Request {
            var userName: String?
            var password: String?
            
        }
        struct Response {
            var success: Bool
        }
        struct ViewModel {
            
        }
    }
    enum SignUp
    {
        struct Request {
            var userName: String?
            var password: String?
            var confirmPassword: String?
            
        }
        struct Response {
            var success: Bool
            var errorMessage: String
        }
        struct ViewModel {
            struct Alert {
                var title: String
                var message: String
                var buttonTitle: String
            }
        }
    }
    enum ShowAlert {
        struct Request {
            
        }
        struct Response {
            var title: String
            var errorMessage: String
        }
        struct ViewModel {
            var title: String
            var message: String
            var buttonTitle: String
        }
        
    }
    enum Texts {
        struct Request {
            
        }
        struct Response {
            var defaultUserName: String?
        }
        struct ViewModel {
            var defaultUserName: String
            var textList: TextList.LoginTextList
        }
    }
    
    
    
}
