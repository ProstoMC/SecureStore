//
//  CoreDataManager.swift
//  SecureStore
//
//  Created by macSlm on 18.02.2023.
//

import Foundation
import CoreData
import UIKit
import CryptoKit



class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let managedContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func saveUser(name: String, passwordHash: String) -> User? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "User", in: managedContext) else { return nil}
        let user = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! User
        user.name = name
        user.passwordHash = passwordHash
        
        do {
            try managedContext.save()
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return user
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
    
    
    func createBoard(user: User, boardName: String, type: String, id: Int) -> Board? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Board", in: managedContext) else { return nil}
        let board = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Board
        board.name = boardName
        board.type = type
        board.user = user
        board.id = Int64(id)
        board.status = false
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return board
    }
    
    func getBoards(user: User) -> [Board] {
        var boards: [Board] = []
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

// MARK:  - CREATING UNITS

extension CoreDataManager {
    
    func createImageUnit(board: Board, unitType: String, data: Data, id: Int) -> BoardUnit? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "BoardUnit", in: managedContext) else { return nil}
        let boardUnit = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! BoardUnit
        boardUnit.board = board
        boardUnit.data = data
        boardUnit.type = unitType
        boardUnit.id = Int64(id)
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return boardUnit
    }
    
    func createTextUnit(board: Board, unitType: String, text: String, id: Int) -> BoardUnit? {
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "BoardUnit", in: managedContext) else { return nil}
        let boardUnit = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! BoardUnit
        boardUnit.board = board
        boardUnit.type = unitType
        boardUnit.text = text
        boardUnit.id = Int64(id)
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return boardUnit
    }
    
    func createToDoUnit(board: Board, unitType: String, id: Int) -> BoardUnit? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "BoardUnit", in: managedContext) else { return nil }
        let boardUnit = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! BoardUnit
        boardUnit.board = board
        boardUnit.type = unitType
        boardUnit.id = Int64(id)
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return boardUnit
    }
    
    
    
    // MARK:  - ANY ACTIONS WHITH UNITS
    
    func getUnits(board: Board) -> [BoardUnit] {
        var units: [BoardUnit] = []
        guard let unitsElements = board.units else { return [] }
        
        for element in unitsElements {
            let unit = element as! BoardUnit
            units.append(unit)
            //print (unit.type ?? "Error getting")
        }
        return units
    }
    
    func deleteUnit(unit: BoardUnit) -> Bool{
        managedContext.delete(unit)
        if saveChanges() {
            return true
        } else {
            return false
        }
    }
}

// MARK:  - TASKS

extension CoreDataManager {
    
    func createTask(board: Board, name: String, id: Int) -> Task? {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Task", in: managedContext) else { return nil }
        let task = NSManagedObject(entity: entityDescription, insertInto: managedContext) as! Task
        task.board = board
        task.name = name
        task.id = Int64(id)
        task.complited = false
        
        do {
            try managedContext.save()
            print ("Succeess saving to CoreData")
        } catch let error {
            print (error.localizedDescription)
            return nil
        }
        return task
    }
    
    func changeTaskStatus(task: Task) -> Bool {
        task.complited.toggle()
        if saveChanges() { return true }
        else { return false }
    }
    
    func changeTaskName(task: Task, newName: String) -> Bool {
        task.name = newName
        if saveChanges() { return true }
        else { return false }
    }
    
    func getTasks(board: Board) -> [Task] {
        var tasks: [Task] = []
        guard let tasksElements = board.tasks else { return [] }
        
        for element in tasksElements {
            let task = element as! Task
            tasks.append(task)
            //print (unit.type ?? "Error getting")
        }
        return tasks
    }
    
    func deleteTask(task: Task) -> Bool {
        managedContext.delete(task)
        if saveChanges() {
            return true
        } else {
            return false
        }
    }
}

// MARK:  - ENCRYPTION

extension CoreDataManager {
    func encryptString(string: String) -> String {
        
        let computed = Insecure.MD5.hash(data: string.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
    }
}


