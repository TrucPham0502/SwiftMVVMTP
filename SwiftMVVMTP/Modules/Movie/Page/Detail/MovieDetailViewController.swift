//
//  MovieDetailViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
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
    fileprivate var scrollOffsetY: CGFloat = 0
    var dataRequire : DetailViewModel?
    var placeHolderImage : UIImage? {
        didSet {
            self.backgroundImage.image = placeHolderImage
            guard let placeHolderImage = placeHolderImage else { return }
            self.backgroundImage.frame = .init(origin: .zero, size: .init(width: self.view.bounds.width, height: self.view.bounds.width *  placeHolderImage.size.height / placeHolderImage.size.width))
        }
    }
    var headerHeight: CGFloat = 300
    var transitionDriver: TransitionDriver?
    var heightCollectionView : NSLayoutConstraint?
    var data : [EpisodeModel] = []
    var contents = ""
    var episodeItemSize : CGSize = .init(width: 50, height: 50)
    
    var openVideo = PublishRelay<EpisodeModel>()
    
    private lazy var scrollView : UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        v.showsVerticalScrollIndicator = false
        v.showsHorizontalScrollIndicator = false
        v.contentInsetAdjustmentBehavior = .never
        v.delegate = self
        v.contentInset = .zero
        return v
    }()
    
    
    private lazy var containerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame.size = view.bounds.size
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.7).cgColor, UIColor.black.withAlphaComponent(0.8).cgColor,
                                UIColor.black.cgColor,
                                UIColor.black.cgColor,
                                UIColor.black.cgColor]
        v.layer.addSublayer(gradientLayer)
        return v
    }()
    
    private lazy var backgroundImage : UIImageView = {
        let v = UIImageView()
        v.clipsToBounds = true
        return v
    }()
    
    lazy var button : UIButton = {
        let v = UIButton()
        v.setTitle("abc", for: .normal)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(closePageTap), for: .touchUpInside)
        v.backgroundColor = .red
        return v
    }()
    
    lazy var closeImage : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setImage(UIImage(named: "CloseButton"), for: .normal)
        v.contentEdgeInsets = .zero
        v.addTarget(self, action: #selector(closeTap), for: .touchUpInside)
        return v
    }()
    
    lazy var videoPlayer : VideoPlayerView = {
        let v = VideoPlayerView()
        v.setFrame(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: headerHeight))
        v.setControlFrame(v.bounds)
        
        v.backgroundColor = .black
        return v
    }()
    
    lazy var titleView : UILabel = {
        let v = UILabel()
        v.font = .boldSystemFont(ofSize: 20)
        v.textAlignment = .center
        v.numberOfLines = 0
        v.text = ""
        v.textColor = .darkGray
        v.layer.shadowRadius = 2
        v.layer.shadowOffset = CGSize(width: 0, height: 3)
        v.layer.shadowOpacity = 0.2
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private lazy var collectionViewEpisode : UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = episodeItemSize
        flow.minimumLineSpacing = 5
        flow.minimumInteritemSpacing = 2
        let v = UICollectionView(frame: .zero, collectionViewLayout: flow)
        v.dataSource = self
        v.register(EpisodeCollectionViewCell.self, forCellWithReuseIdentifier: "EpisodeCollectionView")
        v.showsVerticalScrollIndicator = false
        v.backgroundColor = .clear
        v.showsHorizontalScrollIndicator = false
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        return v
    }()
    
    lazy var contentView : UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.numberOfLines = 0
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareUI()
        
    }
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.backgroundColor = .red
        self.view.isHidden = true
//        self.view.addSubview(videoPlayer)
        [backgroundImage, scrollView, closeImage].forEach(self.view.addSubview)
        self.scrollView.addSubview(containerView)
        [collectionViewEpisode, titleView,contentView].forEach({self.containerView.addSubview($0)})
        
        
        self.heightCollectionView = self.collectionViewEpisode.heightAnchor.constraint(equalToConstant: getSizeCollectionView())
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            
            self.containerView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.containerView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.containerView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            
            //            self.containerView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
           
            closeImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            closeImage.heightAnchor.constraint(equalToConstant: 30),
            closeImage.widthAnchor.constraint(equalToConstant: 30),
            
//            titleView.topAnchor.constraint(equalTo: self.containerView.topAnchor, constant: 20),
//            titleView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25),
//            titleView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25),
            
            
//            collectionViewEpisode.topAnchor.constraint(equalTo: self.titleView.bottomAnchor, constant: 20),
//            collectionViewEpisode.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 25),
//            collectionViewEpisode.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -25),
//            heightCollectionView!,
//
//            contentView.topAnchor.constraint(equalTo: self.collectionViewEpisode.bottomAnchor, constant: 10),
//            contentView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor, constant: 20),
//            contentView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor, constant: -20),
//            contentView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -50),
            
        ])
        if let poster = dataRequire?.poster {
            ImageLoader.load(url: poster) { image in
                self.backgroundImage.image = image
            }
        }
        
//        videoPlayer.setConstaints(.init(
//            left: videoPlayer.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
//            right: videoPlayer.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
//            top: videoPlayer.topAnchor.constraint(equalTo: self.containerView.topAnchor),
//            height: videoPlayer.heightAnchor.constraint(equalToConstant: headerHeight)))
    }
    
    override func performBinding() {
        super.performBinding()
//        guard let url = self.dataRequire?.urlPage else {
//            return
//        }
//        let output = viewModel.transform(input: .init(viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid().asDriverOnErrorJustComplete(), openVideo: self.openVideo.asDriverOnErrorJustComplete(), url: url))
//        output.item.drive(onNext: { (data, content) in
//            self.data = data
//            self.contents = content
//            if !self.contents.isEmpty {
//                let titleAttr = NSAttributedString(string: "Overview:\n", attributes: [.font : UIFont.systemFont(ofSize: 18), .foregroundColor : UIColor.black]).setSpaceLines(8)
//                let attr = NSAttributedString(string: self.contents, attributes: [.font : UIFont.systemFont(ofSize: 15), .foregroundColor : UIColor.darkGray]).setSpaceLines()
//                let mutableAttr = NSMutableAttributedString(attributedString: titleAttr)
//                mutableAttr.append(attr)
//                self.contentView.attributedText = mutableAttr
//            }
//            self.heightCollectionView?.constant = self.getSizeCollectionView()
//            self.collectionViewEpisode.reloadData()
//        }).disposed(by: self.disposeBag)
//
//        output.openVideo.drive(onNext: {[weak self] url in
//            self?.videoPlayer.videoURL = url
//        }).disposed(by: self.disposeBag)
    }
    
    func getSizeCollectionView() -> CGFloat {
        
        let numberInRow = Int(UIScreen.main.bounds.width / (self.episodeItemSize.width + 10))
        let numberRow = (self.data.count % numberInRow > 0) ? (self.data.count / numberInRow) + 1 : (self.data.count / numberInRow)
        return (self.episodeItemSize.height + 10) * CGFloat(numberRow)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.isHidden = false
        videoPlayer.videoURL = URL(string: "https://hhhkungfu.tv/Dis-m3u8/64DBrXF3hEiqkKrSGZQN7o7tJ2aKtoAuL.m3u8?prx=gps&v=2022")
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
        let backImage = getScreen()
        transitionDriver.popTransitionAnimationContantOffset(0, backImage: backImage) {
            
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
