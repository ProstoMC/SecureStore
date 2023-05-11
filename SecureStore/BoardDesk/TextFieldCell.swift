//
//  TextFieldCell.swift
//  SecureStore
//
//  Created by macSlm on 05.05.2023.
//

import UIKit

class TextFieldCell: UITableViewCell {

    var textView = UITextView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    override func layoutSubviews() {
        
        backgroundColor = ColorsList.mainBlue
        
        textView.backgroundColor = ColorsList.additionalBlue
        textView.textColor = ColorsList.textColor
        textView.font = UIFont.boldSystemFont(ofSize: 18)
       
        textView.layer.cornerRadius = textView.bounds.width / 100
        textView.clipsToBounds = true
        textView.layer.masksToBounds = true
    }

    

    func commonInit() {
        
        
        contentView.addSubview(textView)
        
        let screensize = UIScreen.main.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        
 
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            textView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textView.widthAnchor.constraint(equalToConstant: screensize.width*0.9),
            textView.heightAnchor.constraint(equalToConstant: screensize.width*0.9),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screensize.width*0.1),
            textView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }

    

    
    func configure(data: Data) {
        textView.text = String(decoding: data, as: UTF8.self)
    }
}
