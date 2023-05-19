//
//  LoginTextList.swift
//  SecureStore
//
//  Created by macSlm on 26.02.2023.
//

import Foundation

class TextList {
    
    static let shared = TextList()

    
    //Login UI
    struct LoginTextList1 {
        var userNameFieldPlaceholder: String
        var passwordFieldPlaceholder: String
        var confirmPasswordFieldPlaceholder: String
        var signUpButtonTitle: String
        var signInButtonTitle: String
        var messageErrorLogin: String
        var messageErrorPassword: String
        var messageSuccess: String
        var messageFieldsEmpty: String
        var messagePasswordsDontMatch: String
        var messageUserNameCannotSpace: String
        var messageUserNameTaken: String
    }
    



//    func getloginUI() -> LoginTextList{
//        if GlobalSettings.shared.language == "EN" {
//            return getEnglishUI()
//        } else {
//            return getRussianUI()
//        }
//    }
//
//    private func getEnglishUI() -> LoginTextList {
//        return LoginTextList(
//            userNameFieldPlaceholder: "Username",
//            passwordFieldPlaceholder: "Password",
//            confirmPasswordFieldPlaceholder: "Confirm Password",
//            signUpButtonTitle: "Sign Up",
//            signInButtonTitle: "Sign In",
//            messageErrorLogin: "Error Login",
//            messageErrorPassword: "Error Password",
//            messageSuccess: "Success",
//            messageFieldsEmpty: "Some fields are empty",
//            messagePasswordsDontMatch: "Passwords do not match",
//            messageUserNameCannotSpace: "Username cannot contain a space",
//            messageUserNameTaken: "User name already taken"
//        )
//    }
//
//    private func getRussianUI() -> LoginTextList {
//        return LoginTextList(
//            userNameFieldPlaceholder: "Имя пользователя",
//            passwordFieldPlaceholder: "Пароль",
//            confirmPasswordFieldPlaceholder: "Подтверждение пароля",
//            signUpButtonTitle: "Создать запись",
//            signInButtonTitle: "Войти",
//            messageErrorLogin: "Неправильный логин",
//            messageErrorPassword: "Неправильный пароль",
//            messageSuccess: "Успешно",
//            messageFieldsEmpty: "Одно из полей пустое",
//            messagePasswordsDontMatch: "Пароли не совпадают",
//            messageUserNameCannotSpace: "Имя пользователя не должно содержать пробел",
//            messageUserNameTaken: "Такой пользователь уже существует"
//        )
//    }
}
