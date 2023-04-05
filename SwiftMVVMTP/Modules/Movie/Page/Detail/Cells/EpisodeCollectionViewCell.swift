//
//  EpisodeCollectionView.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
class EpisodeCollectionViewCell: UICollectionViewCell {
    var didSelected : (EpisodeModel) -> () = {_ in }
    lazy var titleView : UILabel = {
        let v = UILabel()
        v.textColor = .white
        v.font = .systemFont(ofSize: 14)
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
        self.backgroundColor = UIColor(named:"primary-color")
        self.layer.cornerRadius = 11
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: self.topAnchor),
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTap)))
    }
    @objc func cellTap(){
        guard let data = data else { return }
        didSelected(data)
    }
    
    var data : EpisodeModel? {
        didSet{
            guard let vm = data, !vm.episode.isEmpty  else {
                self.isUserInteractionEnabled = false
                return
            }
            self.isUserInteractionEnabled = true
            self.titleView.text = "\(vm.episode)"
        }
    }
}


