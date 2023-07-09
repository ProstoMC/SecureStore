//
//  TextFieldCell.swift
//  SecureStore
//
//  Created by macSlm on 05.05.2023.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {
    
    //var textViewHeight: CGFloat = 18
    
    var textWasChanged : (() -> ()) = {}  //Closure for changing textView size and show button
    var saveText : (() -> ()) = {}  //Closure for saving. Using on BoardDesckVC
    
    
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        return stackView
    }()
    
    // MARK:  - Setup textView
    var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.sizeToFit()
        textView.isScrollEnabled = false
        
        textView.backgroundColor = ColorList.additionalBlue
        textView.textColor = ColorList.textColor
        
        textView.clipsToBounds = true
        textView.layer.masksToBounds = true
        
        return textView
    }()
    
    //Constraint for behavior of edditing mode
    var rightConstraintEdit = NSLayoutConstraint()
    var rightConstraintNormal = NSLayoutConstraint()
    
    // MARK:  - Setup SaveButton
    var buttonSave: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.isHidden = true //Appearing after changing text
        
        button.setTitle("Save", for: .normal)
        button.setTitleColor(ColorList.textColor, for: .normal)
        button.backgroundColor = UIColor(displayP3Red: 50, green: 50, blue: 50, alpha: 0)
        
        button.layer.borderWidth = 1
        button.layer.borderColor = ColorList.textColor.cgColor
        button.clipsToBounds = true
        
        return button
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    
    func configure(text: String) {
        textView.text = text
    }
    
    // MARK:  - ACTIONS
    
    @objc private func saveButtonPressed() {
        buttonSave.isHidden = true
        saveText()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        buttonSave.isHidden = false
        textWasChanged()
    }

    
    // MARK:  - SETUP UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //Setup corners
        buttonSave.layer.cornerRadius = buttonSave.bounds.height / 2
        textView.layer.cornerRadius = contentView.bounds.width / 100
        
    }
    
    override func didTransition(to state: UITableViewCell.StateMask) {
        
        if self.isEditing {
            rightConstraintNormal.isActive = false
            rightConstraintEdit.isActive = true
        } else {
            rightConstraintEdit.isActive = false
            rightConstraintNormal.isActive = true
        }
    }

    func commonInit() {
        //Constraints for behavior of edditing mode
        rightConstraintEdit = textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UIScreen.main.bounds.width*0.15)
        rightConstraintNormal = textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UIScreen.main.bounds.width*0.05)
        
        self.automaticallyUpdatesContentConfiguration = true
        backgroundColor = ColorList.mainBlue
        let screensize = UIScreen.main.bounds
        textView.delegate = self
        selectionStyle = .none
        
        //SETUP CONTENT VIEW
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        
        //SETUP STACK VIEW
        contentView.addSubview(stackView)
        stackView.spacing = screensize.width*0.05
        //Spacing between cells
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIScreen.main.bounds.height*0.02),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIScreen.main.bounds.height*0.02)
        ])
        
        //SETUP TEXT VIEW
        stackView.addArrangedSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: screensize.width*0.05),
            //textView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -screensize.width*0.05),
            rightConstraintNormal
        ])
        
        //SETUP SAVE BUTTON
        stackView.addArrangedSubview(buttonSave)
        buttonSave.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)

        NSLayoutConstraint.activate([
            buttonSave.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: screensize.width*0.35),
            buttonSave.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -screensize.width*0.35),
            buttonSave.heightAnchor.constraint(equalToConstant: screensize.width*0.07)
        ])
    }

    

}
