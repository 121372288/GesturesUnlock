//
//  ViewController.swift
//  GesturesUnlock
//
//  Created by 马磊 on 2016/11/2.
//  Copyright © 2016年 MLCode.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        
        let lockView: LockView = LockView(frame: CGRect(x: 0, y: 80, width: view.frame.size.width, height: view.frame.size.width))
        lockView.delegate = self
        
        view.addSubview(lockView)
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

extension ViewController: LockViewDelegate {
    
    func lockViewDidFinishSelect(_ lockView: LockView, password: String) {
        print(password)
        let alert: UIAlertController = UIAlertController(title: "结果", message: "\(password)", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(1), execute: {
            
            alert.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
}
