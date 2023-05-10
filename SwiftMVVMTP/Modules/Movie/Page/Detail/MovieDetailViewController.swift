//
//  MovieDetailViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import UIKit
import WidgetKit



class MovieDetailViewController : BaseViewController<MovieDetailViewModel> {
    override func buildViewModel() -> MovieDetailViewModel {
        let vm = MovieDetailViewModel()
        vm.viewLogic = self
        return vm
    }
    struct DetailViewModel {
        let poster : String?
        let urlPage : String?
    }
    
    var dataRequire : DetailViewModel? 
    var placeHolderImage : UIImage? {
        didSet {
            self.backgroundImage.image = placeHolderImage
            guard let placeHolderImage = placeHolderImage else { return }
            self.backgroundImage.frame = .init(origin: .zero, size: .init(width: self.view.bounds.width, height: self.view.bounds.width *  placeHolderImage.size.height / placeHolderImage.size.width))
        }
    }
    let gradientColors = [UIColor.clear.cgColor,
                          UIColor.black.withAlphaComponent(0.4).cgColor,
                          UIColor.black.cgColor,
                          UIColor.black.cgColor,
                          UIColor.black.cgColor]
    var headerHeight: CGFloat = UIScreen.main.bounds.height / 2 - 100
    private let buttonWacthHeight : CGFloat = 50
    private var lastContentOffset: CGFloat = 0
    var padding : CGFloat = 20
    var transitionDriver: TransitionDriver?
    var collectionViewConstraint: AppConstants = .init()
    var closeButtonConstraint: AppConstants = .init()
    var bookmarksButtonConstraint: AppConstants = .init()
    var data : [EpisodeModel] = [] {
        didSet {
            self.collectionViewEpisode.layoutIfNeeded()
            self.collectionViewEpisode.reloadData()
        }
    }
    var isBookmarks : Bool = false {
        didSet {
            self.bookmarksView.setImage(isBookmarks ? .init(named: "christmas-star-fill") : .init(named: "christmas-star-stroke"), for: .normal)
        }
    }
    
    
    private lazy var gradientView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.bounds.size
        gradientLayer.colors = gradientColors
        v.layer.addSublayer(gradientLayer)
        return v
    }()
    
    private lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        v.delegate = self
        v.contentInset = .zero
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var headerButtonWatchView : LayeredButton = {
        let v = LayeredButton()
        v.setImage(.init(named: "ic-play-white"), for: .normal)
        v.insets = .init(width: 2, height: 2)
        v.layer.cornerRadius = 40 / 2
        v.contentEdgeInsets = .init(top: 5, left: 5, bottom: 5, right: 5)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(watchTap), for: .touchUpInside)
        return v
    }()
    private lazy var headerTitleView : UILabel = {
        let v = UILabel()
        v.font = .bold(ofSize: 20)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .white
        v.numberOfLines = 0
        v.textAlignment = .left
        return v
    }()
    private lazy var headerSubtitleView : UILabel = {
        let v = UILabel()
        v.font = .regular(ofSize: 16)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .white
        v.numberOfLines = 1
        v.textAlignment = .left
        return v
    }()
    
    private lazy var headerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.addSubview(blurEffectView)
        v.clipsToBounds = true
        [headerTitleView, headerSubtitleView, headerButtonWatchView].forEach(v.addSubview)
        NSLayoutConstraint.activate([
            headerSubtitleView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: padding),
            headerSubtitleView.trailingAnchor.constraint(lessThanOrEqualTo: headerButtonWatchView.leadingAnchor, constant: -20),
            headerSubtitleView.bottomAnchor.constraint(lessThanOrEqualTo: v.bottomAnchor, constant: -20),
            
            headerTitleView.bottomAnchor.constraint(equalTo: headerSubtitleView.topAnchor, constant: -10),
            headerTitleView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: padding),
            headerTitleView.trailingAnchor.constraint(lessThanOrEqualTo: headerButtonWatchView.leadingAnchor, constant: -20),
            headerTitleView.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            headerButtonWatchView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -padding),
            headerButtonWatchView.heightAnchor.constraint(equalToConstant: 40),
            headerButtonWatchView.widthAnchor.constraint(equalTo: headerButtonWatchView.heightAnchor),
            headerButtonWatchView.centerYAnchor.constraint(equalTo: v.safeAreaLayoutGuide.centerYAnchor)
            
        ])
        
        return v
    }()
    
    
    private lazy var containerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var backgroundImage : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.backgroundColor = .black
        v.clipsToBounds = true
        return v
    }()
    
    lazy var closeImage : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "ic-back-white"), for: .normal)
        v.contentEdgeInsets = .zero
        v.layer.cornerRadius = 20
        v.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        v.layer.borderColor = UIColor.white.cgColor
        v.layer.borderWidth = 1
        v.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        return v
    }()
    
    lazy var titleView : UILabel = {
        let v = UILabel()
        v.font = .bold(ofSize: 30)
        v.textAlignment = .left
        v.numberOfLines = 0
        v.text = ""
        v.textColor = .white
        v.layer.shadowRadius = 2
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowOpacity = 0.2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private lazy var seasonlb : LayeredButton = {
        let v = LayeredButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("VIETSUB", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 3
        v.titleLabel?.font = .regular(ofSize: 12)
        v.insets = .init(width: 1, height: 1)
        v.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        return v
    }()
    
    lazy var bookmarksView : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "christmas-star-stroke"), for: .normal)
        v.contentEdgeInsets = .zero
        v.contentEdgeInsets = .zero
        v.isUserInteractionEnabled = false
        return v
    }()
    
    private lazy var timelb : UILabel =  {
        let v = UILabel()
        v.font = .bold(ofSize: 14)
        v.textColor = .white
        v.numberOfLines = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var categoryslb : UILabel =  {
        let v = UILabel()
        v.font = .regular(ofSize: 14)
        v.textColor = .white
        v.numberOfLines = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private lazy var buttonWatch : LayeredButton = {
        let v = LayeredButton()
        v.setImage(.init(named: "ic-play-white"), for: .normal)
        v.insets = .init(width: 2, height: 2)
        v.layer.cornerRadius = buttonWacthHeight / 2
        v.contentEdgeInsets = .init(top: 3, left: 3, bottom: 3, right: 3)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(watchTap), for: .touchUpInside)
        return v
    }()
    
    private lazy var titleContent : UILabel = {
        let v = UILabel()
        v.font = .bold(ofSize: 17)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Description:"
        v.textColor = .white
        return v
    }()
    
    lazy var contentView : ExpandableLabel = {
        let v = ExpandableLabel()
        v.text = "No content"
        v.textColor = .lightGray
        v.font = .regular(ofSize: 14)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        return v
    }()
    
    
    private lazy var titleEpisodes : UILabel = {
        let v = UILabel()
        v.font = .bold(ofSize: 17)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Episodes:"
        v.textColor = .white
        return v
    }()
    
    private lazy var collectionViewEpisode : DynamicCollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 8
        flow.minimumInteritemSpacing = 3
        let v = DynamicCollectionView(frame: .zero, collectionViewLayout: flow)
        v.isScrollEnabled = false
        v.dataSource = self
        v.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionView")
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .clear
        v.showsHorizontalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.alpha = 0
        self.view.backgroundColor = .clear
        // Do any additional setup after loading the view.
    }
    
    
    @objc private func watchTap(){
        if let first = self.data.first {
            self.playVideo(type: .url(url: first.url))
        }
    }
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.isHidden = true
        [backgroundImage, gradientView, scrollView, headerView, closeImage, bookmarksView].forEach(self.view.addSubview)
        self.scrollView.addSubview(containerView)
        [titleView, seasonlb, timelb,categoryslb, buttonWatch, titleContent, contentView, titleEpisodes, collectionViewEpisode].forEach(self.containerView.addSubview)
        titleView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        NSLayoutConstraint.activate([
            
            self.gradientView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.headerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
        
            
            
            titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: headerHeight),
            titleView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.buttonWatch.leadingAnchor, constant: -20),
            
            buttonWatch.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor, constant: 0),
            buttonWatch.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            buttonWatch.widthAnchor.constraint(equalTo: buttonWatch.heightAnchor),
            buttonWatch.heightAnchor.constraint(equalToConstant: buttonWacthHeight),
            

            
            
            categoryslb.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 5),
            categoryslb.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor, constant: 5),
            categoryslb.trailingAnchor.constraint(lessThanOrEqualTo: self.buttonWatch.leadingAnchor, constant: -10),
            
            
            seasonlb.topAnchor.constraint(equalTo: categoryslb.bottomAnchor, constant: 20),
            seasonlb.trailingAnchor.constraint(lessThanOrEqualTo: self.timelb.leadingAnchor, constant: -padding),
            seasonlb.leadingAnchor.constraint(equalTo : self.containerView.leadingAnchor, constant: padding),
            
            timelb.centerYAnchor.constraint(equalTo: seasonlb.centerYAnchor),
            timelb.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            timelb.leadingAnchor.constraint(greaterThanOrEqualTo:  self.seasonlb.trailingAnchor, constant: 10),
            
            
            titleContent.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            titleContent.topAnchor.constraint(equalTo: self.seasonlb.bottomAnchor, constant: 30),
            
            contentView.topAnchor.constraint(equalTo: self.titleContent.bottomAnchor, constant: 10),
            contentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            
            titleEpisodes.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 30),
            titleEpisodes.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            
            
        ])
        
        closeButtonConstraint = .init(
            left: closeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            top: closeImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            width: closeImage.widthAnchor.constraint(equalToConstant: 40),
            height:closeImage.heightAnchor.constraint(equalTo: closeImage.widthAnchor)
        )
        closeButtonConstraint.active()
        
        bookmarksButtonConstraint = .init(
            right: bookmarksView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -padding),
            width: bookmarksView.widthAnchor.constraint(equalToConstant: 30),
            height: bookmarksView.heightAnchor.constraint(equalTo: bookmarksView.widthAnchor),
            centerY: bookmarksView.centerYAnchor.constraint(equalTo: self.closeImage.centerYAnchor)
        )
        bookmarksButtonConstraint.active()
        
        
        collectionViewConstraint = .init(
            left: collectionViewEpisode.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            right:collectionViewEpisode.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            bottom: self.collectionViewEpisode.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            top: collectionViewEpisode.topAnchor.constraint(equalTo: self.titleEpisodes.bottomAnchor, constant: 20))
        collectionViewConstraint.active()
        
        
    }
    
    override func deepLink(receive data: DeepLinkValues) {
        self.dataRequire = .init(poster: data.query["poster"]?.removingPercentEncoding, urlPage: data.query["url"]?.removingPercentEncoding)
        if let poster = dataRequire?.poster {
            ImageLoader.load(url: poster) {[weak self] image in
                guard let self = self else { return }
                self.placeHolderImage = image
            }
        }
    }
    
    override func performBinding() {
        super.performBinding()
        let output = viewModel.transform(input: .init(viewWillAppear: self.rx.viewWillAppear.take(1).map({[weak self] _ in
            return self?.dataRequire?.urlPage ?? ""
        }).asDriverOnErrorJustComplete(),
         bookmark: self.bookmarksView.rx.tap.map({[weak self] _ in
            guard let self = self, let url = self.dataRequire?.urlPage, let ep = self.data.first?.episode else { return (false, "", "")}
            return (!self.isBookmarks, url, ep)
            
        }).asDriverOnErrorJustComplete()))
        output.item.drive(onNext: {[weak self] data in
            guard let self = self, let data = data else { return }
            self.data = data.episodes
            self.contentView.text = data.content
            self.seasonlb.setTitle("\(data.season) - \(data.latest)", for: .normal)
            self.timelb.text = data.time
            self.categoryslb.text = "\(data.categorys)"
            self.headerSubtitleView.text = "\(data.categorys)"
            self.titleView.text = data.title
            self.headerTitleView.text = data.title
            self.isBookmarks = data.isBookmark
            self.bookmarksView.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.3) {
                self.containerView.alpha = 1
            }
        }).disposed(by: self.disposeBag)
        output.bookmark.drive(onNext: {[weak self] () in
            guard let self = self else { return }
            self.isBookmarks = !self.isBookmarks
            if #available(iOS 14.0, *) {
                WidgetCenter.shared.reloadAllTimelines()
            }
        }).disposed(by: self.disposeBag)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.isHidden = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    @objc func closeTap(_ sender : Any?){
        popTransitionAnimation()
    }
    @objc func closePageTap(_ sender : Any?){
        popTransitionAnimation()
    }
    func popTransitionAnimation() {
        guard let transitionDriver = self.transitionDriver else {
            self.naviagtionBack()
            return
        }
        self.view.isHidden = true
//        _ = self.navigationController?.popViewController(animated: false)
        self.naviagtionBack(false, completion: {
            transitionDriver.popTransitionAnimationContantOffset(0) {
            }
        })
        
    }
    
    fileprivate func playVideo(type: PlayerViewModel.PlayType) {
        let vc = PlayerViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.playType = type
        self.present(vc, animated: false, completion: nil)
    }
    
    
}

