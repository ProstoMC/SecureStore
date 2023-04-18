//
//  MainListViewController.swift
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

protocol MainListDisplayLogic: class {
    func displayUser(viewModel: MainList.ShowUser.ViewModel)
    func displayBoards(viewModel: MainList.ShowBoards.ViewModel)
    func displayNewBoard(viewModel: MainList.CreateNewBoard.ViewModel)
    func displayEditedBoard(viewModel: MainList.EditBoardName.ViewModel)
    func deleteBoard(viewModel: MainList.DeleteBoard.ViewModel)
    
    
    func displayError(viewModel: MainList.DisplayError.ViewModel)
}

class MainListViewController: UITableViewController, MainListDisplayLogic {
    

    
    var interactor: MainListBusinessLogic?
    var router: (NSObjectProtocol & MainListRoutingLogic & MainListDataPassing)?
    
    var menuMode = false
    var menuPanel = UIView()
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
       
    private var boardsList: [String] = []
    private var userImageData: Data?
    

    // MARK: - Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

  
  // MARK: - Setup
  
    private func setup() {
        let viewController = self
        let interactor = MainListInteractor()
        let presenter = MainListPresenter()
        let router = MainListRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
  
  // MARK: - Routing
  
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
  
  // MARK: - View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        let requestUN = MainList.ShowUser.Request()
        interactor?.showUser(request: requestUN)
        let requestSB = MainList.ShowBoards.Request()
        interactor?.showBoards(request: requestSB)
    }
  
  // MARK: - DISPLAY LOGIC

    func displayUser(viewModel: MainList.ShowUser.ViewModel) {
        title = viewModel.username
        userNameLabel.text = viewModel.username
        guard let imageData = viewModel.imageData else { return }
        userImageData = imageData
    }
    
    func displayBoards(viewModel: MainList.ShowBoards.ViewModel) {
        boardsList = viewModel.boardsNames
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func displayNewBoard(viewModel: MainList.CreateNewBoard.ViewModel) {
        boardsList.append(viewModel.name)
        self.tableView.insertRows(at: [IndexPath(row: self.boardsList.count - 1, section: 0)], with: .automatic)
    }
    

    
    func displayEditedBoard(viewModel: MainList.EditBoardName.ViewModel) {
        boardsList[viewModel.indexPath.row] = viewModel.name
        tableView.reloadRows(at: [viewModel.indexPath], with: .automatic)
    }
    
    func deleteBoard(viewModel: MainList.DeleteBoard.ViewModel) {
        boardsList.remove(at: viewModel.indexPath.row)
        tableView.deleteRows(at: [viewModel.indexPath], with: .automatic)
    }
    
    func displayError(viewModel: MainList.DisplayError.ViewModel) {

        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    // MARK:  - Changing User Fields
    

    
    

}

// MARK: -  ACTIONS
extension MainListViewController {
    @objc private func addNewTask() {
        showAlert(title: "New task", message: "Enter new task", indexPath: nil)
    }
    
    @objc private func menuPanelToggle() {
        
        if !menuMode {  //Making Panel during first tuch
            setupMenuPanel()
            self.view.addSubview(menuPanel)
            menuMode = true
        } else {
            menuPanel.isHidden.toggle()
        }
        
    }
    
    @objc private func logout() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func userNameLapelTapped(){
        editUserNameAlert()
    }
    
    @objc private func editButtonTapped(){
        editUserPasswordAlert()
    }
    
}



// MARK: - Alerts

extension MainListViewController {
    
    // Lines edditing Alert
    
    private func showAlert(title: String, message: String, indexPath: IndexPath?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let boardName = alert.textFields?.first?.text, !boardName.isEmpty else {
                print("Epmty field")
                return
            }
                
            //Save or edit with CoreData
            if indexPath == nil {
                let request = MainList.CreateNewBoard.Request(name: boardName)
                self.interactor?.createNewBoard(request: request)
            } else {
                print("Edditing ", boardName)
                let request = MainList.EditBoardName.Request(name: boardName, indexPath: indexPath!)
                self.interactor?.editBoardName(request: request)
            }
                
        }
            
        
        let canselAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        if indexPath != nil { alert.textFields?.first?.text = message }
        alert.addAction(saveAction)
        alert.addAction(canselAction)
        
        present(alert, animated: true)
    }
    
    // Users fields edditing Alerts
    
    func editUserNameAlert() {
        let alert = UIAlertController(title: "Change username", message: nil, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else {
                print("Epmty field")
                return
            }
            let request = MainList.ChangeUserName.Request(userName: text)
            self.interactor?.changeUserName(request: request)

        }


        let canselAction = UIAlertAction(title: "Cancel", style: .destructive)

        alert.addTextField() { textField in
            textField.text = self.title
        }
        
        alert.addAction(saveAction)
        alert.addAction(canselAction)

        present(alert, animated: true)
    }
    
    func editUserPasswordAlert() {
        let alert = UIAlertController(title: "Change password", message: nil, preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let oldPassword = alert.textFields?.first?.text, !oldPassword.isEmpty else {
                print("Epmty field")
                return
            }
            guard let newPassword = alert.textFields?[1].text, !newPassword.isEmpty else {
                print("Epmty field")
                return
            }
            guard let confirmPassword = alert.textFields?[2].text, !confirmPassword.isEmpty else {
                print("Epmty field")
                return
            }
            
            let request = MainList.ChangePassword.Request(
                oldPassword: oldPassword,
                newPassword: newPassword,
                confirmPassword: confirmPassword)
            self.interactor?.changePassword(request: request)
        }

        let canselAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField() { textField in
            textField.placeholder = "Enter current password"
        }
        alert.addTextField() { textField in
            textField.placeholder = "Enter new password"
        }
        alert.addTextField() { textField in
            textField.placeholder = "Confirm new password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(canselAction)

        present(alert, animated: true)
    }
}

// MARK: - TableView Configuration
extension MainListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .gray
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        cell.textLabel?.textColor = ColorsList.darkBlueColor
        
        let board = boardsList[indexPath.row]
        cell.textLabel?.text = board
        return cell
    }
    
