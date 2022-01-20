//
//  SelectDateViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/20.
//

import UIKit

protocol SelectDateViewControllerDeligate: AnyObject {
    func selectDateText(_ selectedDate: String)
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
    
    @IBAction func dateChanged(_ sender: UIDatePicker) {
        let selected = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 \nMM월 dd일"
        formatter.locale = Locale(identifier: "ko")
        let selectedDate = formatter.string(from: selected.date)
        delegate?.selectDateText(selectedDate)
    }

    @IBAction func dateSaveButtonTapped(_ sender: UIButton) {
        // 선택한 날짜와 테이블 뷰 엔티티 데이트와 일 까지만 일치하면
        // 그 테이블 뷰를 로드하고 아니면,, 모르겠다
        self.dismiss(animated: false)
    }
    
}
