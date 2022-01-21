//
//  AddNoteViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/19.
//

import UIKit
import CoreData

// 테이블 뷰 갱신을 위한 프로토콜
protocol AddNoteViewControllerDeligate: AnyObject {
    func didFinishSaveData()
}

class AddNoteViewController: UIViewController {

    // 프로토콜 펑션을 갖고 있는 변수 생성 (비어 있을 수 있으니 옵셔널)
    weak var delegate: AddNoteViewControllerDeligate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var saveButton_Outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopUpView()
        makeSaveButtonDesign()
        setTextFieldBorder()
        titleTextField.delegate = self
        titleTextField.addTarget(self, action: #selector(changeSaveButton), for: .editingChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.titleTextField.becomeFirstResponder()
    }
    
    func setTextFieldBorder() {
        let border = CALayer()
        border.frame = CGRect(x: 0, y: titleTextField.frame.size.height-1, width: titleTextField.frame.width, height: 2)
        border.backgroundColor = UIColor.darkGray.cgColor
        
        titleTextField.borderStyle = .none
        titleTextField.layer.addSublayer((border))
    }
    
    func setPopUpView() {
        popUpView.layer.shadowColor = UIColor.black.cgColor
        popUpView.layer.shadowOffset = CGSize(width: 1, height: 1)
        popUpView.layer.shadowRadius = 6
        popUpView.layer.shadowOpacity = 0.3
        popUpView.layer.cornerRadius = 15
        popUpView.clipsToBounds = true
        view.addSubview(popUpView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    @objc func changeSaveButton() {
        guard let textCheck = titleTextField.text else { return }
        if !textCheck.trimmingCharacters(in: .whitespaces).isEmpty {
            saveButton_Outlet.isEnabled = true
            saveButton_Outlet.layer.backgroundColor = UIColor.black.cgColor
        }else{
            saveButton_Outlet.isEnabled = false
            saveButton_Outlet.layer.backgroundColor = UIColor.systemGray5.cgColor
        }
    }
    
    func makeSaveButtonDesign() {
        saveButton_Outlet.layer.cornerRadius = 10
        saveButton_Outlet.isEnabled = false
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveNote()
        delegate?.didFinishSaveData() // 저장 끝나는 시점에 데이터를 호출한다
        // 화면 닫기
        self.dismiss(animated: true)
    }
    
    //MARK: - 해당 정보를 코어데이터에 저장한다
    func saveNote() {
        // 구조 만들기
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "NoteList", in: context) else { return }
        guard let note = NSManagedObject(entity: entityDescription, insertInto: context) as? NoteList else { return }
        
        // 어떤 값을 넣어서 저장할지 오브젝트 형태로 구조 잡기
        note.title = titleTextField.text?.trimmingCharacters(in: .whitespaces)
        note.uuid = UUID()
        note.date = Date()
        
        // 저장
        appDelegate.saveContext()
    }
    
    @IBAction func backGroundTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        self.dismiss(animated: false)
    }
}

extension AddNoteViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textFeirld: UITextField) -> Bool{
        saveButtonTapped(self.saveButton_Outlet)
        return true
    }
}
