//
//  CoreDataManager.swift
//  SecureStore
//
//  Created by macSlm on 18.02.2023.
//

import Foundation
import CoreData
import UIKit



class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUser(name: String, passwordHash: String) -> Bool {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return false}
        let user = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! User
        user.name = name
        user.passwordHash = passwordHash
        
        do {
            try managedContext.save()
        } catch let error {
            print (error.localizedDescription)
            return false
        }
        return true
    }
    
    func fetchUsers() -> [User] {
        var users: [User] = []
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error {
            print(error.localizedDescription)
        }
        return users
    }
}
