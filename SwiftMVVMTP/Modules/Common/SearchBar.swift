//
//  SearchBar.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 06/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class SearchBar : UITextField {
    var iconSize : CGSize = .init(width: 30, height: 30)
    var handleFocus: (Bool) -> () = {_ in}
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    var defaultBackgroundColor : UIColor? {
        didSet {
            self.backgroundColor = self.defaultBackgroundColor
        }
    }
    
    var focusBackgroundColor : UIColor?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
    
    private lazy var right : UIButton = {
        let v = UIButton(frame: .init(origin: .zero, size: iconSize))
        v.setImage(.init(named: "ic-close-white"), for: .normal)
        v.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 10)
        v.addTarget(self, action: #selector(rightViewTap), for: .touchUpInside)
        return v
    }()
    private lazy var left : UIButton = {
        let v = UIButton(frame: .init(origin: .zero, size: iconSize))
        v.setImage(.init(named: "ic-search-white"), for: .normal)
        v.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 5)
        v.addTarget(self, action: #selector(leftViewTap), for: .touchUpInside)
        return v
    }()
    
    
    private func prepareUI(){
        self.delegate = self
        self.rightViewMode = .whileEditing
        self.rightView = self.right
        self.leftViewMode = .always
        self.leftView = self.left
    }
    
    @objc func rightViewTap(){
        self.text = ""
    }
    @objc func leftViewTap(){
        self.becomeFirstResponder()
    }
    
    override var intrinsicContentSize: CGSize {
        if !self.isEditing && (text == nil || text!.isEmpty) {
            return iconSize
        }
        return .init(width: superview?.frame.size.width ?? iconSize.width, height: 40)
    }
    
    
}
extension SearchBar : UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.invalidateIntrinsicContentSize()
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 5
            self.backgroundColor = self.focusBackgroundColor ?? self.defaultBackgroundColor
            self.superview?.layoutIfNeeded()
            self.handleFocus(true)
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.invalidateIntrinsicContentSize()
        if let txt = self.text, !txt.isEmpty { return }
        UIView.animate(withDuration: 0.3) {
            self.layer.borderColor = UIColor.clear.cgColor
            self.layer.borderWidth = 0
            self.layer.cornerRadius = 0
            self.backgroundColor = self.defaultBackgroundColor
            self.superview?.layoutIfNeeded()
            self.handleFocus(false)
        }
    }
}
