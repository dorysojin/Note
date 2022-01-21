//
//  SelectDateViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/20.
//

import UIKit
import CoreData

protocol SelectDateViewControllerDeligate: AnyObject {
    func getSelectedDateText(_ selectedDate: String)
    func selectedDate( selectedDate: Date)
}

class SelectDateViewController: UIViewController {
    
    weak var delegate: SelectDateViewControllerDeligate?

    @IBOutlet weak var datePopUpView: UIView!
    @IBOutlet weak var dateSaveButton_Outlet: UIButton!
    @IBOutlet weak var titleDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopUpView()
        makeSaveButtonDesign()
    }
    
    func setPopUpView() {
        datePopUpView.layer.shadowColor = UIColor.black.cgColor
        datePopUpView.layer.shadowOffset = CGSize(width: 1, height: 1)
        datePopUpView.layer.shadowRadius = 6
        datePopUpView.layer.shadowOpacity = 0.3
        datePopUpView.layer.cornerRadius = 15
        datePopUpView.clipsToBounds = true
        view.addSubview(datePopUpView)
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func makeSaveButtonDesign() {
        dateSaveButton_Outlet.layer.cornerRadius = 10
        dateSaveButton_Outlet.layer.backgroundColor = UIColor.black.cgColor
    }

    @IBAction func dateSaveButtonTapped(_ sender: UIButton) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        
        let dateString = formatter.string(from: titleDatePicker.date)
        delegate?.getSelectedDateText(dateString)
        
        delegate?.selectedDate(selectedDate: titleDatePicker.date)
        self.dismiss(animated: false)
    }
}
