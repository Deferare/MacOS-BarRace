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
    
    @IBOutlet var typeSeg:UISegmentedControl!
    @IBOutlet var timeSeg:UISegmentedControl!
    @IBOutlet var importBtn:UIButton!
    
    
    var importDatas = [[Any]]()
    var docuPickerVC:UIDocumentPickerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.importBtn.layer.masksToBounds = false
        self.importBtn.layer.cornerRadius = 15
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let VC = segue.destination as? BarRaceViewController else {return}
        VC.datas = self.importDatas
        VC.dType = self.typeSeg.selectedSegmentIndex
        let tIndex = self.timeSeg.selectedSegmentIndex
        if tIndex == 0{
            VC.tBias = 60
        } else if tIndex == 1{
            VC.tBias = 180
        } else if tIndex == 2{
            VC.tBias = 300
        } else{
            VC.tBias = 600
        }
    }
}

extension FileImportViewController{
    @IBAction func importBtnAction(_ sender:UIButton){
        let supportedTypes = [UTType.text]
        
        docuPickerVC = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        docuPickerVC.delegate = self
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
                let dataText = attStr.string
                let dataText2 = dataText.split(separator: "\r\n")
                
                for i in 0..<dataText2.count{
                    let crnt = dataText2[i].split(separator: ",")
                    var crnt2 = [Any]()
                    if i != 0{
                        for j in 0..<crnt.count{
                            if j != 0{
                                crnt2.append(CGFloat(Float(crnt[j].description)!))
                            }else{
                                let date = String(crnt[j])
                                crnt2.append(Date(date))
                            }
                        }
                    } else{
                        crnt2 = crnt.map {String($0)}
                    }
                    self.importDatas.append(crnt2)
                }
                self.performSegue(withIdentifier: "Entry", sender: nil)
            }catch {print(error.localizedDescription)}
        }
    }
}

struct TestData: Codable{
    var Untitled:Dictionary<String,String>
}


extension Date{
    init(_ dateString:String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd-HH"
        let date = dateStringFormatter.date(from: dateString)!
        self = date
    }
}
