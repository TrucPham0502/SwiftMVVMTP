//
//  ProfileViewController.swift
//  SwiftMVVMTP
//
//  Created by TrucPham on 13/04/2023.
//  Copyright © 2023 Truc Pham. All rights reserved.
//

import Foundation
import UIKit
import RxRelay
import ActivityKit
import FirebaseMessaging
extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

class ProfileViewController : BaseViewController<ProfileViewModel> {
   

    enum ProfileModel {
        case item([ProfileItemModel])
    }
    override func buildViewModel() -> ProfileViewModel {
        return ProfileViewModel()
    }
    
    private let headerHeight : CGFloat = 300
    private let avatarSize : CGFloat = 100
    
    private let itemSelectedPR = PublishRelay<ProfileItemModel>()
    
    private var data : [ProfileModel] = [
//        .item([
//            .init(icon: .init(named: "ic-user"), title: "Personal Detail", type: .personal),
//            .init(icon: .init(named: "ic-support"), title: "Support Center", type: .support)
//        ]),
        .item([
            .init(icon: .init(named: "ic-logout"), title: "Movie Schedule", type: .movieSchedule)
        ]),
        .item([
            .init(icon: .init(named: "ic-logout"), title: "Logout", type: .logout)
        ])
    ]
    
    
    private lazy var backgroundCircle : BackgroundCircleNeumorphic = {
        let v = BackgroundCircleNeumorphic()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    
    private lazy var backButton : ButtonNeumorphic = {
        let v = ButtonNeumorphic()
        v.layer.cornerRadius = 20
        v.setImage(.init(named: "ic-back"), for: .normal)
        v.contentEdgeInsets = .init(top: 10, left: 10, bottom: 10, right: 10)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.addTarget(self, action: #selector(backTap), for: .touchUpInside)
        return v
    }()
    
    private lazy var tableView : UITableView = {
        let v = UITableView(frame: .zero, style: .grouped)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        v.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.reuseIdentifier)
        v.rowHeight = UITableView.automaticDimension
        v.estimatedRowHeight = UITableView.automaticDimension
        v.separatorStyle = .none
        v.backgroundColor = .clear
        return v
    }()
    
    private lazy var avatarView : UIImageView = {
        let v = UIImageView(image: .init(named: "user-avatar-default"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.layer.masksToBounds = true
        v.contentMode = .scaleAspectFill
        v.layer.cornerRadius = avatarSize / 2
        return v
    }()
    
    private lazy var avatarContainerView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = avatarSize / 2
        v.layer.borderWidth = 2
        v.layer.borderColor = UIColor.white.cgColor
        v.backgroundColor = .white
        v.setShadow(.init(width: 3, height: 3))
        v.addSubview(avatarView)
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 2),
            avatarView.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -2),
            avatarView.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -2),
            avatarView.topAnchor.constraint(equalTo: v.topAnchor, constant: 2)
        ])
        return v
    }()
    
    private lazy var userNamelb : UILabel = {
        let v = UILabel()
        v.font = .bold(ofSize: 18)
        v.text = "Katrin Watson"
        v.numberOfLines = 1
        v.textColor = .black.withAlphaComponent(0.7)
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var headerView : UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        let container = UIViewNeumorphic()
        container.layer.cornerRadius = 20
        container.translatesAutoresizingMaskIntoConstraints = false
        
        [userNamelb].forEach(container.addSubview)
        [container, avatarContainerView, self.backButton].forEach(v.addSubview)
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 30),
            container.trailingAnchor.constraint(equalTo: v.trailingAnchor, constant: -30),
            container.bottomAnchor.constraint(equalTo: v.bottomAnchor, constant: -20),
            container.topAnchor.constraint(equalTo: v.topAnchor, constant: avatarSize / 2 + 70),
            
            avatarContainerView.topAnchor.constraint(equalTo: container.topAnchor, constant: -avatarSize/2),
            avatarContainerView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            avatarContainerView.heightAnchor.constraint(equalToConstant: avatarSize),
            avatarContainerView.widthAnchor.constraint(equalTo: avatarContainerView.heightAnchor),
            
            userNamelb.topAnchor.constraint(equalTo: avatarContainerView.bottomAnchor, constant: 20),
            userNamelb.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            
            backButton.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 24),
            backButton.topAnchor.constraint(equalTo: v.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 40)
            
        ])
        return v
    }()
    
    
    override func prepareUI() {
        super.prepareUI()
        self.view.addSubview(backgroundCircle)
        [self.tableView].forEach(self.backgroundCircle.addSubview(_:))
        NSLayoutConstraint.activate([
            backgroundCircle.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundCircle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundCircle.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundCircle.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            
            self.tableView.topAnchor.constraint(equalTo: self.backgroundCircle.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.backgroundCircle.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.backgroundCircle.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.backgroundCircle.bottomAnchor),
        ])
    }
    
    override func performBinding() {
        super.performBinding()
        let output = viewModel.transform(input: .init(
            viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid().asDriverOnErrorJustComplete(),
            itemSelected: itemSelectedPR.asDriverOnErrorJustComplete()))
        
        output.result.drive(onNext: {[weak self] data in
            guard let self = self, let data = data else { return }
            self.avatarView.image = .init(named: "avatar")
            self.userNamelb.text = "\(data.lastName ?? "") \(data.firstName ?? "")"
        }).disposed(by: self.disposeBag)
        
        output.itemSelected.drive(onNext: {[weak self] item in
            guard let self = self else { return }
            switch item.type {
            case .logout:
                self.naviagtionBack()
            case .movieSchedule:
                if #available(iOS 16.1, *) {
                    let initialContentState = ScheduleAttributes.ContentState(name: "Hello TP")
                    let activityAttributes = ScheduleAttributes()
                    if ActivityAuthorizationInfo().areActivitiesEnabled {
                        do {
                            let activity = try Activity<ScheduleAttributes>.request(attributes: activityAttributes, contentState: initialContentState, pushType: .token)
                            print("Activity Added successsfully. id: \(activity.id)")
                            Task {
                                for await data in activity.pushTokenUpdates {
                                    let myToken = data.hexString
                                    print("Activity Added successsfully. myToken: \(myToken)")
                                }
                            }
                           
                        }
                        catch {
                            print(error.localizedDescription)
                        }
                    }
                }
            default: break
            }
        }).disposed(by: self.disposeBag)
    }
    
    
    @objc func backTap(){
        naviagtionBack()
    }
}
extension ProfileViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.reuseIdentifier, for: indexPath)
        cell.selectionStyle = .none
        let data = self.data[indexPath.row]
        switch data {
        case .item(let vm):
            if let cell = cell as? ProfileTableViewCell {
                cell.models = vm
                cell.cellSelected = {[weak self] model in
                    guard let self = self else { return }
                    self.itemSelectedPR.accept(model)
                }
            }
        }
        return cell
    }
    
    
}
extension ProfileViewController : UITableViewDelegate {}


