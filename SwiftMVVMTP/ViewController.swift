//
//  ViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var button : ButtonNeumorphic = {
        let v = ButtonNeumorphic()
        v.layer.cornerRadius = 10
        v.setTitle("start", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    @objc func buttonTap(_ sender : Any?){
        self.view.window?.rootViewController = UINavigationController(rootViewController: MovieHomeViewController())
        self.view.endEditing(true)
//        let vc = TestPageViewController()
//        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = NeumorphicTextField(frame: .init(origin: .init(x: 30, y: 200), size: .init(width: self.view.bounds.width - 60, height: 50)))
        textField.layer.cornerRadius = 10
        textField.placeholder = "text...."
        textField.attributedPlaceholder = NSAttributedString(string: "text...", attributes: [.foregroundColor : UIColor.black.withAlphaComponent(0.7)])
        self.view.addSubview(button)
        self.view.addSubview(textField)
        
        self.view.backgroundColor = .Neumorphic.mainColor
        NSLayoutConstraint.activate([
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.button.widthAnchor.constraint(equalToConstant: 100)
        ])
    }


}

