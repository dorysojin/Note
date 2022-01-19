//
//  AddNoteViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/19.
//

import UIKit
import CoreData

protocol AddNoteViewControllerDeligate: AnyObject {
    func didFinishSaveDate()
}

class AddNoteViewController: UIViewController {

    weak var delegate: AddNoteViewControllerDeligate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var saveButton_Outlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPopUpView()
        setSaveButton()
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
    
    func setSaveButton() {
        saveButton_Outlet.layer.cornerRadius = 10
        
    }

    @IBAction func saveButtonTapped(_ sender: UIButton) {
        // 구조 만들기
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "NoteList", in: context) else { return }
        
        guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? NoteList else{
            return
        }
        
        // 오브젝트 생성
        object.title = titleTextField.text
        object.date = Date()
        object.uuid = UUID()
        
        // 저장
        appDelegate.saveContext()
        
        //저장 끝나는 시점에 호출한다
        delegate?.didFinishSaveDate()
        
        // 화면 닫기
        self.dismiss(animated: true, completion: nil)
    }
}
