//
//  ViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/15.
//

import UIKit
import CoreData

protocol MainViewControllerDelegate {
    func didFinishAddButton(_ date: Date)
}

class MainViewController: UIViewController {
    var delegate: MainViewControllerDelegate?

    @IBOutlet weak var noteListTableView: UITableView!
    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var addNoteButton_Outlet: UIButton!

//    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    var noteListsInCoreData = [NoteList]()
    var filterNoteLists = [NoteList]()
    var selectedDatePicker = Date()
    
    // MARK: - ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDateTitle()
        setNavigationBar()
        makeAddButtonDesign()
        
        setNoteTableView()
        
//        fetchData()
        fetchSelectedData()
        noteListTableView.reloadData()
    }
    
    // MARK: - 기본 세팅들
    func setDateTitle() {
        dateTitleLabel.text = getCurrentDate()
        dateTitleLabel.font = UIFont.boldSystemFont(ofSize: 25)
        dateTitleLabel.textColor = .black
    }
    
    func setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        makeEditButton()
    }
    
    func setNoteTableView() {
        noteListTableView.delegate = self
        noteListTableView.dataSource = self
        noteListTableView.separatorStyle = .none
    }
    
    func makeEditButton() {
        let editButtonImage = UIImage(systemName: "highlighter")
        let editButton = UIBarButtonItem(image: editButtonImage, style: .done, target: self, action: #selector(editButtonTapped))
        editButton.tintColor = .darkGray
        navigationItem.rightBarButtonItem = editButton
    }
    
    func makeAddButtonDesign() {
        addNoteButton_Outlet.layer.cornerRadius = addNoteButton_Outlet.bounds.height / 2
        addNoteButton_Outlet.layer.shadowColor = UIColor.black.cgColor
        addNoteButton_Outlet.layer.shadowOffset = CGSize(width: 1, height: 1)
        addNoteButton_Outlet.layer.shadowRadius = 6
        addNoteButton_Outlet.layer.shadowOpacity = 0.15
    }
    
    func getCurrentDate() -> String {
        let current = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        return formatter.string(from: current)
    }
    
    // MARK: - 액션이 있는 것들
    @objc func editButtonTapped() {
        
    }
    
    @IBAction func addNoteButtonTapped(_ sender: UIButton) {
        let addNoteVC = AddNoteViewController.init(nibName: "AddNoteViewController", bundle: nil)
        addNoteVC.delegate = self // MainVC와 addNoteVC 연결
        addNoteVC.modalPresentationStyle = .overFullScreen
        self.present(addNoteVC, animated: false, completion: nil)
    }

    @IBAction func selectDate(_ sender: UIButton) {
        let selectDateVC = SelectDateViewController.init(nibName: "SelectDateViewController", bundle: nil)
        selectDateVC.delegate = self
        selectDateVC.modalPresentationStyle = .overFullScreen
        self.present(selectDateVC, animated: false, completion: nil)
    }
    
    // NoteList is entities name
    // MARK: fetchData - 모든 데이터 불러오기
//    func fetchData() {
//        let fetchRequest: NSFetchRequest<NoteList> = NoteList.fetchRequest()
//        do {
//            self.noteListsInCoreData = try context.fetch(fetchRequest)
//        }catch{
//            print(error)
//        }
//    }
    
    // MARK: - fetchSelectedData - 선택한 날짜만 가져오기..?
    func fetchSelectedData() {
        let fetchRequest: NSFetchRequest<NoteList> = NoteList.fetchRequest()
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: selectedDatePicker)
        let endDate = calendar.date(byAdding: .day, value: 1, to: startDate)
        fetchRequest.predicate = NSPredicate(format: "date >= %@ AND date < %@", startDate as Date as CVarArg, endDate! as Date as CVarArg)
        do {
            self.filterNoteLists = try context.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }
    
    // MARK: - 메인화면에서 리스트 밀어서 삭제
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


// MARK: - TableView Delegate and DataSource
extension MainViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filterNoteLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListCell
        cell.listTitleLabel.text = filterNoteLists[indexPath.row].title
                
        return cell
    }
    
    // MARK: 삭제 기능
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let note = self.filterNoteLists[indexPath.row]
        if self.deleteNote(object: note), editingStyle == .delete {
            filterNoteLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
}

// MARK: - AddNoteDeligate - 추가 버튼 데이터 불러온 후 리로드
extension MainViewController: AddNoteViewControllerDeligate {
    func didFinishSaveData() {
        self.fetchSelectedData() // 데이터를 불러오고
        self.noteListTableView.reloadData() // 리로드
    }
}

// MARK: - SelectDateVC Deligate
extension MainViewController: SelectDateViewControllerDeligate {
    func didFinishSelectDate(_ selectedDate: Date) {
        self.selectedDatePicker = selectedDate

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        let dateString = formatter.string(from: selectedDate)
        self.dateTitleLabel.text = dateString

        self.fetchSelectedData()
        self.noteListTableView.reloadData()
    }
}
