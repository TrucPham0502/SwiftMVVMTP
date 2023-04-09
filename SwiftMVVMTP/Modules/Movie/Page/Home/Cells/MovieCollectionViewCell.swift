//
//  MovieCollectionViewCell.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import UIKit
struct MovieCollectionViewCellModel {
    let url : String
    var posterImage: UIImage?
    let name : String
    let poster : String
    let tag : String
    let episode: String
    var isBookmark : Bool
}
class MovieCollectionViewCell : UICollectionViewCell {
    let titleFont : UIFont = .boldSystemFont(ofSize: 18)
    var yOffset: CGFloat = UIMovieHomeConfig.shared.yOffsetItem
    var contentSize : CGSize = UIMovieHomeConfig.shared.cardsSize
    var ySpacing: CGFloat = CGFloat.greatestFiniteMagnitude
    var additionalHeight: CGFloat = CGFloat.greatestFiniteMagnitude
    var additionalWidth: CGFloat = CGFloat.greatestFiniteMagnitude
    var dropShadow: Bool = true
    var btnDotsAction : () -> () = {}
    var backViewAction : (UIView) -> () = {_ in }
    var frontViewAction : (UIView) -> () = {_ in }
    var bookmarkAction : (Bool) -> () = {_ in }
    var isBookmarks : Bool = false {
        didSet {
            self.bookmarksView.setImage(isBookmarks ? .init(named: "christmas-star-fill") : .init(named: "christmas-star-stroke"), for: .normal)
        }
    }
    var model : MovieCollectionViewCellModel? {
        didSet {
            guard let model = model else {
                return
            }
            self.customTitle.text = model.name
            self.tagView.text = "\(model.episode) \(!model.tag.isEmpty ? "(\(model.tag))" : "" )"
            self.isBookmarks = model.isBookmark
            updateConstraintTitle()
        }
    }
    
    var backConstraint = AppConstants()
    var frontConstraint = AppConstants()
    private var titleConstraint = AppConstants()
    
    lazy var backContainerView: UIView = {
        let v = UIView(frame: .init(origin: .zero, size: contentSize))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        v.backgroundColor = .white
        return v
    }()
    
    
    private lazy var dotImage : UIImageView = {
        let v = UIImageView(image: UIImage(named: "dots"))
        v.contentMode = .center
        v.isUserInteractionEnabled = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var frontContainerView: UIView = {
        let v = UIView(frame: .init(origin: .zero, size: contentSize))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        v.layer.cornerRadius = 5
        return v
    }()
    
    let gradientLayer = CAGradientLayer()
    lazy var backgroundImageView: UIImageView = {
        let v = UIImageView(frame: .init(x: 0, y: 0, width: contentSize.width, height: contentSize.height))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.addSublayer(gradientLayer)
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    lazy var customTitle: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.lineBreakMode = .byTruncatingTail
        v.textColor = .white
        v.font = titleFont
        v.textAlignment = .center
        v.setShadow()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var tagView : UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.textColor = .darkGray
        v.font = .systemFont(ofSize: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var bookmarksView : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "christmas-star-stroke"), for: .normal)
        v.contentEdgeInsets = .zero
        v.contentEdgeInsets = .zero
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
        prepareUI()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    fileprivate func prepareUI() {
        configurationViews()
        shadowView = createShadowViewOnView(frontContainerView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame.size = self.backgroundImageView.frame.size
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor]
        
    }
    
    fileprivate func updateConstraintTitle(){
        if let centerY = self.titleConstraint.centerY, let model = model, let heightFront = self.frontConstraint.height {
            let textSize = NSAttributedString(string: model.name, attributes: [.font : self.titleFont]).size(considering: self.frontContainerView.frame.size.width - 32)
            let defaultPadding : CGFloat = 100
            centerY.constant = isOpened ? (heightFront.constant + textSize.height ) / 2 + 15 : defaultPadding
        }
    }
    private func configurationViews() {
        self.contentView.backgroundColor = .clear
        self.contentView.isUserInteractionEnabled = false
        [backContainerView, frontContainerView, customTitle].forEach(self.contentView.addSubview)
        
        [backgroundImageView].forEach(self.frontContainerView.addSubview)
        
        [dotImage, tagView, bookmarksView].forEach(self.backContainerView.addSubview)
        
        constraints()
        
        contentView.layer.masksToBounds = false
        layer.masksToBounds = false
    }
    
    
    func constraints(){
        backConstraint = .init(width: backContainerView.widthAnchor.constraint(equalToConstant: contentSize.width), height: backContainerView.heightAnchor.constraint(equalToConstant: contentSize.height), centerX:  backContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor), centerY: self.backContainerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        
        frontConstraint = .init(width: frontContainerView.widthAnchor.constraint(equalToConstant: contentSize.width), height: frontContainerView.heightAnchor.constraint(equalToConstant: contentSize.height), centerX: frontContainerView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor), centerY: self.frontContainerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor))
        
