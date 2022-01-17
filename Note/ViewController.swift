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
        
        self.setNavigationBarTitle()
        self.makeRightButtons()
        
        let listCellnib = UINib(nibName: "ListCell", bundle: nil)
        noteListTableView.register(listCellnib, forCellReuseIdentifier: "ListCell")
        
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
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
    
    func setNavigationBarTitle() {
        let titleButton = UIButton()
        titleButton.setTitle("Note ", for: .normal)
        titleButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        titleButton.setTitleColor(UIColor.black, for: .normal)
        titleButton.addTarget(self, action: #selector(chooseDate(sender:)), for: .touchUpInside)
        
        let titleButtonImage = UIButton()
        titleButtonImage.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButtonImage.tintColor = .lightGray
        titleButtonImage.addTarget(self, action: #selector(chooseDate(sender:)), for: .touchUpInside)
        
        let titleStackView = UIStackView(arrangedSubviews: [titleButton, titleButtonImage])
        titleStackView.axis = .horizontal
        titleStackView.frame.size.width = titleButton.frame.width + titleButtonImage.frame.width
        
        navigationItem.titleView = titleStackView
    }
    
    @objc func chooseDate(sender: UIButton) {
        print("button click")
    }
} // ViewController Class

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        return cell
    }
    
    
}

