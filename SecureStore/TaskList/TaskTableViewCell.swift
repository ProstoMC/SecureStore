//
//  TaskTableViewCell.swift
//  SecureStore
//
//  Created by macSlm on 03.06.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    var changeStaus : (() -> ()) = {}  //Closure for changing status. Using on TaskListVC

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc private func imagePressed(_ sender: UITapGestureRecognizer) {
        print ("IMAGE PRESSED")
        changeStaus()
    }
    
    func configure(taskName: String, complitedStatus: Bool) {
        
        selectionStyle = .none
        backgroundColor = ColorList.mainBlue
        
        imageView?.tintColor = ColorList.textColor
        textLabel?.textColor = ColorList.textColor
        
        
        var statusImage = UIImage(systemName: "circle")
        
        if complitedStatus {
            statusImage = UIImage(systemName: "checkmark.circle.fill")
        }
        
        imageView?.image = statusImage
        textLabel?.text = taskName
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(imagePressed))
        imageView!.isUserInteractionEnabled = true
        imageView!.addGestureRecognizer(tap)
            
    }
    
    func configureEmptyCell() {
        
        selectionStyle = .none
        backgroundColor = ColorList.mainBlue
        imageView?.tintColor = ColorList.textColor
        imageView?.image = UIImage(systemName: "plus")
        textLabel?.text = ""
    }

}
