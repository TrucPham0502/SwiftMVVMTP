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
        v.font = .boldSystemFont(ofSize: 30)
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
        v.backgroundColor = UIColor(named: "secondary-primary-color")
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
    
    private lazy var seasonlb : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 13)
        v.textColor = .white.withAlphaComponent(0.8)
        v.text = ""
        return v
    }()
    private lazy var episodeView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 7
        v.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        v.layer.borderWidth = 1
        [seasonlb].forEach(v.addSubview)
        NSLayoutConstraint.activate([
            
            seasonlb.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 12),
            seasonlb.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -12),
            seasonlb.topAnchor.constraint(equalTo: v.topAnchor, constant: 5),
            seasonlb.bottomAnchor.constraint(lessThanOrEqualTo: v.bottomAnchor, constant: -5),
        ])
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
    
    private lazy var timelb : UILabel =  {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white.withAlphaComponent(0.8)
        v.numberOfLines = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var categoryslb : UILabel =  {
        let v = UILabel()
        v.font = .systemFont(ofSize: 14)
        v.textColor = .white
        v.numberOfLines = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private lazy var buttonWatch : LayeredButton = {
        let v = LayeredButton()
        v.setTitle("Xem phim", for: .normal)
        v.layer.cornerRadius = 20
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(watchTap), for: .touchUpInside)
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
        v.font = .boldSystemFont(ofSize: 17)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.text = "Tập:"
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
            self.playVideo(url: first.url)
        }
    }
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.isHidden = true
        [backgroundImage, gradientView, scrollView, closeImage, bookmarksView].forEach(self.view.addSubview)
        self.scrollView.addSubview(containerView)
        [titleView,tagView,episodeView, timelb,categoryslb, buttonWatch, contentView, titleEpisodes, collectionViewEpisode].forEach(self.containerView.addSubview)
        titleView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
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
            
            
            titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: headerHeight),
            titleView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: padding),
            titleView.trailingAnchor.constraint(lessThanOrEqualTo: self.tagView.leadingAnchor, constant: -20),
            
            tagView.centerYAnchor.constraint(equalTo: self.titleView.centerYAnchor),
            tagView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            
            categoryslb.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 5),
            categoryslb.leadingAnchor.constraint(equalTo: self.titleView.leadingAnchor, constant: 5),
            categoryslb.trailingAnchor.constraint(lessThanOrEqualTo: self.containerView.trailingAnchor, constant: -padding),
            
            episodeView.topAnchor.constraint(equalTo: categoryslb.bottomAnchor, constant: 20),
            episodeView.trailingAnchor.constraint(lessThanOrEqualTo: self.bookmarksView.leadingAnchor, constant: -padding),
            episodeView.leadingAnchor.constraint(equalTo : self.containerView.leadingAnchor, constant: padding),
            
            timelb.centerYAnchor.constraint(equalTo: episodeView.centerYAnchor),
            timelb.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -padding),
            timelb.leadingAnchor.constraint(greaterThanOrEqualTo:  self.episodeView.trailingAnchor, constant: 10),
            
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
        
        if let poster = dataRequire?.poster {
            ImageLoader.load(url: poster) { image in
                self.backgroundImage.image = image
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
            
        }).do(onNext: {[weak self] _ in
            guard let self = self else { return }
            self.isBookmarks = !self.isBookmarks
        }).asDriverOnErrorJustComplete()
                                                     ))
        output.item.drive(onNext: {[weak self] data in
            guard let self = self else { return }
            switch data {
            case let .item(value):
                self.data = value.episodes
                self.contentView.text = value.content
                self.seasonlb.text = "\(value.season) - \(value.latest)"
                self.timelb.text = value.time
                self.categoryslb.text = "(\(value.categorys))"
                self.titleView.text = value.title
                self.isBookmarks = value.isBookmark
                UIView.animate(withDuration: 0.3) {
                    self.containerView.alpha = 1
                }
            default: break
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
            return
        }
        self.view.isHidden = true
//        _ = self.navigationController?.popViewController(animated: false)
        self.dismiss(animated: false, completion: {
            transitionDriver.popTransitionAnimationContantOffset(0) {
            }
        })
        
        
    }
    
    fileprivate func playVideo(url : String) {
        let vc = PlayerViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.urlString = url
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
                self.playVideo(url: data.url)
            }
        }
        return cell
    }
    
    
    
    
}
extension MovieDetailViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = self.data[indexPath.row]
        let size = NSAttributedString(string: data.episode, attributes: [.font : EpisodeCollectionViewCell.titleFont]).size(considering: view.bounds.size.width)
        return .init(width: max(45, size.width + 20), height: 40)
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
    
}
extension MovieDetailViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
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
        
    }
}
extension MovieDetailViewController : MovieDetailViewLogic {
    
}

