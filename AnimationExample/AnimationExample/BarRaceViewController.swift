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
    var tBias = 0
    var dType = 0
    
    // 600 = 3.75 * 160
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.startRealTime))
        self.stackView.addGestureRecognizer(gesture)
        
        print("Start - @@@@@@@@@@@@@")
        
        print(self.datas[0])
        print(self.datas[1])
        print(self.tBias, self.dType)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createSetView()
    }
}

extension BarRaceViewController{

    
    func createSetView(){
        self.year.text = "\(self.datas[1][0])"
        for i in 1..<self.datas[0].count{
            let barView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                
                
                if let conValue = self.datas[1][i] as? CGFloat{
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
                    if let v = self.datas[1][i] as? CGFloat{
                        print(v)
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
        }
    }
    
    
    // MaxBarWidth = 1795
    @objc func startRealTime(){
        print("@@@@@@@@@ startRealTime")
        

        self.valueChange()
    }
    
    func sortingBar(_ i:Int,_ j:Int) {
        if let above = self.stackView.arrangedSubviews[i].subviews[1] as? UILabel{
            let aboveValue = Float(above.text!)!
            if let below = self.stackView.arrangedSubviews[j].subviews[1] as? UILabel{
                let belowValue = Float(below.text!)!
                if aboveValue < belowValue {
                    UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                        let tmp = self.stackView.arrangedSubviews[i]
                        self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j], at: i)
                        self.stackView.insertArrangedSubview(tmp, at: j)
                    }.startAnimation()
                }
            }
        }
    }
    
    func valueChange(){
        var index = 2
        let tBias = Double(self.tBias)/Double(self.datas.count)
        let valueChangeSpeed = CGFloat(10)
        print(tBias)
        Timer.scheduledTimer(withTimeInterval: tBias, repeats: true){t in
            for j in 1..<self.datas[0].count{
                guard let S = self.datas[index][j] as? CGFloat else{return}
                let eachValue = S/valueChangeSpeed
                var k = 0
                if let subValue = self.stackView.arrangedSubviews[j-1].subviews[1] as? UILabel{
                    Timer.scheduledTimer(withTimeInterval: tBias/valueChangeSpeed, repeats: true){t2 in
                        if let subViewValue = Float(subValue.text!) {
                            if self.dType == 0{
                                subValue.text = String(Int(CGFloat(subViewValue) + CGFloat(eachValue)))
                            }else{
                                subValue.text = String(format: "%.1f", (CGFloat(subViewValue) + CGFloat(eachValue)))
                            }
//                            UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut){
//                                self.stackView.arrangedSubviews[j-1].constraints[0].constant += CGFloat(subViewValue)/10
//                                self.stackView.layoutIfNeeded()
//                            }.startAnimation()
                        }
                        k += 1
                        if k == Int(valueChangeSpeed) {t2.invalidate()}
                    }
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



