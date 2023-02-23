//
//  EpisodeCollectionView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
class EpisodeCollectionViewCell: UICollectionViewCell {
    lazy var titleView : UILabel = {
        let v = UILabel()
        v.textColor = .red
        v.textAlignment = .center
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareUI() {
        self.addSubview(titleView)
        self.backgroundColor = .white
        self.layer.cornerRadius = 11
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.red.cgColor
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func setIsNew(isNew : Bool) {
        if isNew {
            self.layer.borderColor = UIColor.white.cgColor
            self.backgroundColor = .red
            self.titleView.textColor = .white
        }
        else {
            self.layer.borderColor = UIColor.red.cgColor
            self.backgroundColor = .white
            self.titleView.textColor = .red
        }
        
        
    }
    
    var data : EpisodeModel? {
        didSet{
            guard let vm = data, let ep = vm.episode else {
                self.isUserInteractionEnabled = false
                return
            }
            self.isUserInteractionEnabled = true
            self.titleView.text = "\(ep)"
            setIsNew(isNew: vm.isNew ?? false)
        }
    }
}