class ProfileTableViewCell : UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
    
    var cellSelected : (ProfileItemModel) ->  () = {_ in }
    
    private lazy var containerView : UIViewNeumorphic = {
        let v = UIViewNeumorphic()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 20
        return v
    }()
    
    private lazy var collectionView : DynamicCollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 0
        let v = DynamicCollectionView(frame: .zero, collectionViewLayout: flow)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.dataSource = self
        v.delegate = self
        v.register(ProfileItemMenuCollectionViewCell.self, forCellWithReuseIdentifier: ProfileItemMenuCollectionViewCell.reuseIdentifier)
        v.backgroundColor = .clear
        return v
    }()
    
    private func prepareUI(){
        self.backgroundColor = .clear
        [collectionView].forEach(self.containerView.addSubview(_:))
        [containerView].forEach(self.contentView.addSubview(_:))
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 30),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 30),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            collectionView.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),
            
        ])
        self.layoutIfNeeded()
    }
    
    var models : [ProfileItemModel] = [] {
        didSet {
            self.collectionView.reloadData()
            self.layoutIfNeeded()
        }
    }
    
}
extension ProfileTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileItemMenuCollectionViewCell.reuseIdentifier, for: indexPath)
        let data = self.models[indexPath.item]
        if let cell = cell as? ProfileItemMenuCollectionViewCell {
            cell.model = data
            cell.cellSelected = {[weak self] d in
                guard let self = self else { return }
                self.cellSelected(d)
            }
        }
        return cell
    }
    
    
}
extension ProfileTableViewCell : UICollectionViewDelegate {
    
}
extension ProfileTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: UIScreen.main.bounds.width - 100, height: 60)
    }
}
class ProfileItemMenuCollectionViewCell : UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareUI()
    }
    
    var cellSelected : (ProfileItemModel) ->  () = {_ in }
    
    var model : ProfileItemModel? = nil {
        didSet {
            guard let model = self.model else { return }
            self.iconView.image = model.icon
            self.titleView.text = model.title
        }
    }
    
    private lazy var iconView : UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()
    private lazy var titleView : UILabel = {
        let v = UILabel()
        v.font = .regular(ofSize: 15)
        v.textColor = .black.withAlphaComponent(0.7)
        v.numberOfLines = 1
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var underlineView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return v
    }()
    private lazy var arrowImage : UIImageView = {
        let v = UIImageView(image: .init(named: "ic-right"))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.contentMode = .scaleAspectFill
        return v
    }()
    
    private func prepareUI(){
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cellTap)))
        self.backgroundColor = .clear
        [self.iconView, self.titleView, self.underlineView, arrowImage].forEach(self.contentView.addSubview(_:))
        NSLayoutConstraint.activate([
            self.iconView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0),
            self.iconView.heightAnchor.constraint(equalTo: self.iconView.widthAnchor),
            self.iconView.widthAnchor.constraint(equalToConstant: 24),
            self.iconView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            
            self.titleView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.titleView.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 15),
            
            self.underlineView.heightAnchor.constraint(equalToConstant: 1),
            self.underlineView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.underlineView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            self.underlineView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 1),
            
            
            self.arrowImage.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0),
            self.arrowImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.arrowImage.heightAnchor.constraint(equalTo: self.arrowImage.widthAnchor),
            self.arrowImage.widthAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    @objc private func cellTap(){
        guard let model = self.model else { return }
        cellSelected(model)
    }
    
}
