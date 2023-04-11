//
//  LoginViewController.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 10/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class LoginViewController : BaseViewController<LoginViewModel> {
    override func buildViewModel() -> LoginViewModel {
        return LoginViewModel()
    }
    
    let circleBottomSize : CGFloat = (UIScreen.main.bounds.width + 100)
    private lazy var circleBottomView : CircleInnerShadowView = {
        let v = CircleInnerShadowView()
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.layer.cornerRadius = circleBottomSize/2
        v.darkShadowOffset = .init(width: 5, height: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let circleTopSize : CGFloat = (UIScreen.main.bounds.width - 30)
    private lazy var circleTopView : CircleInnerShadowView = {
        let v = CircleInnerShadowView()
        v.layer.cornerRadius = circleTopSize/2
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.darkShadowOffset = .init(width: 10, height: 5)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var containerView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var titleView : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Welcome Back!"
        v.font = .boldSystemFont(ofSize: 30)
        v.textAlignment = .center
        v.textColor = .black
        v.numberOfLines = 1
        return v
    }()
    
    private lazy var subtitleView : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "To keep connected with us please login with your personal info"
        v.setLineHeight(24)
        v.font = .systemFont(ofSize: 17)
        v.textColor = .lightGray
        v.numberOfLines = -1
        v.textAlignment = .center
        return v
    }()
    
    private lazy var userNameTxt : NeumorphicTextField = {
        let v = NeumorphicTextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .lightGray
        v.layer.cornerRadius = 10
        v.font = UIFont.systemFont(ofSize: 15)
        v.attributedPlaceholder = NSAttributedString(string: "Email, Phone, Username", attributes: [
            .foregroundColor : UIColor.lightGray,
        ])
        return v
    }()
    
    private lazy var passwordTxt : NeumorphicTextField = {
        let v = NeumorphicTextField()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .lightGray
        v.layer.cornerRadius = 10
        v.font = UIFont.systemFont(ofSize: 15)
        v.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor : UIColor.lightGray
        ])
        v.isSecureTextEntry = true
        return v
    }()
    
    
    private lazy var signInButton : LayeredButton = {
        let v = LayeredButton()
        v.setShadow()
        v.contentEdgeInsets = .init(top: 15, left: 60, bottom: 15, right: 60)
        v.layer.cornerRadius = 25
        v.setTitle("SIGN IN", for: .normal)
        v.titleLabel?.font = .boldSystemFont(ofSize: 20)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = true
        self.view.backgroundColor = .Neumorphic.mainColor
        [self.circleBottomView, self.circleTopView, self.containerView].forEach( self.view.addSubview)
        [self.titleView, self.subtitleView, self.userNameTxt, self.passwordTxt, self.signInButton].forEach(self.containerView.addSubview(_:))
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 24),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -24),
            self.containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.circleBottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: -circleBottomSize/2),
            self.circleBottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: circleBottomSize/2 + 100),
            self.circleBottomView.heightAnchor.constraint(equalTo: self.circleBottomView.widthAnchor),
            self.circleBottomView.widthAnchor.constraint(equalToConstant: circleBottomSize),
            
            self.circleTopView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: circleTopSize/2),
            self.circleTopView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: -circleTopSize/2 - 30),
            self.circleTopView.heightAnchor.constraint(equalTo: self.circleTopView.widthAnchor),
            self.circleTopView.widthAnchor.constraint(equalToConstant: circleTopSize),
            
            self.titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            self.titleView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.titleView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            
            self.subtitleView.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 40),
            self.subtitleView.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor),
            self.subtitleView.trailingAnchor.constraint(equalTo: self.titleView.trailingAnchor),
            
            self.userNameTxt.topAnchor.constraint(equalTo: self.subtitleView.bottomAnchor, constant: 40),
            self.userNameTxt.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.userNameTxt.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.userNameTxt.heightAnchor.constraint(equalToConstant: 60),
            
            self.passwordTxt.topAnchor.constraint(equalTo: self.userNameTxt.bottomAnchor, constant: 10),
            self.passwordTxt.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            self.passwordTxt.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            self.passwordTxt.heightAnchor.constraint(equalToConstant: 60),
            
            self.signInButton.topAnchor.constraint(equalTo: self.passwordTxt.bottomAnchor, constant: 40),
            self.signInButton.centerXAnchor.constraint(equalTo: self.containerView.centerXAnchor),
            self.signInButton.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor)
        ])
        
    }
    
    override func performBinding() {
        super.performBinding()
        let input = LoginViewModel.Input(
            viewWillAppear: self.rx.viewWillAppear.mapToVoid(),
            signIn: self.signInButton.rx.tap.asDriverOnErrorJustComplete().map{ [weak self] _ -> (String, String) in
                    guard let self = self else { return ("", "")}
                    return (self.userNameTxt.text ?? "", self.passwordTxt.text ?? "")
            }.do(onNext: {[weak self] _ in
                guard let self = self else { return }
                self.userNameTxt.text = ""
                self.passwordTxt.text = ""
            })
        )
        let output = viewModel.transform(input: input)
        output.result.drive(onNext: {[weak self] res in
            guard let _self = self else { return }
            switch res {
            case .login:
                _self.dismiss(animated: true)
            default: break
            }
        }).disposed(by: self.disposeBag)
    }
    
}


