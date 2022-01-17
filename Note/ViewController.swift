//
//  ViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var noteListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Note"
        self.makeRightButtons()
        
        let listCellnib = UINib(nibName: "ListCell", bundle: nil)
        noteListTableView.register(listCellnib, forCellReuseIdentifier: "ListCell")
        
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
    

} // ViewController Class

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}

