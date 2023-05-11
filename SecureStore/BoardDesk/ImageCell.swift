//
//  UnitCell.swift
//  SecureStore
//
//  Created by macSlm on 25.04.2023.
//

import UIKit

class ImageCell: UITableViewCell {
    
    var imgView = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    
    override func layoutSubviews() {
        imgView.layer.cornerRadius = imgView.bounds.height / 20
        imgView.clipsToBounds = true
        imgView.layer.masksToBounds = true
    }

    

    func commonInit() {
        
        
        contentView.addSubview(imgView)
        
        let screensize = UIScreen.main.bounds
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = ColorsList.mainBlue
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imgView.widthAnchor.constraint(equalToConstant: screensize.width*0.8),
            imgView.heightAnchor.constraint(equalToConstant: screensize.width*0.8),
            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screensize.width*0.1),
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }

    

    
    func configure(data: Data) {
        imgView.image = UIImage(data: data)
    }
}

