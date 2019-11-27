//
//  MeController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

enum MePage: Int {
    case watchlist = 0, watched = 1
    
    func userMovieStatusCompare(with status: UserMovie.UserMovieStatus) -> Bool {
        switch status {
        case .watchlist:
            if self == .watchlist {
                return true
            }
        case .watched:
            if self == .watched {
                return true
            }
        case .none:
            return false
        }
        
        return false
    }
}

class MeController: UICollectionViewController, UsableViewModel{
    
    private let disposeBag = DisposeBag()
    
    //MARK: UI Elements
    private var watchListButton = MeController.watchListButton()
    private var watchedButton = MeController.watchedButton()
    private var horizontalStackView = MeController.horizontalStackView()
    private var lineIndicatorView = MeController.lineIndicatorView()
    
    private var lineIndicatorViewLeadingConstaint: NSLayoutConstraint!
    private let horizontalStackViewHeight: CGFloat = 50
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionView.contentInset = .init(top: horizontalStackViewHeight, left: 0, bottom: 0, right: 0)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        setupView()
        setupCollectionViewController()
        addTargetButtons()
    }
    
    private func addTargetButtons() {
        watchListButton.addTarget(self, action: #selector(watchListButtonHandler), for: .touchUpInside)
        watchedButton.addTarget(self, action: #selector(watchedButtonHandler), for: .touchUpInside)
    }
    
    @objc
    private func watchListButtonHandler() {
        scrollToPage(page: .watchlist)
    }
    
    @objc
    private func watchedButtonHandler() {
        scrollToPage(page: .watched)
    }
    
    private func scrollToPage(page: MePage) {
        let indexPath = IndexPath(item: page.rawValue, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }
    
    private func setPageButtonsColor(with page: MePage) {
        watchListButton.setTitleColor(page == .watchlist ? .black : .darkGray, for: .normal)
        watchedButton.setTitleColor(page == .watchlist ? .darkGray : .black, for: .normal)
    }
    
    var viewModel: MeViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MeViewModel)
    
        let dataSource = createDataSource()
        
        collectionView.delegate = nil
        collectionView.dataSource = nil
        
        viewModel.sectionViewModels
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.selectedMovie
            .subscribe(onNext: { [unowned self] (movieViewModel) in
                var movieVC = MovieController()
                movieVC.bind(viewModel: movieViewModel)
                movieVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(movieVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
}

//MARK:- UI Elements
extension MeController {
    class func watchListButton() -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle("Watchlist", for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 20)
        bt.setTitleColor(.black, for: .normal)
        return bt
    }
    
    class func watchedButton() -> UIButton {
        let bt = UIButton(type: .system)
        bt.setTitle("Watched", for: .normal)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 20)
        bt.setTitleColor(.darkGray, for: .normal)
        return bt
    }
    
    class func horizontalStackView() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }
    
    class func lineIndicatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }
    
    private func setupUIElements() {

        horizontalStackView.addArrangedSubview(watchListButton)
        horizontalStackView.addArrangedSubview(watchedButton)
        
        view.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            horizontalStackView.heightAnchor.constraint(equalToConstant: horizontalStackViewHeight)
        ])
        
        view.addSubview(lineIndicatorView)
        lineIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        lineIndicatorViewLeadingConstaint = lineIndicatorView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        lineIndicatorViewLeadingConstaint.isActive = true
        lineIndicatorView.widthAnchor.constraint(equalToConstant: view.frame.width / 2).isActive = true
        lineIndicatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
        lineIndicatorView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: -10).isActive = true

    }
    
}
//MARK:- RxDatasource
extension MeController {
    func createDataSource() -> RxCollectionViewSectionedReloadDataSource<SectionViewModel> {
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionViewModel>(configureCell: { (dataSource, collectionView, indexPath, viewModel) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MePosterViewModel.cellIdentifier, for: indexPath)
            if var cell = cell as? ViewModelBindableType {
                cell.bind(viewModel: viewModel)
            }
            return cell
        })
        
        return dataSource
    }
}

//MARK:- CollectionView Delegate DataSource
extension MeController: UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionViewController() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: MePosterViewModel.cellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let safeAreaTop = UIApplication.shared.windows.filter{ $0.isKeyWindow }.first?.safeAreaInsets.top ?? 0
        let navHeight = navigationController?.navigationBar.frame.height ?? 0
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        let horizontalStackViewHeight = horizontalStackView.frame.height
        let height = view.frame.height
            - safeAreaTop
            - navHeight
            - tabBarHeight
            - horizontalStackViewHeight
        return .init(width: view.frame.width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        lineIndicatorViewLeadingConstaint.constant = scrollView.contentOffset.x / CGFloat(viewModel.mePages.count)
        var index = Int(round(scrollView.contentOffset.x / view.frame.width))
        index = max(0, index)
        index = min(index, viewModel.mePages.count - 1)
        let pageFromIndex = viewModel.mePages[index].pageType
        setPageButtonsColor(with: pageFromIndex)
    }
}

//MARK:- Setup
extension MeController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Me"
    }
}
