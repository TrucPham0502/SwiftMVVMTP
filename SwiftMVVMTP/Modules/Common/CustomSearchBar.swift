//
//  AnimatedBorderTextField.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 02/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
class CustomSearchBar: UISearchBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        hideClearButton()
    }
    private func hideClearButton() {
        self.textField?.rightView = nil
        self.textField?.rightViewMode = .never
    }
}
