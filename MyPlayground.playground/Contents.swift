
import UIKit



class VC:UIViewController{
    var v = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        v.layer.frame.size = .init(width: 100, height: 100)
    }
}


UIView.animate(withDuration: 0.5){
    
}
