//
//  UnitCell.swift
//  SecureStore
//
//  Created by macSlm on 25.04.2023.
//

import UIKit

class ImageCell: UITableViewCell {
    
    var imgView = UIImageView()
    
    var centerXConstraintEdditing = NSLayoutConstraint()
    var centerXConstraintNormal = NSLayoutConstraint()
    
    
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
    
    
    override func didTransition(to state: UITableViewCell.StateMask) {
        if self.isEditing {
            
            centerXConstraintNormal.isActive = false
            centerXConstraintEdditing.isActive = true

        } else {
            centerXConstraintEdditing.isActive = false
            centerXConstraintNormal.isActive = true
        }
    }

    

    func commonInit() {
        let screensize = UIScreen.main.bounds
        //Constraints for behavior edditing mode
        centerXConstraintEdditing = imgView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -UIScreen.main.bounds.width*0.15)
        centerXConstraintNormal = imgView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        
        contentView.addSubview(imgView)
        
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = ColorList.mainBlue
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            imgView.heightAnchor.constraint(equalToConstant: screensize.width*0.8),
            imgView.widthAnchor.constraint(equalToConstant: screensize.width*0.8),
            imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            centerXConstraintNormal,

            imgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIScreen.main.bounds.height*0.02), //space between cells
            imgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIScreen.main.bounds.height*0.02), //space between cells
            
            contentView.leftAnchor.constraint(equalTo: self.leftAnchor),
            contentView.rightAnchor.constraint(equalTo: self.rightAnchor),
        ])
    }

    

    
    func configure(data: Data) {
        imgView.image = UIImage(data: data)
    }
}

