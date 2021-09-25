//
//  TestPageViewController.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 23/09/2021.
//

import Foundation
import UIKit
import RxAppState
import RxCocoa
class TestPageViewController : BaseViewController<TestPageViewModel> {
    override func buildViewModel() -> TestPageViewModel {
        return TestPageViewModel()
    }
    
    private lazy var textFieldSearch : UITextField = {
        let v = UITextField()
        v.placeholder = "Search..."
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private lazy var tableView : UITableView = {
        let v = UITableView()
        v.register(TestCell.self, forCellReuseIdentifier: "TestCell")
        v.rowHeight = UITableView.automaticDimension
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    override func performBinding() {
        super.performBinding()
        let output = viewModel.transform(input: .init(viewWillAppear: self.rx.viewWillAppear.take(1).mapToVoid().asDriverOnErrorJustComplete(), textSearch: self.textFieldSearch.rx.text.orEmpty))
        
        self.tableView.rx.itemSelected.asDriver().drive(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: self.disposeBag)
        
        self.tableView.rx.itemDeselected.asDriver().drive(onNext: { indexPath in
            print(indexPath)
        }).disposed(by: self.disposeBag)
        
        
        output.items.drive(self.tableView.rx.items){ (tv, row, item) -> UITableViewCell in
            let cell = tv.dequeueReusableCell(withIdentifier: "TestCell", for: .init(row: row, section: 0))
            if let cell = cell as? TestCell {
                cell.viewModel = item
            }
            return cell
        }.disposed(by: self.disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        [tableView, textFieldSearch].forEach({self.view.addSubview($0)})
        NSLayoutConstraint.activate([
            self.textFieldSearch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            
            self.textFieldSearch.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.textFieldSearch.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.textFieldSearch.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.textFieldSearch.heightAnchor.constraint(equalToConstant: 50),
        
            
            self.tableView.topAnchor.constraint(equalTo: self.textFieldSearch.bottomAnchor, constant: 10),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
    }
}
