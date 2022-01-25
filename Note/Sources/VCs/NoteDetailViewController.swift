//
//  NoteDetailViewController.swift
//  Note
//
//  Created by 박소진 on 2022/01/21.
//

import UIKit

class NoteDetailViewController: UIViewController {

//    var noteTitle = ""
    
    @IBOutlet weak var noteTitleLable: UILabel!
    
    var selectedNoteList = NoteList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        noteTitleLable.text = noteTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noteTitleLable.text = selectedNoteList.title
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
