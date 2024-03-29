//
//  MainListInteractor.swift
//  SecureStore
//
//  Created by macSlm on 03.03.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MainListBusinessLogic {
    func showUser(request: MainList.ShowUser.Request)
    func changeUserName(request: MainList.ChangeUserName.Request)
    func changePassword(request: MainList.ChangePassword.Request)
    func changeUserImage(request: MainList.ChangeUserImage.Request)
    func rememberingUserNameToggle(request: MainList.ChangeRememberingUserName.Request)
    
    func showBoards(request: MainList.ShowBoards.Request)
    func createNewBoard(request: MainList.CreateNewBoard.Request)
    func editBoardName(request: MainList.EditBoardName.Request)
    func deleteBoard(request: MainList.DeleteBoard.Request)
    func moveObjects(request: MainList.MoveObjects.Request)
    
    //func getCountOfBoards() -> Int
    func getBoard(request: MainList.GetBoard.Request) -> MainList.GetBoard.Response

    func getCountOfDataBoards() -> Int
    func getCountOfToDoBoards() -> Int
   

}

protocol MainListDataStore {
    var user: User! { get set }
    
   // var boards: [Board] { get }
    var toDoBoards: [Board] { get }
    var dataBoards: [Board] { get }
    
    
}

class MainListInteractor: MainListBusinessLogic, MainListDataStore {
    
    var user: User!
    //var boards: [Board] = []
    
    var toDoBoards: [Board] = []
    var dataBoards: [Board] = []

    
    //var name: String
    weak var viewController: MainListViewController?
    var presenter: MainListPresentationLogic?
    
    // MARK: - GETTING FROM DATASTORE
   
//    func getCountOfBoards() -> Int {
//        return boards.count
//    }
    func getCountOfDataBoards() -> Int {
        return dataBoards.count
    }
    func getCountOfToDoBoards() -> Int {
        return toDoBoards.count
    }
    
    func getBoard(request: MainList.GetBoard.Request) -> MainList.GetBoard.Response {
        var board = Board()
        
        if request.indexPath.section == 0 {
            board = toDoBoards[request.indexPath.row]
            
        } else if request.indexPath.section == 1 {
            board = dataBoards[request.indexPath.row]
        }
        let response = MainList.GetBoard.Response(
            indexPath: request.indexPath,
            name: board.name ?? "Error".localized(),
            type: board.type ?? BoardType.data,
            status: board.status)
        return response
    }
  
    // MARK:  - ACTIONS
    
    func showUser (request: MainList.ShowUser.Request) {
        let response = MainList.ShowUser.Response(user: user)
        presenter?.presentUser(response: response)
    }
    
    func showBoards (request: MainList.ShowBoards.Request) {
        let boards = CoreDataManager.shared.getBoards(user: user)
        for board in boards {
            if board.type == BoardType.data { dataBoards.append(board) }
            if board.type == BoardType.todo { toDoBoards.append(board) }
        }
        dataBoards.sort { (board1, board2) -> Bool in
            board1.id < board2.id
        }
        toDoBoards.sort { (board1, board2) -> Bool in
            board1.id < board2.id
        }
          
        let response = MainList.ShowBoards.Response()
        presenter?.presentBoards(response: response)
    }
    
    // MARK:  - User
    
    func rememberingUserNameToggle(request: MainList.ChangeRememberingUserName.Request) {
        user.rememberLoginOnUserDefaults = request.rememberingStatus
        print (user.rememberLoginOnUserDefaults)
        if !CoreDataManager.shared.saveChanges() {
            let response = MainList.DisplayMessage.Response(title: "Changing Failed".localized(), message: "Try Again".localized())
            presenter?.presentError(response: response)
        }
        
        if user.rememberLoginOnUserDefaults {
            GlobalSettings.shared.saveUserNameToDefaults(userName: user.name!)
        } else {
            GlobalSettings.shared.removeUserNameFromDefaults()
            
        }
    }
    
    
    // MARK:  - Boards
    func createNewBoard(request: MainList.CreateNewBoard.Request) {
        if request.type == BoardType.data {
            guard let board = CoreDataManager.shared.createBoard(user: user, boardName: request.name, type: request.type, id: dataBoards.count) else {
                let response = MainList.DisplayMessage.Response(title: "Creating Failed".localized(), message: "Try Again".localized())
                presenter?.presentError(response: response)
                return
            }
            dataBoards.append(board)
            let response = MainList.CreateNewBoard.Response(board: board)
            presenter?.presentNewBoard(response: response)
        }
        if request.type == BoardType.todo {
            guard let board = CoreDataManager.shared.createBoard(user: user, boardName: request.name, type: request.type, id: toDoBoards.count) else {
                let response = MainList.DisplayMessage.Response(title: "Creating Failed".localized(), message: "Try Again".localized())
                presenter?.presentError(response: response)
                return
            }
            toDoBoards.append(board)
            let response = MainList.CreateNewBoard.Response(board: board)
            presenter?.presentNewBoard(response: response)
        }

        
    }
    
