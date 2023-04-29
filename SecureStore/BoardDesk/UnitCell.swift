//
//  UnitCell.swift
//  SecureStore
//
//  Created by macSlm on 25.04.2023.
//

import UIKit

class UnitCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView?
    //var textView = UITextView()

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    func configure(type: String, data: Data) {
        
        //Appearance
        
        backgroundColor = .gray
        selectionStyle = .none

        
        // Behavior
        
        switch type {
        case "image": configureImage(data: data)
        case "text": configureText(data: data)
        default: return
        }
    }
    
    private func configureImage(data: Data) {
        imgView = UIImageView()
        contentMode = .center
        addSubview(imgView!)
        imgView!.image = UIImage(data: data)
        
        
        //Constraints
        imgView!.frame = CGRect(
            x: self.bounds.width/2-self.bounds.height*0.4,
            y: self.bounds.height/2-self.bounds.height*0.4,
            width: self.bounds.height*0.8,
            height: self.bounds.height*0.8)
        
    }
    
    private func configureText(data: Data) {
        
    }

}
