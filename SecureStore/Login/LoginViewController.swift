//
//  LoginViewController.swift
//  SecureStore
//
//  Created by macSlm on 16.02.2023.
//  Copyright (c) 2023 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol LoginDisplayLogic: AnyObject {
    

    func showAlert(viewModel: Login.ShowAlert.ViewModel)
    func clearTextFields()
    func setupUI(viewModel: Login.Texts.ViewModel)
    func moveToMainList()
}

class LoginViewController: UIViewController {
    
    
    var interactor: LoginBusinessLogic?
    var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
    
    var defaultUserName = ""
    var screenSize: CGRect!
    
    var signUpMode = false
    
    
    var languageButton = UIButton()
    var routeButton = UIButton()
    var stackView = UIStackView()
    
    var userNameTextField = UITextField()
    var passwordTextField = UITextField()
    var bigButton = UIButton()
    var smallButton = UIButton()
    
    var confirmPasswordTextField = UITextField()

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
        let interactor = LoginInteractor()
        let presenter = LoginPresenter()
        let router = LoginRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        interactor?.getDefaultUserName()
    }
}

// MARK:  DISPLAY LOGIC


extension LoginViewController: LoginDisplayLogic {
    
    func moveToMainList() {
        router?.navigateToMainList()
    }
    
    func showAlert(viewModel: Login.ShowAlert.ViewModel) {

        let alert = UIAlertController(
            title: viewModel.title,
            message: viewModel.message,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: viewModel.buttonTitle, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func clearTextFields(){
        passwordTextField.text = nil
        confirmPasswordTextField.text = nil
    }
    
    func setupUI(viewModel: Login.Texts.ViewModel) {
        //loginTextList = viewModel.textList
        screenSize = UIScreen.main.bounds
        defaultUserName = viewModel.defaultUserName
        
        makeBackgoundColor()
        
        view.addSubview(stackView)
        setupStackView()
        setupLanguageButton()
        setupRouteButton()
    }
    
}



// MARK:  Actions

extension LoginViewController {
    
    @objc func routeButtonPressed() {
        
        router?.navigateToMainList()
    }
    
    
    @objc func smallButtonPressed() {
        signUpMode.toggle()
        setupStackView()
    }
    
    @objc func bigButtonPressed() {
        if signUpMode {
            signUp()
        } else {
            login()
        }
    }
    // DONT USED
//    @objc func toggleLanguage() {
//        interactor?.toggleLanguage()
//    }
    
    func login() {
        let request = Login.Login.Request(
            userName: userNameTextField.text,
            password: passwordTextField.text)

        interactor?.login(request: request)
    }
    

    func signUp() {
        let request = Login.SignUp.Request(
            userName: userNameTextField.text,
            password: passwordTextField.text,
            confirmPassword: confirmPasswordTextField.text)
        interactor?.signUp(request: request)
    }
    
}




// MARK:  SetupUI

extension LoginViewController: UITextFieldDelegate {
    
    private func makeBackgoundColor(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [ColorList.powder.cgColor, ColorList.additionalBlue.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupRouteButton(){
        routeButton.isHidden = true

        routeButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(routeButton)
        
        // Apperance
        
        routeButton.setTitleColor(ColorList.additionalBlue, for: .normal)
        routeButton.setTitle("GO", for: .normal)
        
        routeButton.addTarget(self, action: #selector(routeButtonPressed), for: .touchUpInside)
        
        //Constraints
        let topAnchor = routeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height*0.06)
        
        let leftAnchor = routeButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: screenSize.width*0.06)

        NSLayoutConstraint.activate([topAnchor, leftAnchor])
    }
    
    private func setupLanguageButton(){
        languageButton.isHidden = true  //LANGUAGE CHANGING DONT USED
        languageButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(languageButton)
        
        // Apperance
        
        languageButton.setTitleColor(ColorList.additionalBlue, for: .normal)
        languageButton.setTitle(GlobalSettings.shared.language, for: .normal)
        
//        languageButton.addTarget(self, action: #selector(toggleLanguage), for: .touchUpInside)
        
        //Constraints
        let topAnchor = languageButton.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height*0.06)
        
        let rightAnchor = languageButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -screenSize.width*0.06)
        
        //var topAnchor = bigButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40)

        NSLayoutConstraint.activate([topAnchor, rightAnchor])
        
        
        
    }
    
    private func setupStackView(){
                        
        stackView.translatesAutoresizingMaskIntoConstraints = false

        // Appearance
        stackView.axis = .vertical
        stackView.spacing = 30
        
        //Constraints
        let leftAnchor = stackView.leftAnchor.constraint(equalTo: view.leftAnchor)
        let rightAnchor = stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        let centerYAnchor = stackView.centerYAnchor.constraint(
            equalTo: view.centerYAnchor, constant: -screenSize.height*0.1)
        
        NSLayoutConstraint.activate([leftAnchor, rightAnchor, centerYAnchor])
        
        
        //Fill stackView

            setupUserNameTextField()
            setupPasswordTextField()
            setupConfirmPasswordTextField()
            setupBigButton()
            setupSmallButton()

    }
    

    
    private func setupUserNameTextField(){
        
        stackView.addArrangedSubview(userNameTextField)

        
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Apperance

        userNameTextField.delegate = self
        userNameTextField.clearButtonMode = .always
        userNameTextField.borderStyle = .roundedRect
        userNameTextField.keyboardType = .default
        userNameTextField.placeholder = "Username".localized()
        userNameTextField.text = defaultUserName
        
        // Delegate
        userNameTextField.delegate = self
        
        //Constraints
        let leftAnchor = userNameTextField.leftAnchor.constraint(
            equalTo: view.centerXAnchor, constant: -screenSize.width*0.3)
        let rightAnchor = userNameTextField.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: screenSize.width*0.3)
        
        NSLayoutConstraint.activate([leftAnchor, rightAnchor])
    }
    
