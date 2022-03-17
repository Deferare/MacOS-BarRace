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
    
    var keys = [Substring.SubSequence]()
    var importDatas = Dictionary<String, [Any]>()
    var docuPickerVC:UIDocumentPickerViewController!
    var sumMax = CGFloat(0)
    
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
        for key in keys{
            let key = String(key)
            VC.keys.append(key)
            if key != "Date"{
                var c = CGFloat(0)
                for v in self.importDatas[key]!{
                    if let v = v as? CGFloat{
                        c += v
                    }
                }
                if c > self.sumMax{
                    self.sumMax = c
                }
            }
        }
        

//        VC.constBias = 2230/self.sumMax // For my.
        VC.constBias = (UIScreen.main.bounds.width-250)/self.sumMax
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
                self.keys = dataText2[0].split(separator: ",")
                for name in keys{
                    self.importDatas[String(name)] = [Any]()
                }
                for i in 1..<dataText2.count{
                    let crnt = dataText2[i].split(separator: ",")
                    for j in 0..<crnt.count{
                        if j == 0{
                            let date = String(crnt[j])
                            self.importDatas[String(keys[j])]?.append(String(date))
                        } else{
                            self.importDatas[String(keys[j])]?.append(CGFloat(Float(crnt[j].description)!))
                        }
                    }
                }
                self.performSegue(withIdentifier: "Entry", sender: nil)
            }catch {print(error.localizedDescription)}
        }
    }
}

struct TestData: Codable{
    var Untitled:Dictionary<String,String>
}
