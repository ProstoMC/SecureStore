//
//  BoardDeskRouter.swift
//  SecureStore
//
//  Created by macSlm on 24.04.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol BoardDeskRoutingLogic {
    func navigateToFullScreenImage(indexPath: IndexPath)
}

protocol BoardDeskDataPassing {
    var dataStore: BoardDeskDataStore? { get }
}

class BoardDeskRouter: NSObject, BoardDeskRoutingLogic, BoardDeskDataPassing {
    weak var viewController: BoardDeskViewController?
    var dataStore: BoardDeskDataStore?
    
    // MARK: Navigation
    
    func navigateToFullScreenImage(indexPath: IndexPath) {
        
        let fullScreanImageVC = FullScreenImageViewController()
        fullScreanImageVC.image = UIImage(data: dataStore!.units[indexPath.row].data!)
        
        fullScreanImageVC.modalPresentationStyle = .fullScreen
        viewController?.present(fullScreanImageVC, animated: true, completion: nil)
        
    }
    
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: BoardDeskDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