    // MARK:  - Add buttons
    
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        //CURRENT CODE

        let deleteButton = UIContextualAction(style: .normal, title:  "", handler: {
            [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void)
           in
            let request = MainList.DeleteBoard.Request(indexPath: indexPath)
            self.interactor?.deleteBoard(request: request)

        })
        deleteButton.image = UIImage(systemName: "trash")

        let editButton = UIContextualAction(style: .normal, title: "", handler: {
            [self] (ac:UIContextualAction, view:UIView, success:(Bool) -> Void)
            in
            self.showAlert(title: "Edit the task", message: self.boardsList[indexPath.row], indexPath: indexPath)
        })
        editButton.image = UIImage(systemName: "square.and.pencil")

        editButton.backgroundColor = ColorsList.darkBlueColor
        deleteButton.backgroundColor = ColorsList.purpleColor

        return UISwipeActionsConfiguration(actions: [deleteButton, editButton])
    }
    
}


// MARK: -  SETUP UI
extension MainListViewController {
    
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .gray
        setupNavigationBar()
        setupMenuPanel()
    }
    
    private func setupNavigationBar() {
        title = "Tasks list"
        
        navigationController?.navigationBar.prefersLargeTitles = true

        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = ColorsList.darkBlueColor
        
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        appearance.largeTitleTextAttributes = [.foregroundColor: ColorsList.purpleColor]
        appearance.titleTextAttributes = [.foregroundColor: ColorsList.purpleColor]
        UINavigationBar.appearance().backgroundColor = ColorsList.darkBlueColor
                
        // Add button +
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewTask))
        navigationItem.rightBarButtonItem?.tintColor = ColorsList.purpleColor
        
        
        // Add button Menu
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.fill"), style: .plain, target: self, action: #selector(menuPanelToggle))
        navigationItem.leftBarButtonItem?.tintColor = ColorsList.purpleColor
        
    }
    
    private func setupMenuPanel() {
       
        menuPanel.translatesAutoresizingMaskIntoConstraints = false
        
        //Appearance
        menuPanel.layer.backgroundColor = ColorsList.darkBlueColor.cgColor
        
        //Frames
        menuPanel.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width/2, height: tableView.frame.size.height)
        
        //Add Elements
        setupUserImage()
        setupUserNameLabel()
        setupButtons()
    }
    
    private func setupUserImage() {
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        
        //Appearance
       
        if userImageData != nil {
            userImageView.image = UIImage(data: userImageData!)
        } else {
            userImageView.image = UIImage(systemName: "person.circle.fill")
            userImageView.tintColor = ColorsList.darkBlueColor
            userImageView.backgroundColor = .gray
        }
        
        //Constraints
        
        userImageView.frame = CGRect(
            x: menuPanel.frame.width/2-menuPanel.frame.width/6,
            y: menuPanel.frame.width/6,
            width: menuPanel.frame.width/3,
            height: menuPanel.frame.width/3)
        userImageView.layer.cornerRadius = userImageView.frame.size.height/2
        
        menuPanel.addSubview(userImageView)
    }
    
    private func setupUserNameLabel() {
        
       
        //Appearance
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = title
        userNameLabel.textAlignment = .center
        userNameLabel.adjustsFontSizeToFitWidth = true
        
        userNameLabel.textColor = ColorsList.purpleColor
        
        //Constraints
        
        userNameLabel.frame = CGRect(
            x: menuPanel.frame.width*0.05,
            y: menuPanel.frame.width/1.8,
            width: menuPanel.frame.width/1.1,
            height: menuPanel.frame.height/20
        )
        
        //Behavior
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(userNameLapelTapped))
        userNameLabel.isUserInteractionEnabled = true
        userNameLabel.addGestureRecognizer(tap)
        menuPanel.addSubview(userNameLabel)
        
    }
    
    private func setupButtons() {
        let line = UIView()
        let editButton = UIButton()
        let logoutButton = UIButton()
        
        //Appearance
        line.backgroundColor = ColorsList.purpleColor
        editButton.setTitleColor(ColorsList.purpleColor, for: .normal)
        editButton.setTitle("Change password", for: .normal)
        
        logoutButton.setTitleColor(ColorsList.purpleColor, for: .normal)
        logoutButton.setTitle("Log out", for: .normal)
        
        //Behavior
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        //Constraints
        line.frame = CGRect(
            x: menuPanel.frame.width*0.05,
            y: menuPanel.frame.midY/2.4,
            width: menuPanel.frame.width/1.1,
            height: 2
        )
        
        editButton.frame = CGRect(
            x: menuPanel.frame.width*0.05,
            y: line.frame.minY + menuPanel.frame.height/50,
            width: menuPanel.frame.width/1.1,
            height: menuPanel.frame.height/20
        )
        logoutButton.frame = CGRect(
            x: menuPanel.frame.width*0.05,
            y: editButton.frame.minY + menuPanel.frame.height/20,
            width: menuPanel.frame.width/1.1,
            height: menuPanel.frame.height/20
        )
        
        
        menuPanel.addSubview(line)
        menuPanel.addSubview(editButton)
        menuPanel.addSubview(logoutButton)
        
    }
    
    // MARK:  - Alert

    
}




