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
    
    var datas:Array<CGFloat> = []
    var reciveDatas:Any!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.realtimeStart))
        self.stackView.addGestureRecognizer(gesture)
        
        // Data set - Test
        for _ in 0...25{
            let r = CGFloat.random(in: 100...1000)
            self.datas.append(r)
        }
        self.createSetView()
    }
}

extension BarRaceViewController{

    
    func createSetView(){
        for i in 0..<self.datas.count{
            let barView: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.widthAnchor.constraint(equalToConstant: CGFloat(self.datas[i])).isActive = true
                let nameLabel:UILabel = {
                    let LV = UILabel()
                    LV.text = "Apple"
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
                    LV.text = "\(self.datas[i])"
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
    @objc func realtimeStart(){
        
        // Bar sorting.
        var bias = 0
        Timer.scheduledTimer(withTimeInterval: -1, repeats: true) { timer in
            for i in bias..<self.datas.count-1{
                let leftW = self.stackView.arrangedSubviews[i].constraints[0].constant
                for j in i+1..<self.datas.count{
                    let rightW = self.stackView.arrangedSubviews[j].constraints[0].constant
                    if leftW < rightW {
                        UIViewPropertyAnimator(duration: 0.5, curve: .easeOut){
                            let tmp = self.stackView.arrangedSubviews[i]
                            self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j], at: i)
                            self.stackView.insertArrangedSubview(tmp, at: j)
                        }.startAnimation()
                        break
                    }
                }
            }
            bias += 1
            if bias == self.datas.count{bias = 0}
        }
        
        // Value changing - Test
        Timer.scheduledTimer(withTimeInterval: -1, repeats: true){_ in
            var changeValues = [CGFloat]()
            for i in 0..<self.datas.count{
                let ran = CGFloat.random(in: self.datas[i]-1...self.datas[i]+1)
                changeValues.append(ran)
            }
            for i in 0..<self.datas.count{
                let widthBias = changeValues[i]/self.datas[i]
                self.datas[i] *= widthBias
                UIViewPropertyAnimator(duration: 1, curve: .easeOut){
                    self.stackView.arrangedSubviews[i].constraints[0].constant *= CGFloat(widthBias)
                    let labelV = self.stackView.arrangedSubviews[i].subviews[1] as! UILabel
                    labelV.text = "\(Float(labelV.text!)! * Float(widthBias))"
                    self.stackView.layoutIfNeeded()
                }.startAnimation()
            }
        }
        
        // Bar scale adjust.
//        Timer.scheduledTimer(withTimeInterval: -1, repeats: true) {_ in
//            for i in 0..<self.datas.count{
//
//            }
//        }
    }
}




