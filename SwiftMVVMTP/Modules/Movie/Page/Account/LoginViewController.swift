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
    
    private lazy var backgroundCircle : BackgroundCircleNeumorphic = {
        let v = BackgroundCircleNeumorphic()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var backButton : ButtonNeumorphic = {
        let v = ButtonNeumorphic()
        v.layer.cornerRadius = 20
        v.setImage(.init(named: "ic-back"), for: .normal)
        v.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(backTap), for: .touchUpInside)
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
        v.font = .bold(ofSize: 30)
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
        v.font = .regular(ofSize: 17)
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
        v.font = UIFont.regular(ofSize: 15)
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
        v.font = UIFont.regular(ofSize: 15)
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
        v.titleLabel?.font = .bold(ofSize: 20)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.clipsToBounds = true
        self.view.layer.masksToBounds = true
        self.view.backgroundColor = .Neumorphic.mainColor
        [self.backgroundCircle].forEach( self.view.addSubview)
        [self.containerView, backButton].forEach(self.backgroundCircle.addSubview(_:))
        [self.titleView, self.subtitleView, self.userNameTxt, self.passwordTxt, self.signInButton].forEach(self.containerView.addSubview(_:))
        NSLayoutConstraint.activate([
            backgroundCircle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundCircle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundCircle.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundCircle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
            self.containerView.leadingAnchor.constraint(equalTo: self.backgroundCircle.leadingAnchor, constant: 24),
            self.containerView.trailingAnchor.constraint(equalTo: self.backgroundCircle.trailingAnchor, constant: -24),
            self.containerView.centerYAnchor.constraint(equalTo: self.backgroundCircle.centerYAnchor),
            
            
        
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
            self.signInButton.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),
            
            backButton.leadingAnchor.constraint(equalTo: self.backgroundCircle.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: self.backgroundCircle.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40)
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
        output.result.drive(onNext: {[weak self] () in
            guard let _self = self else { return }
            _self.dismiss(animated: true)
        }).disposed(by: self.disposeBag)
    }
    
    @objc func backTap(){
        naviagtionBack()
    }
}


