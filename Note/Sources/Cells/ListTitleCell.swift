//
//  ListTilteCell.swift
//  Note
//
//  Created by 박소진 on 2022/01/25.
//

import UIKit

class ListTitleCell: UITableViewCell {

    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var checkBoxButton_Outlet: UIButton!
    
    var checked: Int?
//    var notChecked: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listTitleLabel.font = UIFont.systemFont(ofSize: 18)
        checkBoxButton_Outlet.isSelected = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func checkBoxButton(_ sender: UIButton) {
        if !checkBoxButton_Outlet.isSelected {
            listTitleLabel.textColor = .systemGray2
            checkBoxButton_Outlet.tintColor = .systemGray2
            checkBoxButton_Outlet.isSelected = true
        }else{
            checkBoxButton_Outlet.isSelected = false
            listTitleLabel.textColor = .black
            checkBoxButton_Outlet.tintColor = .black
        }
    }
}