extension MovieDetailViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionView", for: indexPath)
        if let cell = cell as? EpisodeCollectionViewCell {
            cell.data = self.data[indexPath.row]
            cell.didSelected = {[weak self] data in
                guard let self = self else { return }
                self.playVideo(type: .url(url: data.url))
            }
        }
        return cell
    }
    
    
}
extension MovieDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = self.data[indexPath.row]
        let size = NSAttributedString(string: data.episode, attributes: [.font : EpisodeCollectionViewCell.titleFont]).size(considering: view.bounds.size.width)
        return .init(width: max(60, size.width + 20), height: 40)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}

extension MovieDetailViewController : UICollectionViewDelegate {
    @available(iOS 13.0, *)
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let d = self.data[indexPath.row]
        guard !d.sublinks.isEmpty else { return nil }
        return UIContextMenuConfiguration(identifier: (d.url) as NSCopying) {
            return nil
        } actionProvider: { provider in
            return UIMenu(title: "Sublinks:", children:  d.sublinks.map { sub in
                let action = UIAction(title: sub.name, handler: {[weak self] action in
                    guard let self = self else { return }
                    self.playVideo(type: .sublink(url: d.url, sublink: sub.data))
                })
                action.image = .init(systemName: "link")
                return action
            })
        }
    }
    
}
extension MovieDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.3) {
            self.headerView.alpha = (scrollView.contentOffset.y > self.headerHeight - self.buttonWacthHeight) ? 1 : 0
        }
        if scrollView.contentOffset.y > 0 {
//            if (self.lastContentOffset > scrollView.contentOffset.y) {
//                     // move down
//                let dis = scrollView.contentOffset.y - lastContentOffset
//                self.backgroundImage.frame.origin.y = min(0,(self.backgroundImage.frame.origin.y - dis))
//
//            }
//            else if (self.lastContentOffset < scrollView.contentOffset.y) {
//                    // move up
//                let dis = scrollView.contentOffset.y - lastContentOffset
//                self.backgroundImage.frame.origin.y = max(-self.headerHeight / 2, (self.backgroundImage.frame.origin.y - dis))
//            }

        }
        else {
            let scale : CGFloat = min(1.5, 1 + abs(scrollView.contentOffset.y) / 100)
            self.backgroundImage.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        }
        UIView.animate(withDuration: 0.3) {
            let scrollOffsetThreshold: CGFloat = self.headerHeight / 2
            if scrollView.contentOffset.y > scrollOffsetThreshold {
                self.bookmarksView.alpha = 0
                self.closeButtonConstraint.left?.constant = -40
            } else {
                self.bookmarksView.alpha = 1
                self.closeButtonConstraint.left?.constant = self.padding
            }
            self.gradientView.backgroundColor = .black.withAlphaComponent(max(0, min(1, scrollView.contentOffset.y / self.headerHeight)))
            self.view.layoutIfNeeded()
        }
        lastContentOffset = scrollView.contentOffset.y
    }
}
extension MovieDetailViewController : MovieDetailViewLogic {
    
}

