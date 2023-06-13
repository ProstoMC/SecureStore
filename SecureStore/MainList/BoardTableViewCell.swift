//
//  BoardTableViewCell.swift
//  SecureStore
//
//  Created by macSlm on 26.05.2023.
//

import UIKit

class BoardTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureEmptyCell() {
        backgroundColor = ColorList.mainBlue
        selectionStyle = .none
        var content = self.defaultContentConfiguration()
        content.imageProperties.tintColor = ColorList.textColor
        content.image = UIImage(systemName: "plus")
        self.contentConfiguration = content
    }
    
    func configure(board: MainList.GetBoard.Response){
        
        backgroundColor = ColorList.mainBlue
        selectionStyle = .none
        
        if board.type == BoardType.todo {
            configureToDo(board: board)
        }
        else {
            configureData(board: board)
        }

    }
    // MARK:  - Configure TO DO
    
    func configureToDo(board: MainList.GetBoard.Response) {
        var content = self.defaultContentConfiguration()
        
        content.imageProperties.tintColor = ColorList.textColor
        content.textProperties.color = ColorList.textColor
        
        content.text = board.name
        content.image = UIImage(systemName: "checkmark.circle")
        if board.status {
            content.image = UIImage(systemName: "checkmark.circle.fill")
        }
        self.contentConfiguration = content
    }
    
    // MARK:  - Configure DATA
    
    func configureData(board: MainList.GetBoard.Response) {
        var content = self.defaultContentConfiguration()
        
        content.imageProperties.tintColor = ColorList.textColor
        content.textProperties.color = ColorList.textColor
        
        content.text = board.name
        content.image = UIImage(systemName: "tray")
        self.contentConfiguration = content
    }

}
