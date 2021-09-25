//
//  MovieCollectionViewCell.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
struct MovieCollectionViewCellModel {
    let url : String?
    let name : String?
    let poster : String?
    let tag : String?
}
class MovieCollectionViewCell : UICollectionViewCell {
    var yOffset: CGFloat = UIMovieHomeConfig.shared.yOffsetItem
    var contentSize : CGSize = UIMovieHomeConfig.shared.cardsSize
    var ySpacing: CGFloat = CGFloat.greatestFiniteMagnitude
    var additionalHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    var additionalWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    var dropShadow: Bool = true
    var btnDotsAction : () -> () = {}
    var backViewAction : (UIView) -> () = {_ in }
    var frontViewAction : (UIView) -> () = {_ in }
    
    lazy var backContainerView: UIView = {
        let v = UIView(frame: .init(origin: .zero, size: contentSize))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        v.backgroundColor = .white
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backViewTap)))
        return v
    }()
    
    
    private lazy var dotImage : UIImageView = {
        let v = UIImageView(image: UIImage(named: "dots"))
        v.contentMode = .scaleToFill
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dotsTap(_:))))
        return v
    }()
    
    
    
    lazy var frontContainerView: UIView = {
        let v = UIView(frame: .init(origin: .zero, size: contentSize))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(frontViewTap)))
        return v
    }()
    
    
    var backConstraintY: NSLayoutConstraint?
    var frontConstraintY: NSLayoutConstraint?
    var titleConstraintBottom: NSLayoutConstraint?
    
    lazy var backgroundImageView: UIImageView = {
        let v = UIImageView(frame: .init(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    lazy var customTitle: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.lineBreakMode = .byTruncatingTail
        v.textColor = .white
        v.font = .systemFont(ofSize: 20)
        v.textAlignment = .center
        v.layer.shadowRadius = 2
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowOpacity = 0.2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var tagView : UILabel = {
        let v = UILabel()
        v.numberOfLines = 1
        v.textColor = .darkGray
        v.font = .systemFont(ofSize: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    var shadowView: UIView?
    var isOpened = false
    
    // MARK: inits
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    fileprivate func commonInit() {
        configurationViews()
        shadowView = createShadowViewOnView(frontContainerView)
    }
    
    @objc func dotsTap(_ sender : Any?){
        btnDotsAction()
    }
    @objc func backViewTap(_ sender : Any?){
        backViewAction(self.backContainerView)
    }
    @objc func frontViewTap(_ sender : Any?){
        frontViewAction(self.frontContainerView)
    }
}

extension MovieCollectionViewCell {
    
    /**
     Open or close cell.
     */
    public func cellIsOpen(_ isOpen: Bool, animated: Bool = true) {
        guard let frontConstraintY = frontConstraintY, let backConstraintY = backConstraintY else  {
            return
        }
        if isOpen == isOpened { return }
        
        if ySpacing == .greatestFiniteMagnitude {
            frontConstraintY.constant = isOpen == true ? -frontContainerView.bounds.size.height / 6 : 0
            backConstraintY.constant = isOpen == true ? frontContainerView.bounds.size.height / 6 - yOffset / 2 : 0
        } else {
            frontConstraintY.constant = isOpen == true ? -ySpacing / 2 : 0
            backConstraintY.constant = isOpen == true ? ySpacing / 2 : 0
        }
        
        if let widthConstant = backContainerView.getConstraint(.width) {
            if additionalWidth == .greatestFiniteMagnitude {
                widthConstant.constant = isOpen == true ? frontContainerView.bounds.size.width + yOffset : frontContainerView.bounds.size.width
            } else {
                widthConstant.constant = isOpen == true ? frontContainerView.bounds.size.width + additionalWidth : frontContainerView.bounds.size.width
            }
        }
        
        if let heightConstant = backContainerView.getConstraint(.height) {
            if additionalHeight == .greatestFiniteMagnitude {
                heightConstant.constant = isOpen == true ? frontContainerView.bounds.size.height + yOffset : frontContainerView.bounds.size.height
            } else {
                heightConstant.constant = isOpen == true ? frontContainerView.bounds.size.height + additionalHeight : frontContainerView.bounds.size.height
            }
        }
        //title
        
        self.customTitle.textColor = isOpen ? .darkGray.withAlphaComponent(0.7) : .white
        let titleFont : UIFont = isOpen ? .systemFont(ofSize: 11) : .systemFont(ofSize: 20)
        self.customTitle.font = titleFont
        titleConstraintBottom?.constant = isOpen ?  NSAttributedString(string: self.customTitle.text ?? "", attributes: [.font : titleFont]).size(considering: self.frontContainerView.bounds.size.width - 16).height + 15 : -15
        
        
        
        
        
        
        isOpened = isOpen
        
        if animated == true {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.contentView.layoutIfNeeded()
                
            }, completion: nil)
        } else {
            contentView.layoutIfNeeded()
        }
    }
}

// MARK: Configuration

extension MovieCollectionViewCell {
    
    fileprivate func configurationViews() {
        self.contentView.backgroundColor = .clear
        [backContainerView, frontContainerView, customTitle].forEach({
            self.contentView.addSubview($0)
        })
        
        [backgroundImageView].forEach({
            self.frontContainerView.addSubview($0)
        })
        
        [dotImage, tagView].forEach({
            self.backContainerView.addSubview($0)
        })
        
        constraints()
        
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }
    
    
    func constraints(){
        
        
        self.backConstraintY = self.backContainerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        self.frontConstraintY = self.frontContainerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        self.titleConstraintBottom = customTitle.bottomAnchor.constraint(equalTo: self.frontContainerView.bottomAnchor, constant: -15)
        
        
        
        NSLayoutConstraint.activate([
            backConstraintY!,
            backContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            backContainerView.widthAnchor.constraint(equalToConstant: contentSize.width),
            backContainerView.heightAnchor.constraint(equalToConstant: contentSize.height),
            
            frontConstraintY!,
            frontContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            frontContainerView.widthAnchor.constraint(equalToConstant: contentSize.width),
            frontContainerView.heightAnchor.constraint(equalToConstant: contentSize.height),
            
            
            titleConstraintBottom!,
            customTitle.centerXAnchor.constraint(equalTo: self.frontContainerView.centerXAnchor, constant: 0),
            customTitle.widthAnchor.constraint(equalToConstant: self.frontContainerView.bounds.size.width - 16),
            
            
            
        ])
        
        guard let backgroundImageViewSuperView = self.backgroundImageView.superview, let dotImageSuperView = self.dotImage.superview else {
            return
        }
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: backgroundImageViewSuperView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: backgroundImageViewSuperView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: backgroundImageViewSuperView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: backgroundImageViewSuperView.bottomAnchor),
            
            
            
            dotImage.bottomAnchor.constraint(equalTo: dotImageSuperView.bottomAnchor, constant: -15),
            dotImage.trailingAnchor.constraint(equalTo: dotImageSuperView.trailingAnchor, constant: -20),
            dotImage.heightAnchor.constraint(equalToConstant: 19),
            dotImage.widthAnchor.constraint(equalToConstant: 4),
            
            tagView.bottomAnchor.constraint(equalTo: backContainerView.bottomAnchor, constant: -15),
            tagView.leadingAnchor.constraint(equalTo: self.backContainerView.leadingAnchor, constant: 20),
            
            
        ])
    }
    
    
    
    fileprivate func createShadowViewOnView(_ view: UIView?) -> UIView? {
        guard let view = view else { return nil }
        
        let shadow = UIView(frame: .zero)
        shadow.backgroundColor = UIColor(white: 0, alpha: 0)
        shadow.translatesAutoresizingMaskIntoConstraints = false
        shadow.layer.masksToBounds = false
        if dropShadow {
            shadow.layer.shadowColor = UIColor.black.cgColor
            shadow.layer.shadowRadius = 10
            shadow.layer.shadowOpacity = 0.3
            shadow.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        
        contentView.insertSubview(shadow, belowSubview: view)
        
        if let frontViewConstraintWidth = view.getConstraint(.width), let frontViewConstraintHeight = view.getConstraint(.height) {
            NSLayoutConstraint.activate([
                shadow.widthAnchor.constraint(equalToConstant: frontViewConstraintWidth.constant * 0.8),
                shadow.heightAnchor.constraint(equalToConstant: frontViewConstraintHeight.constant * 0.9),
                
                shadow.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
                //                shadow.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor, constant: 30),
                shadow.bottomAnchor.constraint(equalTo: self.frontContainerView.bottomAnchor, constant: 10)
            ])
        }
        
        // size shadow
        let width = shadow.getConstraint(.width)?.constant
        let height = shadow.getConstraint(.height)?.constant
        
        shadow.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width!, height: height!), cornerRadius: 0).cgPath
        
        return shadow
    }
    
    func configureCellViewConstraintsWithSize(_ size: CGSize) {
        guard isOpened == false && frontContainerView.getConstraint(.width)?.constant != size.width else { return }
        
        [frontContainerView, backContainerView].forEach {
            let constraintWidth = $0.getConstraint(.width)
            constraintWidth?.constant = size.width
            
            let constraintHeight = $0.getConstraint(.height)
            constraintHeight?.constant = size.height
            $0.frame = .init(origin: .zero, size: size)
        }
        self.contentSize = size
        
    }
}

// MARK: NSCoding

extension MovieCollectionViewCell {
    func copyCell(view : UIView) -> MovieCollectionViewCell? {
        let rect = self.convert(self.bounds, to: view)
        let v = MovieCollectionViewCell(frame: rect)
        v.backgroundImageView.image = self.backgroundImageView.image
        v.customTitle.text = self.customTitle.text
        v.cellIsOpen(self.isOpened, animated: false)
        return v
    }
}
