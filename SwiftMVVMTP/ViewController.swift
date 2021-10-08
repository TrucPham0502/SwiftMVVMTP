//
//  ViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var button : UIButton = {
        let v = UIButton()
        v.setTitle("Start", for: .normal)
        v.setTitleColor(.white, for: .normal)
        v.backgroundColor = .red
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
        return v
    }()
    
    @objc func buttonTap(_ sender : Any?){
        self.view.window?.rootViewController = UINavigationController(rootViewController: MovieHomeViewController())
//        let vc = TestPageViewController()
//        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(button)
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }


}

