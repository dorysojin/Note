//
//  ViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/15.
//

import UIKit
import CoreData

class MainViewController: UIViewController {

    @IBOutlet weak var noteListTableView: UITableView!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var addNoteButton_Outlet: UIButton!
    
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var titleDatePicker = UIDatePicker()
    var datePrickerToolBar = UIToolbar()
    var noteList = [NoteList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateTitle()
        makeRightButton()
        
        let listCellnib = UINib(nibName: "ListCell", bundle: nil)
        noteListTableView.register(listCellnib, forCellReuseIdentifier: "ListCell")
        noteListTableView.separatorStyle = .none
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        
        setAddButton()
        fetchData()
        noteListTableView.reloadData()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    func setAddButton() {
        addNoteButton_Outlet.layer.cornerRadius = 30
        addNoteButton_Outlet.layer.shadowColor = UIColor.black.cgColor
        addNoteButton_Outlet.layer.shadowOffset = CGSize(width: 1, height: 1)
        addNoteButton_Outlet.layer.shadowRadius = 6
        addNoteButton_Outlet.layer.shadowOpacity = 0.15
    }
    
    // NoteList is entities name
    // MARK: fetchData - 데이터 불러오기
    func fetchData() {
        let fetchReqeust: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        let context = appdelegate.persistentContainer.viewContext
        do {
            self.noteList = try context.fetch(fetchReqeust)
        }catch{
            print(error)
        }
    }
    
    func makeRightButton() {
        let editButtonImage = UIImage(systemName: "highlighter")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .done, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .darkGray

        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonTapped() {
        print("click Edit Button")
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        let addNoteVC = AddNoteViewController.init(nibName: "AddNoteViewController", bundle: nil)
        addNoteVC.delegate = self // 데이터 부르고 리로드
        addNoteVC.modalPresentationStyle = .overFullScreen
        self.present(addNoteVC, animated: false, completion: nil)
        
    }
    
    func setDateTitle() {
        dateTitleLabel.text = getCurrentDate()
        dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        dateTitleLabel.textColor = .black
    }
    
    func setDatePicker() {
        titleDatePicker.datePickerMode = .date
        titleDatePicker.preferredDatePickerStyle = .wheels
        titleDatePicker.backgroundColor = UIColor.white
        titleDatePicker.autoresizingMask = .flexibleWidth
        titleDatePicker.locale = Locale(identifier: "ko-KR")
        titleDatePicker.frame = CGRect(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        titleDatePicker.addTarget(self, action: #selector(self.dateChanged(_:)), for: .valueChanged)
        self.view.addSubview(titleDatePicker)
    }
    
    func setDateToolBar() {
        datePrickerToolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
        datePrickerToolBar.barTintColor = UIColor.white
        datePrickerToolBar.sizeToFit()
        datePrickerToolBar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(self.onDoneButtonClick))]
        self.view.addSubview(datePrickerToolBar)
    }
    
    @IBAction func chooseDate(_ sender: UIButton) {
        setDatePicker()
        setDateToolBar()
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        let selected = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        
        dateTitleLabel.text = formatter.string(from: selected.date)
    }

    @objc func onDoneButtonClick() {
        datePrickerToolBar.removeFromSuperview()
        titleDatePicker.removeFromSuperview()
        //그 선택한 날짜의 목록으로 바뀌어야 함
    }
    
    func getCurrentDate() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")

        return formatter.string(from: current)
    }
} // MainViewController Class

// MARK: TableView Delegate and DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.listTitleLabel.text = noteList[indexPath.row].title

        return cell
    }
}

// MARK:  AddNoteDeligate - 추가 버튼 데이터 불러온 후 리로드
extension MainViewController: AddNoteViewControllerDeligate {
    func didFinishSaveDate() {
        self.fetchData() // 데이터를 불러오고
        self.noteListTableView.reloadData() // 리로드
    }
}
