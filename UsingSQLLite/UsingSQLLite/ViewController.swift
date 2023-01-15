//
//  ViewController.swift
//  UsingSQLLite
//
//  Created by Cristina Richter on 08.01.2023.
//

import UIKit
import SQLite3


class ViewController: UIViewController {
    
    let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
    
    @IBOutlet weak var textField1: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var textView1: UITextView!
        
    @IBOutlet weak var textField1Like: UITextField!
    @IBOutlet weak var textField2Like: UITextField!
    
    @IBOutlet weak var textField1Eq: UITextField!
    @IBOutlet weak var textField2Eq: UITextField!
    
    @IBOutlet weak var textField1NotEqual: UITextField!
    @IBOutlet weak var textField2NotEqual: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func addData(_ sender: Any) {
        
        //insert query
        let insertStatementString = "INSERT INTO TEMP (TEMPCOLUMN1, TEMPCOLUMN2) VALUES (?, ?);"
        
        var insertStatementQuery : OpaquePointer?
        
        if (sqlite3_prepare_v2(dbQueue, insertStatementString, -1, &insertStatementQuery, nil)) == SQLITE_OK
        {
            sqlite3_bind_text(insertStatementQuery, 1, textField1.text ?? "", -1, SQLITE_TRANSIENT)
            sqlite3_bind_text(insertStatementQuery, 2, textField2.text ?? "", -1, SQLITE_TRANSIENT)
            
            if(sqlite3_step(insertStatementQuery)) == SQLITE_DONE
            {
                textField1.text=""
                textField2.text=""
                
                textField1.becomeFirstResponder()
                print("Successfully inserted the record")
            }
            else {
                print("Error inserting the record")
            }
            
            sqlite3_finalize(insertStatementQuery)
        }
        
        //select query and show it to the text view
        let selectStatementString = "SELECT TEMPCOLUMN1, TEMPCOLUMN2 FROM TEMP"
        
        var selectStatementQuery : OpaquePointer?
        
        var sShowData :String!
        
        sShowData = ""
        
        if (sqlite3_prepare_v2(dbQueue, selectStatementString, -1, &selectStatementQuery, nil) == SQLITE_OK)
        {
            while sqlite3_step(selectStatementQuery) == SQLITE_ROW {
                sShowData += String(cString: sqlite3_column_text(selectStatementQuery, 0)) + "\t\t" + String(cString: sqlite3_column_text(selectStatementQuery, 1)) + "\n"
            }
            sqlite3_finalize(selectStatementQuery)
        }
        textView1.text = sShowData ?? ""
    }
    
    @IBAction func likeBtn(_ sender: Any) {
        let textFieldLikeParameter = String(format: "%%%@%%", textField1Like.text!)
        print(textFieldLikeParameter)
    }
    
    
    @IBAction func equalBtn(_ sender: Any) {
    }
    
    
    @IBAction func notEqualBtn(_ sender: Any) {
    }
}

