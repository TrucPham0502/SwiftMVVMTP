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
    var loadMoreSubject : PublishRelay<Int> = .init()
    fileprivate var titlesItem = [MovieCategory]()
    fileprivate var collectionItems: [[MovieCollectionViewCellModel]] = []
    fileprivate var cellsIsOpen = [[Bool]]()
    fileprivate var transitionDriver : TransitionDriver?
    fileprivate var itemSize = UIMovieHomeConfig.shared.cardsSize
    private lazy var searchController : UISearchController = {
        let v = UISearchController(searchResultsController: nil)
        v.searchResultsUpdater = self
        v.searchBar.searchBarStyle = .minimal
        v.searchBar.placeholder = "Search..."
        v.searchBar.tintColor = .white
        v.searchBar.clearBackgroundColor()
        v.searchBar.changePlaceholderColor(.white)
        v.searchBar.setImageLeftColor(.white)
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
        v.addSubview(searchController.searchBar)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    lazy var collectionView: MovieCollectionView = {
        let layout = MovieCollectionLayout(itemSize: itemSize)
        let collectionView = MovieCollectionView.createOnView(self.view,
                                                             layout: layout,
                                                             height: itemSize.height,
                                                             dataSource: self,
                                                             delegate: self)
        //        if #available(iOS 10.0, *) {
        //            collectionView.isPrefetchingEnabled = false
        //        }
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
        let output = viewModel.transform(input: .init(viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid().asDriverOnErrorJustComplete(), loadMore: self.loadMoreSubject.asDriverOnErrorJustComplete()))
        
        output.item.drive(onNext: {[weak self] (titles, item) in
            guard let _self = self else { return }
            _self.titlesItem = titles
            _self.collectionItems = item
            _self.reloadCollection()
            _self.glidingView.reloadData()
            if let url = item.first?.first?.poster {
                ImageLoader.load(url: url) { image in
                    _self.backgroundImage.image = image
                }
            }
        }).disposed(by: self.disposeBag)
        
        output.loadMore.drive(onNext: {data in
            self.appendCollectionView(section: data.0, items: data.1)
        }).disposed(by: self.disposeBag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        transitionDriver = TransitionDriver(view: view)
        //        getData()
        
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
            
            
            glidingView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 60),
            glidingView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            glidingView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            glidingView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            
        ])
    }
    func reloadCollection()
    {
        cellsIsOpen = self.collectionItems.map({ ds -> Array in
            Array(repeating: false, count: ds.count)
        })
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func appendCollectionView(section: Int, items : [MovieCollectionViewCellModel]){
        self.collectionItems[section].append(contentsOf: items)
        reloadCollection()
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
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard case let cell as MovieCollectionViewCell = cell else {
            return
        }
        let section = glidingView.expandedItemIndex
//        cell.configureCellViewConstraintsWithSize(itemSize)
        
        let index = indexPath.row % collectionItems[section].count
        let info = collectionItems[section][index]
        if let url = info.poster {
            ImageLoader.load(url: url, imageView: cell.backgroundImageView, imageDefault: UIImage(named: "poster_not_found"))
        }
        cell.customTitle.text = info.name
        cell.tagView.text = info.tag
        cell.cellIsOpen(cellsIsOpen[section][index], animated: false)
        cell.backViewAction = {_ in
            self.navigationToDetail(cell: cell, data: info, index: section)
        }
        
        cell.frontViewAction = {_ in
            if index == self.collectionView.currentIndex {
                cell.cellIsOpen(!cell.isOpened)
            }
            else {
                self.scrollViewWillBeginDecelerating(collectionView)
                collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
        
        if indexPath.row == self.collectionItems[section].count - 2 {
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
        if let cell = collectionView.cellForItem(at: .init(row: index, section: 0)) as? MovieCollectionViewCell {
            self.backgroundImage.image = cell.backgroundImageView.image
        }
    }
    
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if let cell = self.collectionView.currentCell {
            cell.cellIsOpen(false)
        }
    }
    
    
    
    
    func loadMore(section : Int){
        self.loadMoreSubject.accept(section)
    }
    
    func navigationToDetail(cell: MovieCollectionViewCell, data: MovieCollectionViewCellModel?, index : Int){
        let titleData = self.titlesItem[index]
        let vc = MovieDetailViewController()
        vc.dataRequire = .init(poster: data?.poster, urlPage: data?.url)
        vc.titleView.text = data?.name
        pushToViewController(vc)
    }
    
    func pushToViewController(_ viewController: MovieDetailViewController) {
        viewController.transitionDriver = transitionDriver
        let backImage = getBackImage(viewController, headerHeight: 0)
        transitionDriver?.pushTransitionAnimationIndex(self.collectionView.currentIndex,
                                                       collecitionView: self.collectionView,
                                                       backImage: backImage,
                                                       headerHeight: viewController.headerHeight,
                                                       insets: 0, titleAttr: viewController.titleView.attributedText!) {
            self.navigationController?.pushViewController(viewController, animated: false)
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
        return "– " + (self.titlesItem[index].title ?? "unknown")
    }
    
    
}
extension MovieHomeViewController : GlidingCollectionDelegate {
    func glidingCollection(_ collection: GlidingCollection, didExpandItemAt index: Int) {
        if let poster = self.collectionItems[index][0].poster {
            ImageLoader.load(url: poster) { image in
                self.backgroundImage.image = image
            }
        }
        
    }
}

extension MovieHomeViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //        if let section = self.glidingView.expandedItemIndex {
        //            let data =
        //        }
        
    }
    
    
}
struct MovieCategory {
    var nextPage: Int
    let title : String
    let pageType : PageType
}
