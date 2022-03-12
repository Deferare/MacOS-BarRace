//
//  FileSetViewController.swift
//  AnimationExample
//
//  Created by Deforeturn on 3/11/22.
//

import UIKit
import Foundation
import UniformTypeIdentifiers

class FileImportViewController: UIViewController, UIDocumentPickerDelegate {
    var importDatas = [[Any]]()
    
    @IBOutlet var importBtn:UIButton!
    var docuPickerVC:UIDocumentPickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.importBtn.layer.masksToBounds = false
        self.importBtn.layer.cornerRadius = 15
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let VC = segue.destination as? BarRaceViewController else {return}
        VC.recive = self.importDatas
    }
}

extension FileImportViewController{
    @IBAction func importBtnAction(_ sender:UIButton){
        let supportedTypes = [UTType.text]
        
        docuPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        docuPickerVC.delegate = self
//        docuPickerVC.directoryURL =
        docuPickerVC.allowsMultipleSelection = false
        docuPickerVC.shouldShowFileExtensions = true
        self.present(docuPickerVC, animated: true, completion: nil)
        
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let url = urls[0]
        NSFileCoordinator().coordinate(readingItemAt: url, error: nil) { url in
            do {
                let data = try Data(contentsOf:url)
                let attStr = try NSAttributedString(data: data, documentAttributes: .none)
                let fullText = attStr.string
                let fullText2 = fullText.split(separator: "\r\n")
                for tex in fullText2{
                    let crnt = tex.split(separator: ",")
                    var tmps = [String]()
                    for crnt in crnt {
                        if crnt != ","{
                            tmps.append(String(crnt))
                        }
                    }
                    self.importDatas.append(tmps)
                }
                print(self.importDatas)
                self.performSegue(withIdentifier: "Entry", sender: nil)
            }catch {print(error.localizedDescription)}
        }
    }
}

struct TestData: Codable{
    var Untitled:Dictionary<String,String>
}
