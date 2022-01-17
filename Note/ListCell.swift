//
//  ListCell.swift
//  Note
//
//  Created by 박소진 on 2022/01/17.
//

import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        listTitleLabel.font = UIFont.systemFont(ofSize: 18)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
