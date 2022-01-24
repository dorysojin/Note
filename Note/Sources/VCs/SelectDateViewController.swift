//
//  SelectDateViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/20.
//

import UIKit
import CoreData

protocol SelectDateViewControllerDeligate: AnyObject {
    func didFinishSelectDate(_ selectedDate: Date)
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
        titleDatePicker.locale = Locale(identifier: "ko-KR")
        titleDatePicker.timeZone = .autoupdatingCurrent
    }
    override func viewWillAppear(_ animated: Bool) {
        titleDatePicker.date = UserDefaults.standard.object(forKey: "dateSave") as? Date ?? Date()
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
    
    // MARK: - IBAction - 완료 버튼 눌렀을 때
    @IBAction func dateSaveButtonTapped(_ sender: UIButton) {
        // 데이트 피커 값 저장
        let theDate = titleDatePicker.date
        UserDefaults.standard.setValue(theDate, forKey: "dateSave")
        
        // 선택한 데이트 피커 값 메인 텍스트 라벨로 전달
        delegate?.didFinishSelectDate(theDate)
        
        self.dismiss(animated: false)
    }
}