    func editBoardName(request: MainList.EditBoardName.Request) {
        var board = Board()
        if request.indexPath.section == 0 {
            board = toDoBoards[request.indexPath.row]
        } else {
            board = dataBoards[request.indexPath.row]
        }
        
        board.name = request.name
        if CoreDataManager.shared.saveChanges() {
            let response = MainList.EditBoardName.Response(name: board.name ?? "Error", indexPath: request.indexPath)
            presenter?.presentChangedBoard(response: response)
        }
        else {
            let response = MainList.DisplayMessage.Response(title: "Changing Failed".localized(), message: "Try Again".localized())
            presenter?.presentError(response: response)
        }
    }
    
    func deleteBoard(request: MainList.DeleteBoard.Request) {
        var board = Board()
        if request.indexPath.section == 0 { board = toDoBoards[request.indexPath.row] }
        else { board = dataBoards[request.indexPath.row] }
            
        if CoreDataManager.shared.deleteBoard(board: board) {
            if request.indexPath.section == 0 { toDoBoards.remove(at: request.indexPath.row) }
            else { dataBoards.remove(at: request.indexPath.row) }
            renumberBoards()
            let response = MainList.DeleteBoard.Response(indexPath: request.indexPath)
            presenter?.deleteBoard(response: response)
        }
        else {
            let response = MainList.DisplayMessage.Response(title: "Error".localized(), message: "Deleting Failed".localized())
            presenter?.presentError(response: response)
        }
    }
    func moveObjects(request: MainList.MoveObjects.Request) {
        if request.sourceIndexPath.section == 0 {
            let object = toDoBoards[request.sourceIndexPath.row]
            toDoBoards.remove(at: request.sourceIndexPath.row)
            toDoBoards.insert(object, at: request.destinationIndexPath.row)
        } else {
            let object = dataBoards[request.sourceIndexPath.row]
            dataBoards.remove(at: request.sourceIndexPath.row)
            dataBoards.insert(object, at: request.destinationIndexPath.row)
        }
        renumberBoards()
    }
    
    //Used when delete or move board
    func renumberBoards() {
        for (index, board) in toDoBoards.enumerated() {
            board.id = Int64(index)
        }
        for (index, board) in dataBoards.enumerated() {
            board.id = Int64(index)
        }
    }
    
    
    // MARK:  - User Field Changing
    
    func changeUserName(request: MainList.ChangeUserName.Request) {
        user.name = request.userName
        if CoreDataManager.shared.saveChanges() {
            let response = MainList.ShowUser.Response(user: user)
            presenter?.presentUser(response: response)
        }
        else {
            let response = MainList.DisplayMessage.Response(title: "Changing Failed", message: "Try Again")
            presenter?.presentError(response: response)
        }
    }
    
    func changePassword(request: MainList.ChangePassword.Request){
        let oldPasswordHash = CoreDataManager.shared.encryptString(string: request.oldPassword)
        
        // Check old password
        guard oldPasswordHash == user.passwordHash else {
            let response = MainList.DisplayMessage.Response(title: "Password is incorrect", message: "Try Again")
            presenter?.presentError(response: response)
            return
        }
        
        // Check new passwords
        guard request.newPassword == request.confirmPassword else {
            let response = MainList.DisplayMessage.Response(title: "New passwords don't match", message: "Try Again")
            presenter?.presentError(response: response)
            return
        }
        
        // Changing password
        let newPasswordHash = CoreDataManager.shared.encryptString(string: request.newPassword)
        user.passwordHash = newPasswordHash
        if CoreDataManager.shared.saveChanges() {
            let response = MainList.DisplayMessage.Response(title: "Success", message: "Password was changed")
            presenter?.presentError(response: response)
        }
        else {
            let response = MainList.DisplayMessage.Response(title: "Changing failed", message: "Try Again")
            presenter?.presentError(response: response)
        }
        
    }
    
    func changeUserImage(request: MainList.ChangeUserImage.Request) {
        user.imageData = request.imageData
        if CoreDataManager.shared.saveChanges() {
            let response = MainList.ShowUser.Response(user: user)
            presenter?.presentUser(response: response)
        }
        else {
            let response = MainList.DisplayMessage.Response(title: "Changing Failed", message: "Try Again")
            presenter?.presentError(response: response)
        }
    }
    
}
