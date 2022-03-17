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
    
    var startLife = 2
    var datas = Dictionary<String, [Any]>()
    var keys = [String]()
    var tBias = 0
    var dType = 0
    var constBias = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.startRealTime))
        self.stackView.addGestureRecognizer(gesture)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.createSetView()
        self.year.text = "\(self.datas[self.keys[0]]![0])"
    }
}

extension BarRaceViewController{

    func createSetView(){
        for i in 1..<self.keys.count{
            let barView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                
                if let conValue = self.datas[self.keys[i]]![0] as? CGFloat{
                    view.widthAnchor.constraint(equalToConstant: conValue*self.constBias).isActive = true
                }
                
                let nameLabel:UILabel = {
                    let LV = UILabel()
                    
                    LV.text = "\(self.keys[i])"
                    LV.font = .systemFont(ofSize: 30, weight: .semibold)
                    LV.numberOfLines = 5
                    LV.textAlignment = .left
                    LV.lineBreakMode = .byWordWrapping
                    LV.shadowColor = .systemGroupedBackground
                    LV.shadowOffset = .init(width: 0.5, height: 0.5)
                    return LV
                }()
                
                view.addSubview(nameLabel)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7).isActive = true
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                nameLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 200).isActive = true
                
                let valueLable:UILabel = {
                    let LV = UILabel()
                    if let v = self.datas[self.keys[i]]![0] as? CGFloat{
                        if self.dType == 0{
                            LV.text = String(Int(v))
                        } else{
                            LV.text = String(format: "%.1f", v)
                        }
                    }
                    LV.font = .systemFont(ofSize: 25, weight: .regular)
                    LV.textColor = .tintColor
                    LV.textAlignment = .right
                    return LV
                }()
                
                view.addSubview(valueLable)
                valueLable.translatesAutoresizingMaskIntoConstraints = false
                valueLable.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: 7).isActive = true
                valueLable.leadingAnchor.constraint(equalTo: view.subviews[0].trailingAnchor, constant: 7).isActive = true
                valueLable.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                valueLable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                return view
                }()

            barView.layer.cornerRadius = 15
            barView.layer.masksToBounds = false
            self.stackView.addArrangedSubview(barView)
            self.stackView.arrangedSubviews[i-1].tag = i
        }
    }
    
    
    @objc func startRealTime(){
        if self.startLife > 1{
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                self.startLife -= 1
                self.valueChangeRealtime()
                self.sortingBarRealtime()
            }
        }
    }
    
    func sortingBarRealtime(){
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true){t in
            for i in 0..<self.keys.count-2{
                for j in i+1..<self.keys.count-1{
                    guard let above = self.stackView.arrangedSubviews[i].subviews[1] as? UILabel else {return}
                    guard let below = self.stackView.arrangedSubviews[j].subviews[1] as? UILabel else {return}

                    let aboveValue = Float(above.text!)!
                    let belowValue = Float(below.text!)!
                            
                    if aboveValue < belowValue {
                        UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut){
                            let tmp = self.stackView.arrangedSubviews[i]
                            self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j] , at: i)
                            self.stackView.insertArrangedSubview(tmp, at: j)
                        }.startAnimation()
                    }
                }
            }
            if self.startLife <= 0{
                t.invalidate()
            }
        }
    }
    
    func valueChangeRealtime(){
        var index = 1
        let tBias = Double(self.tBias)/Double(self.datas[self.keys[0]]!.count)
        let valueChangeSpeed = CGFloat(10)
        Timer.scheduledTimer(withTimeInterval: tBias, repeats: true){t in
            self.year.text = "\(self.datas[self.keys[0]]![index])"
            for i in 1..<self.keys.count{
                let sub = self.stackView.viewWithTag(i)!
                guard let subName = sub.subviews[0] as? UILabel else{return}
                guard let subView1 = sub.subviews[1] as? UILabel else{return}
                guard let newValue = self.datas[subName.text!]![index] as? CGFloat else{return}
                
                let eachValue = CGFloat(newValue/valueChangeSpeed)
                
                var k = 0
                Timer.scheduledTimer(withTimeInterval: tBias/valueChangeSpeed, repeats: true){t2 in
                    if let subViewValue = Float(subView1.text!) {
                        if self.dType == 0{
                            subView1.text = String(Int(CGFloat(subViewValue) + eachValue))
                        }else{
                            subView1.text = String(format: "%.1f", (CGFloat(subViewValue) + eachValue))
                        }
                        
                        UIViewPropertyAnimator(duration: 0.1, curve: .easeInOut){
                            sub.layer.frame.size.width += (eachValue*self.constBias)
                            sub.constraints[0].constant += (eachValue*self.constBias)
                            sub.layoutIfNeeded()
                        }.startAnimation()
                    }
                    k += 1
                    if k == Int(valueChangeSpeed) {t2.invalidate()}
                }
            }
            
            index += 1
            if index == self.datas[self.keys[0]]!.count {
                t.invalidate()
                self.startLife -= 1
            }
        }.fire()
    }
}
