//
//  ViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Note"
        self.makeRightButtons()
        
        let listCellnib = UINib(nibName: "ListCell", bundle: nil)
        settingTableView.register(listCellnib, forCellReuseIdentifier: "ListCell")
        
    }
    
    func makeRightButtons() {
        let editButtonImage = UIImage(systemName: "pencil")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .done, target: self, action: #selector(editLists))
        editButton.tintColor = .black
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewList))
        addButton.tintColor = .black
        
        navigationItem.rightBarButtonItems = [addButton, editButton]
    }
    
    @objc func editLists() {
        print("click Edit Button")
    }
    
    @objc func addNewList() {
        print("click Add Button")
    }
    

}

