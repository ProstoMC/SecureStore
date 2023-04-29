//
//  BoardDeskViewController.swift
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

protocol BoardDeskDisplayLogic: class {
    func displayMessageAlert(viewModel: BoardDesk.Message.ViewModel)
    
    func displayBoard(viewModel: BoardDesk.ShowBoard.ViewModel)
    func displayNewUnit(viewModel: BoardDesk.SaveImageAsUnit.ViewModel)
    func deleteUnit(viewModel: BoardDesk.DeleteUnit.ViewModel)
    
}

class BoardDeskViewController: UITableViewController {
    var interactor: BoardDeskBusinessLogic?
    var router: (NSObjectProtocol & BoardDeskRoutingLogic & BoardDeskDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = BoardDeskInteractor()
        let presenter = BoardDeskPresenter()
        let router = BoardDeskRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorsList.darkBlueColor
        setupUI()
    }
    
    // MARK: Do something
    
    //@IBOutlet weak var nameTextField: UITextField!
    

    
}

// MARK:  - ACTIONS

extension BoardDeskViewController {
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
  
    }
    @objc func addNewUnit() {
        choosingUnitAlert()
    }
}

// MARK:  - DISPLAY LOGIC

extension BoardDeskViewController: BoardDeskDisplayLogic {
    
    func displayBoard(viewModel: BoardDesk.ShowBoard.ViewModel) {
        title = viewModel.boardName
    }
    
    func displayNewUnit(viewModel: BoardDesk.SaveImageAsUnit.ViewModel) {
        
        tableView.insertRows(at: [IndexPath(row: interactor!.getCountOfUnits()-1, section: 0)], with: .automatic)
    }
    
    func deleteUnit(viewModel: BoardDesk.DeleteUnit.ViewModel) {

        tableView.deleteRows(at: [viewModel.indexPath], with: .automatic)
    }
    
    func displayMessageAlert(viewModel: BoardDesk.Message.ViewModel) {

        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}

// MARK:  - Image picker

extension BoardDeskViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func fetchImageFromPicker(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let request = BoardDesk.SaveImageAsUnit.Request(imageData:editedImage.pngData()!)
            interactor?.saveImageAsUnit(request: request)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let request = BoardDesk.SaveImageAsUnit.Request(imageData:originalImage.pngData()!)
            interactor?.saveImageAsUnit(request: request)
        }
        dismiss(animated: true, completion: nil)
    }
}

// MARK:  - ALERTS

extension BoardDeskViewController {
    
    private func choosingUnitAlert() {
        let alert = UIAlertController(title: "Choose type of unit", message: nil, preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Photo from camera", style: .default) { _ in
            self.fetchImageFromPicker(source: .camera)
            return
        }
        let libraryAction = UIAlertAction(title: "Image from gallery", style: .default) { _ in
            self.fetchImageFromPicker(source: .photoLibrary)
            return
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    

    
}

// MARK:  - SetupUI

extension BoardDeskViewController {
    func setupUI() {
        view.backgroundColor = .gray
        tableView.register(UnitCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        
        let request = BoardDesk.ShowBoard.Request()
        interactor?.showBoard(request: request)
        
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ColorsList.darkBlueColor
        
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        appearance.largeTitleTextAttributes = [.foregroundColor: ColorsList.purpleColor]
        appearance.titleTextAttributes = [.foregroundColor: ColorsList.purpleColor]
        UINavigationBar.appearance().backgroundColor = ColorsList.darkBlueColor
        
        
        // Add back button
                
        // Add button +
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewUnit))
        navigationItem.rightBarButtonItem?.tintColor = ColorsList.purpleColor


        // Add button Menu

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = ColorsList.purpleColor
        
    }
}

// MARK:  - TableView configure

extension BoardDeskViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor!.getCountOfUnits()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return view.bounds.width
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UnitCell
        let unit = interactor?.getUnit(index: indexPath.row)
        cell.configure(type: unit!.type, data: unit!.data)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteButton = UIContextualAction(style: .normal, title:  "", handler: {
            [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void)
           in
            let request = BoardDesk.DeleteUnit.Request(indexPath: indexPath)
            self.interactor?.deleteUnit(request: request)

        })
        deleteButton.image = UIImage(systemName: "trash")
        
        deleteButton.backgroundColor = .gray

        return UISwipeActionsConfiguration(actions: [deleteButton])
    }
}
