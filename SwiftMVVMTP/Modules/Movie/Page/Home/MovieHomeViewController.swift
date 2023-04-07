//
//  MovieHomeViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 24/09/2021.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
class MovieHomeViewController : BaseViewController<MovieHomeViewModel> {
    override func buildViewModel() -> MovieHomeViewModel {
        return MovieHomeViewModel()
    }
    let event : MovieHomeViewModel.Event = .init(bookmark: PublishRelay())
    var loadMoreSubject : PublishRelay<Int> = .init()
    private var cellOpens : Dictionary<Int, Bool> = [:]
    fileprivate var titlesItem = [MovieCategory]()
    fileprivate var collectionItems: [[MovieCollectionViewCellModel]] = []
    fileprivate var transitionDriver : TransitionDriver?
    fileprivate var itemSize = UIMovieHomeConfig.shared.cardsSize
    private var currentIndex : IndexPath = .init(row: 0, section: 0) {
        didSet {
            guard oldValue.section < self.collectionItems.count,
                  oldValue.section > -1,
                  oldValue.row < self.collectionItems[currentIndex.section].count,
                  oldValue.row > -1 else { return }
            if let cell = self.collectionView.cellForItem(at: oldValue) as? MovieCollectionViewCell {
                cell.cellIsOpen(false)
            }
            cellOpens[oldValue.row] = false
            self.changeBackground()
        }
    }
    
    private lazy var searchbar : SearchBar = {
        let v = SearchBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.attributedPlaceholder  = NSAttributedString(
            string: "Tìm kiếm...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.7)]
        )
        v.textColor = .white.withAlphaComponent(0.7)
        return v
    }()
    
