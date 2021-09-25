//
//  TestCell.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import UIKit

class TestCell : UITableViewCell {
    lazy var content : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .black
        return v
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareUI(){
        self.addSubview(content)
        NSLayoutConstraint.activate([
            self.content.topAnchor.constraint(equalTo: self.topAnchor),
            self.content.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.content.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.content.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    var viewModel : TestCellModel? {
        didSet {
            guard let vm = viewModel else {
                return
            }
            self.content.text = vm.content
        }
    }
}

struct TestCellModel {
    let content : String?
}
