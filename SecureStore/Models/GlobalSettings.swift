//
//  GlobalSettings.swift
//  SecureStore
//
//  Created by macSlm on 03.03.2023.
//

import Foundation

class GlobalSettings  {
    static let shared = GlobalSettings()
    
    var language = "EN"
    var rememberUserName = true
}

extension GlobalSettings {
    func saveUserNameToDefaults(userName: String){
        let userDefauls = UserDefaults.standard
        userDefauls.setValue(userName, forKey: "username")
    }
    func fetchUserNameFromDefaults() -> String? {
        let userDefauls = UserDefaults.standard
        let userName = userDefauls.string(forKey: "username")
        return userName
    }
    func removeUserNameFromDefaults(){
        let userDefauls = UserDefaults.standard
        userDefauls.removeObject(forKey: "username")
    }
}

