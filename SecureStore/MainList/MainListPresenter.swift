//
//  MainListPresenter.swift
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

protocol MainListPresentationLogic
{
  func presentBoards(response: MainList.ShowBoards.Response)
}

class MainListPresenter: MainListPresentationLogic
{
  weak var viewController: MainListDisplayLogic?
  
  // MARK: Do something
  
  func presentBoards(response: MainList.ShowBoards.Response)
  {
    let viewModel = MainList.ShowBoards.ViewModel(username: response.username)
    viewController?.displayBoards(viewModel: viewModel)
  }
}
