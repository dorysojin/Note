//
//  ViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/15.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var noteListTableView: UITableView!
    
    let dateTitle = UILabel()
    var titleDatePicker = UIDatePicker()
    var datePrickerToolBar = UIToolbar()
    
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
        dateTitle.text = getCurrentDate()
        dateTitle.font = UIFont.systemFont(ofSize: 18)
        dateTitle.textColor = .black
        
        let titleButton = UIButton()
        titleButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        titleButton.tintColor = .lightGray
        titleButton.addTarget(self, action: #selector(chooseDate), for: .touchUpInside)
        
        let titleStackView = UIStackView(arrangedSubviews: [dateTitle, titleButton])
        titleStackView.axis = .horizontal
        titleStackView.frame.size.width = dateTitle.frame.width + titleButton.frame.width
        
        self.navigationItem.titleView = titleStackView
    }
    
    @objc func chooseDate(_ sender: UIButton) {
        titleDatePicker.datePickerMode = .date
        titleDatePicker.preferredDatePickerStyle = .wheels
        titleDatePicker.backgroundColor = UIColor.white
        titleDatePicker.autoresizingMask = .flexibleWidth
        titleDatePicker.locale = Locale(identifier: "ko-KR")
        
        titleDatePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        titleDatePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(titleDatePicker)
                    
        datePrickerToolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        datePrickerToolBar.barTintColor = UIColor.white
        datePrickerToolBar.sizeToFit()
        
        datePrickerToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        self.view.addSubview(datePrickerToolBar)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selected = sender
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd"
        dateFormatter.locale = Locale(identifier: "ko")
        dateTitle.text = "\(dateFormatter.string(from: selected.date)) "
    }

    @objc func onDoneButtonClick() {
        datePrickerToolBar.removeFromSuperview()
        titleDatePicker.removeFromSuperview()
        //그 선택한 날짜의 목록으로 바뀌어야 함
    }
    
    func getCurrentDate() -> String {
        let current = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd "
        dateFormatter.locale = Locale(identifier: "ko")

        return dateFormatter.string(from: current)
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

