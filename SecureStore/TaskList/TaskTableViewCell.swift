//
//  TaskTableViewCell.swift
//  SecureStore
//
//  Created by macSlm on 03.06.2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(taskName: String, complitedStatus: Bool){
        selectionStyle = .none
        backgroundColor = ColorList.mainBlue
        
        var content = self.defaultContentConfiguration()
        
        content.imageProperties.tintColor = ColorList.textColor
        content.textProperties.color = ColorList.textColor
        
        content.image = UIImage(systemName: "plus")
        content.text = taskName
        self.contentConfiguration = content
    }

}
