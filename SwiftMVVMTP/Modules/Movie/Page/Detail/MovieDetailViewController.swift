//
//  MovieDetailViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import UIKit
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
    
    var openVideo = PublishRelay<EpisodeModel>()
    fileprivate var scrollOffsetY: CGFloat = 0
    
    
    var dataRequire : DetailViewModel?
    var placeHolderImage : UIImage? {
        didSet {
            self.backgroundImage.image = placeHolderImage
            guard let placeHolderImage = placeHolderImage else { return }
            self.backgroundImage.frame = .init(origin: .zero, size: .init(width: self.view.bounds.width, height: self.view.bounds.width *  placeHolderImage.size.height / placeHolderImage.size.width))
        }
    }
    let gradientColors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor,
                          UIColor.black.cgColor,
                          UIColor.black.cgColor,
                          UIColor.black.cgColor]
    var headerHeight: CGFloat = UIScreen.main.bounds.height / 2 - 100
    var padding : CGFloat = 20
    var transitionDriver: TransitionDriver?
    var collectionViewConstraint: AppConstants = .init()
    var data : [EpisodeModel] = [] {
        didSet {
            self.collectionViewEpisode.layoutIfNeeded()
            self.collectionViewEpisode.reloadData()
        }
    }
    var isBookmarks : Bool = false {
        didSet {
            self.bookmarksView.image = isBookmarks ? .init(named: "christmas-star-fill") : .init(named: "christmas-star-stroke")
        }
    }
    
    var episodeItemSize : CGSize = .init(width: 40, height: 40)
    
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
    
    
    private lazy var containerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var backgroundImage : UIImageView = {
        let v = UIImageView()
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
        v.font = .boldSystemFont(ofSize: 25)
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
    
    private lazy var taglb : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .boldSystemFont(ofSize: 16)
        v.text = "VIETSUB"
        return v
    }()
    private lazy var tagView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "tag-color")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 3
        v.addSubview(taglb)
        NSLayoutConstraint.activate([
            taglb.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 8),
            taglb.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -8),
            taglb.topAnchor.constraint(equalTo: v.topAnchor, constant: 5),
            taglb.bottomAnchor.constraint(lessThanOrEqualTo: v.bottomAnchor, constant: -5)
        ])
        return v
    }()
    
    private lazy var episodelb : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 13)
        v.text = "Phần 4 - Tập 73"
        return v
    }()
    private lazy var episodeView : UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(named: "episodes-color")
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        let iconView : UIImageView = {
            let v = UIImageView(image: .init(named: "ic-clapperboard-black"))
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        [episodelb, iconView].forEach(v.addSubview)
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 12),
            iconView.widthAnchor.constraint(equalToConstant: 16),
            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
            iconView.topAnchor.constraint(equalTo: v.topAnchor, constant: 5),
            iconView.bottomAnchor.constraint(lessThanOrEqualTo: v.bottomAnchor, constant: -5),
            
            episodelb.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 5),
            episodelb.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -12),
            episodelb.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
        ])
        return v
    }()
    
    private lazy var bookmarksView : UIImageView = {
        let v = UIImageView(image: .init(named: "christmas-star-stroke"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bookmarksSelected)))
        v.isUserInteractionEnabled = true
        return v
    }()
    
    private lazy var buttonWatch : LayeredButton = {
        let v = LayeredButton()
        v.setTitle("Watch", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var contentView : ExpandableLabel = {
        let v = ExpandableLabel()
        v.text = "No content"
        v.textColor = .lightGray
        v.font = .systemFont(ofSize: 14)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        return v
    }()
    
    
    private lazy var titleEpisodes : UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 16)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Tập"
        v.textColor = .white
        return v
    }()
    
    private lazy var collectionViewEpisode : DynamicCollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = episodeItemSize
        flow.minimumLineSpacing = 8
        flow.minimumInteritemSpacing = 3
        let v = DynamicCollectionView(frame: .zero, collectionViewLayout: flow)
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
        
        // Do any additional setup after loading the view.
        prepareUI()
        
    }
    
    @objc private func bookmarksSelected(){
        isBookmarks = !isBookmarks
    }
    
    override func prepareUI() {
        super.prepareUI()
        self.view.backgroundColor = .black
        self.view.isHidden = true
        [backgroundImage, gradientView, scrollView, closeImage].forEach(self.view.addSubview)
        self.scrollView.addSubview(containerView)
        [titleView,tagView,episodeView, bookmarksView, buttonWatch, contentView, titleEpisodes, collectionViewEpisode].forEach(self.containerView.addSubview)
        
        NSLayoutConstraint.activate([
            
            self.gradientView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.gradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.gradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.gradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            
            closeImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            closeImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: padding),
            closeImage.heightAnchor.constraint(equalToConstant: 40),
            closeImage.widthAnchor.constraint(equalToConstant: 40),
            
            titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: headerHeight),
            titleView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            titleView.trailingAnchor.constraint(equalTo: self.tagView.leadingAnchor, constant: -20),
            
            tagView.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor),
            tagView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            
            episodeView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 20),
            episodeView.trailingAnchor.constraint(lessThanOrEqualTo: self.bookmarksView.leadingAnchor, constant: -padding),
            episodeView.leadingAnchor.constraint(equalTo : self.containerView.leadingAnchor, constant: padding),
            
            bookmarksView.centerYAnchor.constraint(equalTo: episodeView.centerYAnchor),
            bookmarksView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            bookmarksView.heightAnchor.constraint(equalTo: bookmarksView.widthAnchor),
            bookmarksView.widthAnchor.constraint(equalToConstant: 24),
            
            
            buttonWatch.topAnchor.constraint(equalTo: self.episodeView.bottomAnchor, constant: 20),
            buttonWatch.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            buttonWatch.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            buttonWatch.heightAnchor.constraint(equalToConstant: 60),
            
            contentView.topAnchor.constraint(equalTo: self.buttonWatch.bottomAnchor, constant: 25),
            contentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            contentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            
            titleEpisodes.topAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 30),
            titleEpisodes.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            
            
        ])
        
        collectionViewConstraint = .init(
            left: collectionViewEpisode.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            right:collectionViewEpisode.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            bottom: self.collectionViewEpisode.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor, constant: -padding),
            top: collectionViewEpisode.topAnchor.constraint(equalTo: self.titleEpisodes.bottomAnchor, constant: 20))
        collectionViewConstraint.active()
        
        if let poster = dataRequire?.poster {
            ImageLoader.load(url: poster) { image in
                self.backgroundImage.image = image
            }
        }
    }
    
    override func performBinding() {
        super.performBinding()
        guard let url = self.dataRequire?.urlPage else {
            return
        }
        let output = viewModel.transform(input: .init(viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid().asDriverOnErrorJustComplete(), openVideo: self.openVideo.asDriverOnErrorJustComplete(), url: url))
        output.item.drive(onNext: {[weak self] (data, content, url, season) in
            guard let self = self else { return }
            self.data = data
            self.contentView.text = content
            self.episodelb.text = ""
        }).disposed(by: self.disposeBag)
    }
    
    func getSizeCollectionView() -> CGFloat {
        let numberInRow = Int(UIScreen.main.bounds.width / (self.episodeItemSize.width + 10))
        let numberRow = (self.data.count % numberInRow > 0) ? (self.data.count / numberInRow) + 1 : (self.data.count / numberInRow)
        return (self.episodeItemSize.height + 10) * CGFloat(numberRow)
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
    public func popTransitionAnimation() {
        guard let transitionDriver = self.transitionDriver else {
            return
        }
        self.view.isHidden = true
        _ = self.navigationController?.popViewController(animated: false)
        transitionDriver.popTransitionAnimationContantOffset(0) {
        }
        
    }
    
    
    fileprivate func getScreen() -> UIImage? {
        let backImageSize = self.view.bounds.size
        let backImageOrigin = CGPoint(x: 0, y:  0)
        return self.view.takeSnapshot(CGRect(origin: backImageOrigin, size: backImageSize))
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
        }
        return cell
    }
    
    
    
    
}

