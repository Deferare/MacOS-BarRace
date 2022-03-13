//
//  ViewController.swift
//  AnimationExample
//
//  Created by Deforeturn on 3/9/22.
//

import UIKit
import Foundation

class BarRaceViewController: UIViewController {
    
    
    
    @IBOutlet var stackView:UIStackView!
    @IBOutlet var year:UILabel!
    
    var datas = [[Any]]()
    var timeBias:Int!
    var dType:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.startRealTime))
        self.stackView.addGestureRecognizer(gesture)
        
        print("Start - @@@@@@@@@@@@@")
        print(self.datas[0])
        print(self.datas[1])
        print(self.timeBias, self.dType)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.createSetView()
        self.year.text = "\(self.datas[1][0])"
    }
}

extension BarRaceViewController{

    
    func createSetView(){
        for i in 1..<self.datas[0].count{
            let barView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                if let conValue = self.datas[1][i] as? Float{
                    view.widthAnchor.constraint(equalToConstant: CGFloat(conValue)).isActive = true
                }
                
                let nameLabel:UILabel = {
                    let LV = UILabel()
                    LV.text = "\(self.datas[0][i])"
                    LV.font = .systemFont(ofSize: 15, weight: .semibold)
                    LV.textAlignment = .left
                    return LV
                }()
                
                view.addSubview(nameLabel)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7).isActive = true
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
                
                let valueLable:UILabel = {
                    let LV = UILabel()
                    if let conValue = self.datas[1][i] as? Float{
                        LV.text = "\(CGFloat(conValue))"
                    }
                    LV.font = .systemFont(ofSize: 15, weight: .regular)
                    LV.textAlignment = .left
                    LV.frame.size.width = 50
                    return LV
                }()
                
                view.addSubview(valueLable)
                valueLable.translatesAutoresizingMaskIntoConstraints = false
                valueLable.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
                valueLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                valueLable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                valueLable.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
                
                return view
                }()
            
            barView.layer.cornerRadius = 15
            barView.layer.masksToBounds = false
            self.stackView.addArrangedSubview(barView)
        }
    }
    
    
    // MaxBarWidth = 1795
    @objc func startRealTime(){
        print("@@@@@@@@@ startRealTime")
        // Sorting.
//        var bias = 1
//        Timer.scheduledTimer(withTimeInterval: -1, repeats: true) { timer in
//            for i in bias..<self.datas[0].count-1{
//                let leftW = self.stackView.arrangedSubviews[i].constraints[0].constant
//                print(leftW)
//                for j in i+1..<self.datas[0].count{
//                    let rightW = self.stackView.arrangedSubviews[j].constraints[0].constant
//                    if leftW < rightW {
//                        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
//                            let tmp = self.stackView.arrangedSubviews[i]
//                            self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j], at: i)
//                            self.stackView.insertArrangedSubview(tmp, at: j)
//                        }.startAnimation()
//                        break
//                    }
//                }
//            }
//            bias += 1
//            if bias == self.datas[0].count{bias = 1}
//        }
        
        // Value changing
        var index = 2
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true){t in
            for j in 1..<self.datas[0].count{
                guard let S = self.datas[index][j] as? Float else {return}
                let eachValue = S/Float(self.timeBias)
                var k = 0
                Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){t2 in
                    if let subView = self.stackView.arrangedSubviews[j-1].subviews[1] as? UILabel{
                        if let subViewValue = Float(subView.text!) {
                            subView.text = "\(subViewValue + eachValue)"
                        }
                    }
                    k += 1
                    if k == self.timeBias {t2.invalidate()}
                }
            }
            print(index)
            index += 1
            if index == self.datas.count {t.invalidate()}
        }
    }
}



// Bar scale adjust.
//        Timer.scheduledTimer(withTimeInterval: -1, repeats: true) {_ in
//            for i in 0..<self.datas.count{
//
//            }
//        }



