//
//  ViewController.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/26/1400 AP.
//

import UIKit

class Name {
    
    var name:String
    init(name:String) {
        self.name = name
    }
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = ServiceLocator.shared.register(name: .Name, factory: {
            Name(name: "0")
        }).scope(.application)
        
        let v = Date()
        let x:Name? = ServiceLocator.shared.resolve(name: .Name)
        print(x?.name)
        let b = Date()
        print(b.timeIntervalSince(v))
        // Do any additional setup after loading the view.
    }


}

