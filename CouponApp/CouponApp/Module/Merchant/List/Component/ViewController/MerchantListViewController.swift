//
//  MerchantListViewController.swift
//  CouponApp
//
//  Created by kim sunchul on 2022/03/25.
//  Copyright © 2022 kim sunchul. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MerchantListViewController: UITableViewController, Bindable {
  
  // MARK: - Property

  var viewModel: MerchantListViewModelType?
  var disposeBag: DisposeBag = .init()
  private let dataSource = RxTableViewSectionedReloadDataSource<MerchantListSection>(
    configureCell: { _, tableView, indexPath, item -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(
        withIdentifier: CouponIdentifier.merchantTableViewCell.rawValue,
        for: indexPath
      )

      if let merchantCell = cell as? MerchantTableViewCell {
        merchantCell.setMerchant(item)
      }

      return cell
    }
  )

  // MARK: - Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.bind()
  }

  // MARK: - Bind

  func bindInputs() {
    guard let inputs = self.viewModel?.inputs else { return }

    self.tableView.rx.itemSelected
      .compactMap { [weak self] (indexPath: IndexPath) -> MerchantSelect? in
        guard let sectionModels = self?.dataSource.sectionModels,
              sectionModels.indices ~= indexPath.section,
              sectionModels[indexPath.section].items.indices ~= indexPath.item,
              let item = self?.dataSource.sectionModels[indexPath.section].items[indexPath.item],
              let cell = self?.tableView.cellForRow(at: indexPath) as? MerchantTableViewCell,
              let contentOffset = self?.tableView.contentOffset else {
          return nil
        }

        return .init(
          cellTopViewFrame: cell.topView.frame,
          cellFrame: cell.frame,
          contentOffset: contentOffset,
          cornerRadius: cell.layer.cornerRadius,
          item: item
        )
      }
      .subscribe(inputs.selecItem)
      .disposed(by: self.disposeBag)
  }

  func bindOutputs() {
    self.tableView.dataSource = nil
    
    self.viewModel?.outputs?.reloadSections
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.tableView.rx.items(dataSource: self.dataSource))
      .disposed(by: self.disposeBag)

    self.viewModel?.outputs?.presentDetail
      .asDriver(onErrorDriveWith: .empty())
      .drive(self.rx.presentMerchantDetail)
      .disposed(by: self.disposeBag)
  }
}


extension Reactive where Base: MerchantListViewController {
  var presentMerchantDetail: Binder<MerchantDetail> {
    return Binder(self.base) { (viewController: MerchantListViewController, detail: MerchantDetail) in
      let viewModel = MerchantDetailViewModel()
      let detailViewController = MerchantDetailViewController()
      detailViewController.viewModel = viewModel
      viewModel.inputs.merchantDetail.onNext(detail)
      viewController.present(detailViewController, animated: true, completion: nil)
    }
  }
}
