//
//  LocalizeExtentionString.swift
//  SecureStore
//
//  Created by macSlm on 18.05.2023.
//

import Foundation

extension String {
    func localized() -> String {
        NSLocalizedString(self, tableName: "LocalizableTexts", bundle: .main, value: self, comment: "")
    }
}
