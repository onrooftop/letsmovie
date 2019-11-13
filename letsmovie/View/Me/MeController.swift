//
//  MeController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 13/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class MeController: UICollectionViewController {
    
    private enum MePage: Int {
        case watchlist = 0, watched = 1
    }
    
    //MARK: UI Elements
    private var watchListButton = MeController.watchListButton()
    private var watchedButton = MeController.watchedButton()
    private var horizontalStackView = MeController.horizontalStackView()
    private var lineIndicatorView = MeController.lineIndicatorView()
    
    private var lineIndicatorViewLeadingConstaint: NSLayoutConstraint!
    private let cellId = "cellId"
    private let horizontalStackViewHeight: CGFloat = 50
    
    private let pages: [MePage] = [MePage.watchlist, MePage.watched]
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUIElements()
        setupView()
        setupNavigationBar()
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
        lineIndicatorView.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: -5).isActive = true

    }
    
}

//MARK:- CollectionView Delegate DataSource
extension MeController: UICollectionViewDelegateFlowLayout {
    
    private func setupCollectionViewController() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = .init(top: horizontalStackViewHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch pages[indexPath.item] {
        case .watchlist:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .red
            return cell
        case .watched:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
            cell.backgroundColor = .blue
            return cell
        }
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
        lineIndicatorViewLeadingConstaint.constant = scrollView.contentOffset.x / CGFloat(pages.count)
        let index = Int(round(scrollView.contentOffset.x / view.frame.width))
        let pageFromIndex = pages[index]
        setPageButtonsColor(with: pageFromIndex)
    }
}

//MARK:- Setup
extension MeController {
    private func setupView() {
        collectionView.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Me"
    }
}