    private lazy var backgroundImage : UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.translatesAutoresizingMaskIntoConstraints = false
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        v.addSubview(blurEffectView)
        return v
    }()
    private lazy var headerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        v.clipsToBounds = true
        v.addSubview(searchbar)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var collectionView: MovieCollectionView = {
        let layout = MovieCollectionLayout(itemSize: itemSize)
        let collectionView = MovieCollectionView(self.view,
                                                 layout: layout,
                                                 height: itemSize.height,
                                                 dataSource: self,
                                                 delegate: self)
        return collectionView
    }()
    private lazy var glidingView : GlidingCollection = {
        let v = GlidingCollection(collectionView: self.collectionView)
        v.backgroundColor = .clear
        v.translatesAutoresizingMaskIntoConstraints = false
        v.delegate = self
        v.dataSource = self
        return v
        
    }()
    
    
    override func performBinding() {
        super.performBinding()
        let output = viewModel.transform(input: .init(
            viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid(),
            loadMore: self.loadMoreSubject.asObservable().throttle(.seconds(1), scheduler: MainScheduler.instance),
            searchbar: self.searchbar.rx.text.orEmpty.asObservable().debounce(.seconds(1), scheduler: MainScheduler.instance),
            event: event))
        
        output.data.drive(onNext: {[weak self] data in
            guard let _self = self else { return }
            switch data {
            case let .item(value):
                _self.collectionItems = value.0.datas
                if !value.1 {
                    _self.titlesItem = value.0.titles
                    _self.glidingView.reloadData()
                }
                _self.changeBackground()
                _self.reloadCollection()
            default: break;
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        transitionDriver = TransitionDriver(view: view)
        
    }
    
    override func dismissKeyboard() {
        super.dismissKeyboard()
        self.collectionView.currentCell?.cellIsOpen(false)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    override func prepareUI(){
        self.view.backgroundColor =  .white
        [backgroundImage, glidingView, headerView].forEach{
            self.view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            searchbar.topAnchor.constraint(equalTo: self.headerView.topAnchor),
            searchbar.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor, constant: 16),
            searchbar.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor, constant: -16),
            searchbar.heightAnchor.constraint(equalToConstant: 40),
            
            
            glidingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            glidingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            //            glidingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            //            glidingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            glidingView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
            ///colection view auto width =>  rotate => resize layout => error layout
            
        ])
    }
    func reloadCollection()
    {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func changeBackground(){
        guard currentIndex.section < self.collectionItems.count,
              currentIndex.section > -1,
              currentIndex.row < self.collectionItems[currentIndex.section].count,
              currentIndex.row > -1 else { return }
        let data = self.collectionItems[currentIndex.section][currentIndex.row]
        if let posterImg = data.posterImage {
            setBackground(posterImg)
        } else if !data.poster.isEmpty {
            ImageLoader.load(url: data.poster) {[weak self] image in
                guard let self = self else { return }
                self.setBackground(image)
            }
        }
    }
    
    func setBackground(_ image: UIImage?) {
        let crossFade: CABasicAnimation = CABasicAnimation(keyPath: "contents")
        crossFade.duration = 0.3
        crossFade.fromValue = self.backgroundImage.image?.cgImage
        crossFade.toValue = image?.cgImage
        self.backgroundImage.image = image
        self.backgroundImage.layer.add(crossFade, forKey: "animateContents")
    }
    
}
extension MovieHomeViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = glidingView.expandedItemIndex
        if section > -1, section < titlesItem.count {
            return collectionItems[section].count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath)
        guard let cell = cell as? MovieCollectionViewCell else {
            return cell
        }
        let section = glidingView.expandedItemIndex
        let index = indexPath.row % collectionItems[section].count
        let info = collectionItems[section][index]
        if let pImage = info.posterImage { cell.backgroundImageView.image = pImage }
        else if !info.poster.isEmpty {
            ImageLoader.load(url: info.poster, imageView: cell.backgroundImageView, imageDefault: UIImage(named: "poster_not_found")) {[weak self] image in
                guard let self = self else { return }
                self.collectionItems[section][index].posterImage = image
            }
        }
        cell.model = info
        cell.cellIsOpen(self.cellOpens[index] ?? false, animated: false)
        cell.backViewAction = {[weak self] _ in
            guard let self = self else { return }
            self.navigationToDetail(cell: cell, data: info, index: section)
        }
        cell.bookmarkAction = {[weak self] isSelected in
            guard let self = self else { return }
//            self.collectionItems[section][indexPath.row].isBookmark = isSelected
            self.event.bookmark.accept((indexPath, isSelected))
        }
        
        cell.frontViewAction = {[weak self] _ in
            guard let self = self else { return }
            self.cellOpens[index] = !cell.isOpened
            if index == self.collectionView.currentIndex {
                cell.cellIsOpen(!cell.isOpened)
            }
            else {
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
                self.currentIndex = indexPath
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let section = glidingView.expandedItemIndex
        if indexPath.row == self.collectionItems[section].count - 4 {
            self.loadMore(section: indexPath.section)
        }
    }
    #if os(iOS) && targetEnvironment(macCatalyst)
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollViewDidEndDecelerating(scrollView)
    }
    #endif
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let startOffset = (collectionView.bounds.size.width - itemSize.width) / 2
        guard let collectionLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let minimumLineSpacing = collectionLayout.minimumLineSpacing
        let a = collectionView.contentOffset.x + startOffset + itemSize.width / 2
        let b = itemSize.width + minimumLineSpacing
        let index = Int(a/b)
        self.currentIndex = .init(row: index, section: self.glidingView.expandedItemIndex)
    }
    
    
    
    
    func loadMore(section : Int){
        self.loadMoreSubject.accept(section)
    }
    
    func navigationToDetail(cell: MovieCollectionViewCell, data: MovieCollectionViewCellModel?, index : Int){
        let vc = MovieDetailViewController()
        vc.dataRequire = .init(poster: data?.poster, urlPage: data?.url)
        pushToViewController(vc)
    }
    
    func pushToViewController(_ viewController: MovieDetailViewController) {
        viewController.transitionDriver = transitionDriver
        let image = self.collectionItems[self.glidingView.expandedItemIndex][self.collectionView.currentIndex].posterImage
        viewController.placeHolderImage = image
        transitionDriver?.pushTransitionAnimationIndex(self.collectionView.currentIndex,
                                                       collecitionView: self.collectionView,
                                                       imageSize: image?.size ?? .zero,
                                                       gradientColors: viewController.gradientColors) {[weak self] cell in
            guard let self = self else { return }
//            self.navigationController?.pushViewController(viewController, animated: false)
            let vc = UINavigationController(rootViewController: viewController)
            vc.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(vc, animated: false, completion: nil)
        }
    }
    
    fileprivate func getBackImage(_ viewController: UIViewController, headerHeight: CGFloat) -> UIImage? {
        let imageSize = CGSize(width: viewController.view.bounds.width, height: viewController.view.bounds.height - headerHeight)
        let imageFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: imageSize)
        return viewController.view.takeSnapshot(imageFrame)
    }
    
    
}
// MARK: - Gliding Collection 🎢
extension MovieHomeViewController: GlidingCollectionDatasource {
    
    func numberOfItems(in collection: GlidingCollection) -> Int {
        return self.titlesItem.count
    }
    
    func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String {
        return "– " + self.titlesItem[index].title
    }
    
    
}
extension MovieHomeViewController : GlidingCollectionDelegate {
    func glidingCollection(_ collection: GlidingCollection, didExpandItemAt index: Int) {
        self.currentIndex = .init(row: self.collectionView.currentIndex, section: index)
    }
}