        titleConstraint = .init(width: customTitle.widthAnchor.constraint(equalToConstant: self.frontContainerView.bounds.size.width - 16), centerX: customTitle.centerXAnchor.constraint(equalTo: self.frontContainerView.centerXAnchor, constant: 0), centerY: self.customTitle.centerYAnchor.constraint(equalTo: self.frontContainerView.centerYAnchor))
        
        [backConstraint,frontConstraint,titleConstraint].forEach{$0.active()}
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: self.frontContainerView.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: self.frontContainerView.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: self.frontContainerView.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: self.frontContainerView.bottomAnchor),
            
            
            
            dotImage.bottomAnchor.constraint(equalTo: self.backContainerView.bottomAnchor, constant: -15),
            dotImage.trailingAnchor.constraint(equalTo: self.backContainerView.trailingAnchor, constant: -20),
            dotImage.heightAnchor.constraint(equalToConstant: 20),
            dotImage.widthAnchor.constraint(equalToConstant: 20),
            
            tagView.bottomAnchor.constraint(equalTo: backContainerView.bottomAnchor, constant: -15),
            tagView.leadingAnchor.constraint(equalTo: self.backContainerView.leadingAnchor, constant: 20),
            
            bookmarksView.trailingAnchor.constraint(equalTo: self.dotImage.leadingAnchor, constant: -10),
            bookmarksView.topAnchor.constraint(equalTo: self.dotImage.topAnchor),
            bookmarksView.heightAnchor.constraint(equalTo: self.dotImage.heightAnchor),
            bookmarksView.widthAnchor.constraint(equalTo: bookmarksView.heightAnchor)
            
            
        ])
    }
    
    
    
    private func createShadowViewOnView(_ view: UIView?) -> UIView? {
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
    
    func handleTouch(_ point : CGPoint){
        if self.frontContainerView.frame.contains(point){
            frontViewAction(self.frontContainerView)
        }
        else if self.backContainerView.frame.contains(point) {
            if self.backContainerView.convert(dotImage.frame, to: self.contentView).contains(point) {  btnDotsAction() }
            else if self.backContainerView.convert(bookmarksView.frame, to: self.contentView).contains(point) {
                self.isBookmarks = !isBookmarks
                self.bookmarkAction(self.isBookmarks)
            }
            else { backViewAction(self.backContainerView) }
        }
    }
}

extension MovieCollectionViewCell {
    func cellIsOpen(_ isOpen: Bool, animated: Bool = true) {
        guard let frontConstraintY = frontConstraint.centerY, let backConstraintY = backConstraint.centerY else  {
            return
        }
        if isOpen == isOpened { return }
        
        if ySpacing == .greatestFiniteMagnitude {
            frontConstraintY.constant = isOpen ? -frontContainerView.bounds.size.height / 6 : 0
            backConstraintY.constant = isOpen ? frontContainerView.bounds.size.height / 6 - yOffset / 2 : 0
        } else {
            frontConstraintY.constant = isOpen ? -ySpacing / 2 : 0
            backConstraintY.constant = isOpen ? ySpacing / 2 : 0
        }
        
        if let widthConstant = backContainerView.getConstraint(.width) {
            if additionalWidth == .greatestFiniteMagnitude {
                widthConstant.constant = isOpen ? frontContainerView.bounds.size.width + yOffset : frontContainerView.bounds.size.width
            } else {
                widthConstant.constant = isOpen ? frontContainerView.bounds.size.width + additionalWidth : frontContainerView.bounds.size.width
            }
        }
        
        if let heightConstant = backContainerView.getConstraint(.height) {
            if additionalHeight == .greatestFiniteMagnitude {
                heightConstant.constant = isOpen ? frontContainerView.bounds.size.height + yOffset : frontContainerView.bounds.size.height
            } else {
                heightConstant.constant = isOpen ? frontContainerView.bounds.size.height + additionalHeight : frontContainerView.bounds.size.height
            }
        }
        isOpened = isOpen
        updateConstraintTitle()
        if animated == true {
            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.customTitle.textColor = isOpen ? .black.withAlphaComponent(0.7) : .white
                self.customTitle.transform = !isOpen ? .init(scaleX: 1, y: 1) : .init(scaleX: 0.8, y: 0.8)
                self.contentView.layoutIfNeeded()
            }, completion: nil)
        } else {
            self.customTitle.textColor = isOpen ? .black.withAlphaComponent(0.7) : .white
            self.customTitle.transform = !isOpen ? .init(scaleX: 1, y: 1) : .init(scaleX: 0.8, y: 0.8)
            contentView.layoutIfNeeded()
        }
    }
}



// MARK: NSCoding

extension MovieCollectionViewCell {
    func copyCell(view : UIView) -> MovieCollectionViewCell? {
        let rect = self.convert(self.bounds, to: view)
        let v = MovieCollectionViewCell(frame: rect)
        v.backgroundImageView.image = self.backgroundImageView.image
        v.cellIsOpen(self.isOpened, animated: false)
        return v
    }
}