    private func setupPasswordTextField(){
        
        stackView.addArrangedSubview(passwordTextField)

        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Apperance
        passwordTextField.delegate = self
        passwordTextField.clearButtonMode = .always
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.keyboardType = .default
        passwordTextField.placeholder = "Password".localized()
        passwordTextField.isSecureTextEntry = true
        passwordTextField.returnKeyType = UIReturnKeyType.done
        passwordTextField.text = ""
        
        if signUpMode { passwordTextField.returnKeyType = UIReturnKeyType.default }
        
        // Delegate
        passwordTextField.delegate = self
        
        //Constraints
        let leftAnchor  = passwordTextField.leftAnchor.constraint(equalTo: userNameTextField.leftAnchor)
        let rightAnchor = passwordTextField.rightAnchor.constraint(equalTo: userNameTextField.rightAnchor)
        
        NSLayoutConstraint.activate([leftAnchor, rightAnchor])
    }
    
    private func setupConfirmPasswordTextField(){
        
        stackView.addArrangedSubview(confirmPasswordTextField)
        
        confirmPasswordTextField.isHidden = true
        if signUpMode { confirmPasswordTextField.isHidden = false }
        
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        // Apperance
        confirmPasswordTextField.delegate = self
        confirmPasswordTextField.clearButtonMode = .always
        confirmPasswordTextField.borderStyle = .roundedRect
        confirmPasswordTextField.keyboardType = .default
        confirmPasswordTextField.placeholder = "Confirm Password".localized()
        confirmPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.returnKeyType = UIReturnKeyType.done
        confirmPasswordTextField.text = ""
        
        // Delegate
        confirmPasswordTextField.delegate = self
        
        //Constraints
        let leftAnchor  = confirmPasswordTextField.leftAnchor.constraint(equalTo: userNameTextField.leftAnchor)
        let rightAnchor = confirmPasswordTextField.rightAnchor.constraint(equalTo: userNameTextField.rightAnchor)
        
        NSLayoutConstraint.activate([leftAnchor, rightAnchor])
    }
    

    
    
    private func setupBigButton(){
        
        stackView.addArrangedSubview(bigButton)

        bigButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Apperance
        var title = "Sign In".localized()
        if signUpMode { title = "Sign Up".localized() }
        
        bigButton.setTitleColor(.lightGray, for: .normal)
        bigButton.setTitle(title, for: .normal)
        bigButton.backgroundColor = ColorList.mainBlue
        bigButton.layer.cornerRadius = 5
        bigButton.addTarget(self, action: #selector(bigButtonPressed), for: .touchUpInside)
        
        //Constraints
        let leftAnchor  = bigButton.leftAnchor.constraint(equalTo: userNameTextField.leftAnchor, constant: 20)
        let rightAnchor = bigButton.rightAnchor.constraint(equalTo: userNameTextField.rightAnchor, constant: -20)

        NSLayoutConstraint.activate([leftAnchor, rightAnchor])
    }
    
    private func setupSmallButton(){
        
        stackView.addArrangedSubview(smallButton)
      
        smallButton.translatesAutoresizingMaskIntoConstraints = false
        smallButton.addTarget(self, action: #selector(smallButtonPressed), for: .touchUpInside)
        
        // Apperance
        var title = "Sign Up".localized()
        if signUpMode {title = "Sign In".localized()}
        
        smallButton.setTitleColor(ColorList.mainBlue, for: .normal)
        smallButton.setTitle(title, for: .normal)

        //Constraints
        let leftAnchor  = smallButton.leftAnchor.constraint(
            equalTo: userNameTextField.leftAnchor, constant: 30)
        let rightAnchor = smallButton.rightAnchor.constraint(
            equalTo: userNameTextField.rightAnchor, constant: -30)
        
        //let topAnchor = smallButton.topAnchor.constraint(equalTo: bigButton.bottomAnchor, constant: 70)
        
        NSLayoutConstraint.activate([leftAnchor, rightAnchor])
    }
    
    // MARK:  TextField Delegate
    //Keyboard button DONE behavior
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNameTextField{
            passwordTextField.becomeFirstResponder()
        }
        if textField == passwordTextField {
            if !signUpMode {
                view.endEditing(true)
                bigButtonPressed()
            } else {
                confirmPasswordTextField.becomeFirstResponder()
            }
        }
        if textField == confirmPasswordTextField {
            view.endEditing(true)
            bigButtonPressed()
        }
        return true
    }
    
    // MARK:  Keyboard Dissmiss
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let _ = touches.first {
            view.endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
}






