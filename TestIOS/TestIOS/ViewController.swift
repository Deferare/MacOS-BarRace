//
//  ViewController.swift
//  TestIOS
//
//  Created by Deforeturn on 3/13/22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var countView:UILabel!
    
    var changeValue = [Float]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for i in 0..<1000{
//            self.changeValue.append(Float(i))
//        }
        
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.start))
        self.countView.addGestureRecognizer(gesture)
    }
}

extension ViewController{
    @objc func start(){
        print("Start@@@@")
        UIView.animate(withDuration: 1){
            self.countView.text = self.countView.text?.padding(toLength: 10, withPad: "", startingAt: 0)
        }
    }
}

