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

protocol BoardDeskDisplayLogic: AnyObject {
    func displayMessageAlert(viewModel: BoardDesk.Message.ViewModel)
    func displayBoard(viewModel: BoardDesk.ShowBoard.ViewModel)
    func displayNewUnit()
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
        view.backgroundColor = ColorList.mainBlue
        setupUI()
    }
    
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
    
    func displayNewUnit() {
        
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



// MARK:  - ALERTS

extension BoardDeskViewController {
    
    private func choosingUnitAlert() {
        let alert = UIAlertController(title: "Choose type of unit".localized(), message: nil, preferredStyle: .actionSheet)
        
        let textFieldAction = UIAlertAction(title: "Text".localized(), style: .default) { _ in
            let text = " "
            let request = BoardDesk.CreateUnit.Request(data: text.data(using: .utf8)!)
            self.interactor?.createTextUnit(request: request)
            return
        }
        
        let cameraAction = UIAlertAction(title: "Photo from camera".localized(), style: .default) { _ in
            self.fetchImageFromPicker(source: .camera)
            return
        }
        
        let libraryAction = UIAlertAction(title: "Image from gallery".localized(), style: .default) { _ in
            self.fetchImageFromPicker(source: .photoLibrary)
            return
        }
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .destructive)
        alert.addAction(textFieldAction)
        alert.addAction(cameraAction)
        alert.addAction(libraryAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
}

// MARK:  - SetupUI

extension BoardDeskViewController {
    func setupUI() {
        view.backgroundColor = ColorList.mainBlue
        tableView.register(ImageCell.self, forCellReuseIdentifier: UnitType.image)
        tableView.register(TextViewCell.self, forCellReuseIdentifier: UnitType.text)
        tableView.register(TaskTableViewCell.self, forCellReuseIdentifier: "task")
        tableView.tableFooterView = UIView() // Dont show unused rows
        tableView.separatorStyle = .none // Dont show borders between rows
        tableView.estimatedRowHeight = UITableView.automaticDimension // Flexible height of row
        tableView.rowHeight = UITableView.automaticDimension // Flexible height of row
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.keyboardDismissMode = .onDrag // Close the keyboard by scrolling
        //tableView.contentInset.top = UIScreen.main.bounds.width*0.1 //Space above tableview
        
        let request = BoardDesk.ShowBoard.Request()
        interactor?.showBoard(request: request)
        
        setupNavigationBar()
        
    }
    
    private func setupNavigationBar() {
        
        navigationController?.navigationBar.prefersLargeTitles = false

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ColorList.mainBlue
        
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        appearance.largeTitleTextAttributes = [.foregroundColor: ColorList.textColor]
        appearance.titleTextAttributes = [.foregroundColor: ColorList.textColor]
        UINavigationBar.appearance().backgroundColor = ColorList.mainBlue
        
        // Add bottom line
        
        let lineView = UIView()
        navigationController?.navigationBar.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = ColorList.textColor
        var constraints: [NSLayoutConstraint] = []
        constraints.append(lineView.bottomAnchor.constraint(equalTo: navigationController!.navigationBar.bottomAnchor))
        constraints.append(lineView.leftAnchor.constraint(equalTo: navigationController!.navigationBar.leftAnchor))
        constraints.append(lineView.rightAnchor.constraint(equalTo: navigationController!.navigationBar.rightAnchor))
        constraints.append(lineView.heightAnchor.constraint(equalToConstant: navigationController!.navigationBar.bounds.width*0.002))
        NSLayoutConstraint.activate(constraints)
                
        // Add button +
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewUnit))
        navigationItem.rightBarButtonItem?.tintColor = ColorList.textColor


        // Add back button

        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = ColorList.textColor
        
    }
}

// MARK:  - TableView configure

extension BoardDeskViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor!.getCountOfUnits()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let unit = interactor?.getUnit(indexPath: indexPath)  // Hear unit is cortege
        
        switch unit!.type {
            // MARK:  - IMAGE CELL
        case UnitType.image:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitType.image, for: indexPath) as! ImageCell
            cell.configure(data: unit!.data!)
            return cell
            // MARK:  - TEXT CELL
        case UnitType.text:
            let cell = tableView.dequeueReusableCell(withIdentifier: UnitType.text, for: indexPath) as! TextViewCell
            cell.configure(text: unit!.text!)
            
            
            cell.saveText = { [weak self] in
                cell.textView.endEditing(true)
                let request = BoardDesk.ChangingTextUnit.Request(indexPatch: indexPath, text: cell.textView.text)
                self?.interactor?.changeTextUnit(request: request)
                self?.tableView.beginUpdates()
                self?.tableView.endUpdates()
                
            }
            
            cell.textWasChanged = { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.beginUpdates()
                    self?.tableView.endUpdates()
                }
            }
            
            return cell
            
        default:  //Dont used
            return tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let unit = interactor?.getUnit(indexPath: indexPath) else { return }
        if unit.type == UnitType.image {
            router?.navigateToFullScreenImage(indexPath: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteButton = UIContextualAction(style: .normal, title:  "", handler: {
            [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void)
           in
            let request = BoardDesk.DeleteUnit.Request(indexPath: indexPath)
            self.interactor?.deleteUnit(request: request)

        })
        
        deleteButton.image = UIImage(systemName: "trash")
        deleteButton.backgroundColor = ColorList.mainBlue

        return UISwipeActionsConfiguration(actions: [deleteButton])
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
            let request = BoardDesk.CreateUnit.Request(data:editedImage.pngData()!)
            interactor?.createImageUnit(request: request)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let request = BoardDesk.CreateUnit.Request(data:originalImage.pngData()!)
            interactor?.createImageUnit(request: request)
        }
        dismiss(animated: true, completion: nil)
    }
}


