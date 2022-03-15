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
    
    var startTurn = 1
    var datas = Dictionary<String, [Any]>()
    var keys = [String]()
    var tBias = 0
    var dType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.startRealTime))
        self.stackView.addGestureRecognizer(gesture)
        
        print("Start - @@@@@@@@@@@@@")
        print(self.datas["윤석열"]!)
        print(self.keys)
        print(self.tBias, self.dType)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createSetView()
    }
}

extension BarRaceViewController{

    func createSetView(){
        self.year.text = "\(self.datas[self.keys[0]]!)"
        for i in 1..<self.keys.count{
            let barView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                
                
                if let conValue = self.datas[self.keys[i]]![0] as? CGFloat{
                    view.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(conValue)).isActive = true
                }
                
                
                
                
                let nameLabel:UILabel = {
                    let LV = UILabel()
                    
                    LV.text = "\(self.keys[i])"
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
                    if let v = self.datas[self.keys[i]]![0] as? CGFloat{
                        if self.dType == 0{
                            LV.text = String(Int(v))
                        } else{
                            LV.text = String(format: "%.1f", v)
                        }
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
            self.stackView.arrangedSubviews[i-1].tag = i
        }
    }
    
    
    // MaxBarWidth = 1795
    @objc func startRealTime(){
        print("@@@@@@@@@ startRealTime")
        if self.startTurn > 0{
            self.valueChange()
            self.sortingBar()
        }
    }
    
    func sortingBar(){
        print("sortingBar.")
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true){t in
            for i in 0..<self.keys.count-2{
                for j in i+1..<self.keys.count-1{
                    guard let above = self.stackView.arrangedSubviews[i].subviews[1] as? UILabel else {return}
                    guard let below = self.stackView.arrangedSubviews[j].subviews[1] as? UILabel else {return}

                    let aboveValue = Float(above.text!)!
                    let belowValue = Float(below.text!)!
                            
                    if aboveValue < belowValue {
                        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                            let tmp = self.stackView.arrangedSubviews[i]
                            self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j] , at: i)
                            self.stackView.insertArrangedSubview(tmp, at: j)
                        }.startAnimation()
                    }
                }
            }
            if self.startTurn <= 0{
                t.invalidate()
            }
        }
    }
    
    func valueChange(){
        var index = 1
        let tBias = Double(self.tBias)/Double(self.datas[self.keys[0]]!.count)
        let valueChangeSpeed = CGFloat(10)
        print(tBias)
        Timer.scheduledTimer(withTimeInterval: tBias, repeats: true){t in
            for i in 1..<self.keys.count{
                let sub = self.stackView.viewWithTag(i)!
                guard let subName = sub.subviews[0] as? UILabel else{return}
                guard let subValue = sub.subviews[1] as? UILabel else{return}
                guard let newValue = self.datas[subName.text!]![index] as? CGFloat else{return}
                
                let eachValue = newValue/valueChangeSpeed
                var k = 0
                Timer.scheduledTimer(withTimeInterval: tBias/valueChangeSpeed, repeats: true){t2 in
                    if let subViewValue = Float(subValue.text!) {
                        if self.dType == 0{
                            subValue.text = String(Int(CGFloat(subViewValue) + CGFloat(eachValue)))
                        }else{
                            subValue.text = String(format: "%.1f", (CGFloat(subViewValue) + CGFloat(eachValue)))
                        }
                        UIViewPropertyAnimator(duration: 0.001, curve: .easeOut){
                            sub.constraints[0].constant *= CGFloat(1.001)
                            sub.layoutIfNeeded()
                        }.startAnimation()
                    }
                    k += 1
                    if k == Int(valueChangeSpeed) {t2.invalidate()}
                }
                
            }
            
            print(index)
            index += 1
            if index == self.datas[self.keys[0]]!.count {
                t.invalidate()
                self.startTurn = 0
            }
        }
    }
}





// Bar scale adjust.
//        Timer.scheduledTimer(withTimeInterval: -1, repeats: true) {_ in
//            for i in 0..<self.datas.count{
//
//            }
//        }



