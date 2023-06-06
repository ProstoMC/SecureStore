//
//  TaskListModels.swift
//  SecureStore
//
//  Created by macSlm on 03.06.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum TaskList
{
    // MARK: Use cases
    
    enum ShowBoard
    {
        struct Request {
        }
        struct Response {
            var board: Board
        }
        struct ViewModel {
            var boardName: String
        }
    }
    enum CreateTask
    {
        struct Request {
            var taskName: String
        }
        struct Response {
            var task: Task
        }
        struct ViewModel {
            var taskName: String
        }
    }
    
    enum EditTaskName {
        struct Request {
            var name: String
            var indexPath: IndexPath
        }
        struct Response {
            var task: Task
            var indexPath: IndexPath
        }
        struct ViewModel {
            var name: String
            var indexPath: IndexPath
        }
    }
    enum DeleteTask {
        struct Request {
            var indexPath: IndexPath
        }
        struct Response {
            var indexPath: IndexPath
        }
        struct ViewModel {
            var indexPath: IndexPath
        }
    }
    enum DisplayMessage {
        struct Request {
            
        }
        struct Response {
            var title: String
            var message: String
        }
        struct ViewModel {
            var title: String
            var message: String
            var buttonTitle: String
        }
    }
    
}
