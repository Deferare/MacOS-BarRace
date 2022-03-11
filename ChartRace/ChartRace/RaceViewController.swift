//
//  RaceViewController.swift
//  ChartRace
//
//  Created by Deforeturn on 3/11/22.
//

import Cocoa
import Foundation


class RaceViewController: NSViewController {
    
    @IBOutlet var stackView:NSStackView!
    @IBOutlet var year:NSTextField!
    var datas:Array<CGFloat> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let gesture = NSGestureRecognizer(target: self, action: #selector(self.realtimeStart))
        self.stackView.addGestureRecognizer(gesture)
        
        // Data set - Test
        for _ in 0...25{
            let r = CGFloat.random(in: 100...1000)
            self.datas.append(r)
        }
        self.createSetView()
    }
    
}
extension RaceViewController{
    func createSetView(){
        for i in 0..<self.datas.count{
            let barView: NSView = {
                let view = NSView()
                
                view.window?.backgroundColor = NSColor(red: CGFloat.random(in: 0.2...0.8),
                                                  green: CGFloat.random(in: 0.2...0.8),
                                                  blue: CGFloat.random(in: 0.2...0.8),
                                                  alpha: 1)
                view.translatesAutoresizingMaskIntoConstraints = false
                view.widthAnchor.constraint(equalToConstant: CGFloat(self.datas[i])).isActive = true
                let nameLabel:NSTextField = {
                    let LV = NSTextField()
                    LV.window?.title = "Apple"
                    LV.font = .systemFont(ofSize: 15, weight: .semibold)
                    LV.alignment = .left
                    return LV
                }()
                
                view.addSubview(nameLabel)
                nameLabel.translatesAutoresizingMaskIntoConstraints = false
                nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7).isActive = true
                nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
                nameLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
                nameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 100).isActive = true
                
                let valueLable:NSTextField = {
                    let LV = NSTextField()
                    LV.window?.title = "\(self.datas[i])"
                    LV.font = .systemFont(ofSize: 15, weight: .regular)
                    LV.alignment = .left
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
            
            barView.layer?.cornerRadius = 15
            barView.layer?.masksToBounds = false
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
                        let ani = NSAnimation.init(duration: 0.5, animationCurve: .easeOut)
                        ani.start()
                        let tmp = self.stackView.arrangedSubviews[i]
                        self.stackView.insertArrangedSubview(self.stackView.arrangedSubviews[j], at: i)
                        self.stackView.insertArrangedSubview(tmp, at: j)
                        ani.stop()
                        
                        
                        
                        
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
                let ani = NSAnimation.init(duration: 1, animationCurve: .easeOut)
                ani.start()
                self.stackView.arrangedSubviews[i].constraints[0].constant *= CGFloat(widthBias)
                let labelV = self.stackView.arrangedSubviews[i].subviews[1] as! NSTextField
                labelV.window?.title = "\(Float((labelV.window?.title)!)! * Float(widthBias))"
                self.stackView.displayIfNeeded()
            
                ani.stop()
            }
        }
    }
}

