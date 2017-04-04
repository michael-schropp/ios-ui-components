//
//  ViewController.swift
//  ios-ui-components
//
//  Created by michael.schropp on 04/04/2017.
//  Copyright © 2017 Michael Schropp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let fanControl = FanControl.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
        
//                fanControl.setupWithTitles(["add", "fav", "delete"])
        fanControl.setupWithImages([
            #imageLiteral(resourceName: "clip"),
            #imageLiteral(resourceName: "empty"),
            #imageLiteral(resourceName: "cloud")
            ])
        
        fanControl.center = view.center
        fanControl.layer.cornerRadius = fanControl.frame.height / 2
        fanControl.backgroundColor = UIColor.lightGray
        fanControl.tintColor = UIColor.red.withAlphaComponent(0.95)
        fanControl.addTarget(self, action: #selector(ViewController.fanControlDidChoose(_:)), for: .valueChanged)
        view.addSubview(fanControl)
    }
    
    func fanControlDidChoose(_ fanControl:FanControl) {
        dump(fanControl.selectedIndex)
    }
}

