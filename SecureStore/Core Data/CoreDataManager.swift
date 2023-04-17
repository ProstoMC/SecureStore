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
    
    func fetchUser(userName: String) -> User? {
        let users = fetchUsers()
        for user in users {
            if user.name == userName {
                return user
            }
        }
        return nil
    }
    
    func saveChanges() -> Bool {
        do {
            try managedContext.save()
            return true
        } catch let error {
            print(error.localizedDescription)
            return false
        }
    }
    
    
}

// MARK:  - Boards

extension CoreDataManager {
    
    
    func createBoard(userName: String, boardName: String) -> Board? {
        
        guard let user = fetchUser(userName: userName) else { return nil}
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Board", in: managedContext) else { return nil}
        let board = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Board
        board.name = boardName
        board.user = user
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return board
    }
    
    func getBoards(userName: String) -> [Board] {
        var boards: [Board] = []
        guard let user = fetchUser(userName: userName) else { return [] }
        guard let boardsElements = user.boards else { return [] }
        
        for element in boardsElements {
            let board = element as! Board
            boards.append(board)
            //print (board.name ?? "Error getting")
        }
        return boards
    }
    
    func deleteBoard(board: Board) -> Bool{
        managedContext.delete(board)
        if saveChanges() {
            return true
        } else {
            return false
        }
    }
    

    
    
    
}
