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
    
//    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteListsInCoreData = [NoteList]()
    
    // MARK: ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDateTitle()
        makeEditButton()
        makeAddButtonDesign()
        
        let listCellNib = UINib(nibName: "ListCell", bundle: nil)
        noteListTableView.register(listCellNib, forCellReuseIdentifier: "ListCell")
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        noteListTableView.separatorStyle = .none
        
        fetchData()
        noteListTableView.reloadData()

        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
    }
    
    func makeEditButton() {
        let editButtonImage = UIImage(systemName: "highlighter")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .done, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = editButton
    }
    
    @objc func editButtonTapped() {
        
    }
        
    func makeAddButtonDesign() {
        addNoteButton_Outlet.layer.cornerRadius = addNoteButton_Outlet.bounds.height / 2
        addNoteButton_Outlet.layer.shadowColor = UIColor.black.cgColor
        addNoteButton_Outlet.layer.shadowOffset = CGSize(width: 1, height: 1)
        addNoteButton_Outlet.layer.shadowRadius = 6
        addNoteButton_Outlet.layer.shadowOpacity = 0.15
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        let addNoteVC = AddNoteViewController.init(nibName: "AddNoteViewController", bundle: nil)
        addNoteVC.delegate = self // MainVC와 연결
        addNoteVC.modalPresentationStyle = .overFullScreen
        self.present(addNoteVC, animated: false, completion: nil)
    }
    
    func setDateTitle() {
        dateTitleLabel.text = getCurrentDate()
        dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        dateTitleLabel.textColor = .black
    }

    @IBAction func selectDate(_ sender: UIButton) {
        let selectDateVC = SelectDateViewController.init(nibName: "SelectDateViewController", bundle: nil)
        selectDateVC.delegate = self
        selectDateVC.modalPresentationStyle = .overFullScreen
        self.present(selectDateVC, animated: false, completion: nil)
    }
    
    func getCurrentDate() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: current)
    }
    
    // NoteList is entities name
    // MARK: fetchData - 데이터 불러오기
    func fetchData() {
        let fetchReqeust: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        do {
            self.noteListsInCoreData = try context.fetch(fetchReqeust)
        }catch{
            print(error)
        }
    }
    
    // 노트 왼쪽으로 밀어서 삭제
    func deleteNote(object: NSManagedObject) -> Bool {
        context.delete(object)
        do {
            try context.save()
            return true
        } catch {
            context.rollback()
            return false
        }
    }
} // MainViewController Class

// MARK: TableView Delegate and DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noteListsInCoreData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.listTitleLabel.text = noteListsInCoreData[indexPath.row].title
        
        return cell
    }
    
    // 삭제기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = self.noteListsInCoreData[indexPath.row]
        if self.deleteNote(object: note), editingStyle == .delete {
            noteListsInCoreData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

// MARK:  AddNoteDeligate - 추가 버튼 데이터 불러온 후 리로드
extension MainViewController: AddNoteViewControllerDeligate {
    func didFinishSaveData() {
        self.fetchData() // 데이터를 불러오고
        self.noteListTableView.reloadData() // 리로드
    }
}

extension MainViewController: SelectDateViewControllerDeligate {
    func selectDateText(_ date: String) {
        self.dateTitleLabel.text = date
    }
}