extension MovieDetailViewController : UICollectionViewDelegate {
    
    //    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
    //        let d = self.data[indexPath.row]
    //        return UIContextMenuConfiguration(identifier: (d.id ?? "") as NSCopying, previewProvider: {
    //            return nil
    //        }, actionProvider: { suggestedActions in
    //            if let id = d.id {
    //                if let videoFromId = RxPlayerHelper.shared.videos[id] {
    //                    var resolutions : [VideoResolution] = []
    //                    if case let VideoPlayer.dailymotion(v) = videoFromId {
    //                        resolutions = v.resolutions
    //                    }
    //                    else if case let VideoPlayer.fembed(v) = videoFromId {
    //                        resolutions = v.resolutions
    //                    }
    //                    let menu = UIMenu(title: "Select resolution", children: resolutions.map({
    //                        UIAction(title: $0.resolution, image: nil, identifier: UIAction.Identifier(rawValue: $0.id)) { action in
    //                            switch videoFromId {
    //                            case .dailymotion:
    //                                RxPlayerHelper.shared.openPlayer(self, videoType: .dailymotion(id: id, resolationId: action.identifier.rawValue), openVideoController: false).asDriverOnErrorJustComplete().drive(onNext: { d in
    //                                    guard let data = d else { return }
    //                                    let urls = RxPlayerHelper.shared.getUrl(data)
    //                                    self.videoPlayer.videoURL = urls.first
    //                                }).disposed(by: self.disposeBag)
    //                            case .fembed:
    //                                RxPlayerHelper.shared.openPlayer(self, videoType: .fembed(id: id, resolationId: action.identifier.rawValue), openVideoController: false).asDriverOnErrorJustComplete().drive(onNext: { d in
    //                                    guard let data = d else { return }
    //                                    let urls = RxPlayerHelper.shared.getUrl(data)
    //                                    self.videoPlayer.videoURL = urls.first
    //                                }).disposed(by: self.disposeBag)
    //                            default: break
    //                            }
    //
    //
    //                        }
    //                    }))
    //                    return menu
    //                }
    //                return UIMenu(title: "Menu", children: [
    //                    UIAction(title: "Play Video", handler: { _ in
    //                        switch d.type {
    //                        case .dailymotion:
    //                            RxPlayerHelper.shared.openPlayer(self, videoType: .dailymotion(id: id), openVideoController: false).asDriverOnErrorJustComplete().drive(onNext: { d in
    //                                guard let data = d else { return }
    //                                let urls = RxPlayerHelper.shared.getUrl(data)
    //                                self.videoPlayer.videoURL = urls.first
    //                            }).disposed(by: self.disposeBag)
    //                        case .fileone:
    //                            if let urlString = d.link {
    //                                RxPlayerHelper.shared.openPlayer(self, videoType: .fileone(id: id, url: urlString), openVideoController: false).asDriverOnErrorJustComplete().drive(onNext: { d in
    //                                    guard let data = d else { return }
    //                                    let urls = RxPlayerHelper.shared.getUrl(data)
    //                                    self.videoPlayer.videoURL = urls.first
    //                                }).disposed(by: self.disposeBag)
    //                            }
    //                        default:
    //                            break
    //                        }
    //
    //                    })
    //                ])
    //            }
    //            return nil
    //        })
    //    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let data = self.data[indexPath.row]
        self.openVideo.accept(data)
    }
    
}
extension MovieDetailViewController : UIScrollViewDelegate {
    //    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //        if scrollView.contentOffset.y < -25  {
    //            // buttonAnimation
    //            popTransitionAnimation()
    //        }
    //        scrollOffsetY = scrollView.contentOffset.y
    //    }
}
extension MovieDetailViewController : MovieDetailViewLogic {
    
}
