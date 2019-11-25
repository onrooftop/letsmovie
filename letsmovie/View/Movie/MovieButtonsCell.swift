//
//  MovieButtonsCell.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 21/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit
import RxSwift
import Action
import RxCocoa

class MovieButtonsCell: UICollectionViewCell, UsableViewModel{
    
    private let disposeBag = DisposeBag()
    
    var watchlistButton = MovieButtonsCell.createButton(title: "Watchlist")
    var watchedButton = MovieButtonsCell.createButton(title: "Watched")
    
    private let minimunLineSpacing: CGFloat = 10
    private let buttonSpacing: CGFloat = 12
    private lazy var stackViewPadding: UIEdgeInsets = {
        return .init(top: self.minimunLineSpacing, left: self.buttonSpacing / 2, bottom: 0, right: -self.buttonSpacing / 2)
    }()
    
    private lazy var halfWidth: CGFloat = {
        return self.frame.width / 2
    }()
    
    private var buttonHeight: CGFloat {
        return self.frame.height - self.minimunLineSpacing
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var viewModel: MovieButtonsViewModel!
    var bindedViewModel: ViewModelType!
    func bindViewModel() {
        viewModel = (bindedViewModel as? MovieButtonsViewModel)
        
        watchlistButton.rx.action = viewModel.watchlistAction
        
        watchedButton.rx.action = viewModel.watchedAction
        
        viewModel.buttonsStatus
            .subscribe(onNext: { [unowned self] (status) in
                self.buttonsAnimate(buttonStatus: status)
            })
            .disposed(by: disposeBag)
    }

    
    private var rightSpaceWidthConstraint: NSLayoutConstraint!
    private var watchlistTrailingConstraint: NSLayoutConstraint!
    private var watchedTrailingConstraint: NSLayoutConstraint!
    
    private func buttonsAnimate(buttonStatus: ButtonStatus) {

        var watchedButtonAlpha: CGFloat = 1
        var watchlistButtonAlpha: CGFloat = 1
        //Watchlist Full Screen
        if !buttonStatus.isWatchlistHidden && buttonStatus.isWatchedHidden {
            rightSpaceWidthConstraint.constant = 0
            watchlistTrailingConstraint.constant = stackViewPadding.right
            watchedTrailingConstraint.constant = -stackViewPadding.right
            watchedButtonAlpha = 0
            watchlistButtonAlpha = 1
        }
        //Watched Full Screen
        else if buttonStatus.isWatchlistHidden && !buttonStatus.isWatchedHidden {
            rightSpaceWidthConstraint.constant = frame.width
            watchlistTrailingConstraint.constant = -stackViewPadding.right
            watchedTrailingConstraint.constant = stackViewPadding.right
            
            watchedButtonAlpha = 1
            watchlistButtonAlpha = 0
        }
        // show both
        else {
            rightSpaceWidthConstraint.constant = halfWidth
            watchlistTrailingConstraint.constant = stackViewPadding.right
            watchedTrailingConstraint.constant = stackViewPadding.right
            
            watchedButtonAlpha = 1
            watchlistButtonAlpha = 1
        }
        
        if !buttonStatus.shouldAnimate {
            self.watchedButton.alpha = watchedButtonAlpha
            self.watchlistButton.alpha = watchlistButtonAlpha
            return
        }

        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.watchedButton.alpha = watchedButtonAlpha
            self.watchlistButton.alpha = watchlistButtonAlpha
        }, completion: nil)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
    }

}

//MARK: UI Elements
extension MovieButtonsCell {
    private func setupView() {
        backgroundColor = .white
        let rightSpaceView = UIView()
        
        addSubview(watchlistButton)
        addSubview(rightSpaceView)
        rightSpaceView.addSubview(watchedButton)
        
        watchlistButton.layer.cornerRadius = buttonHeight / 2
        watchedButton.layer.cornerRadius = buttonHeight / 2
        
        watchlistButton.translatesAutoresizingMaskIntoConstraints = false
        watchedButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        rightSpaceView.backgroundColor = .clear
        rightSpaceView.translatesAutoresizingMaskIntoConstraints = false
        
        rightSpaceWidthConstraint = rightSpaceView.widthAnchor.constraint(equalToConstant: halfWidth)
        NSLayoutConstraint.activate([
            rightSpaceView.heightAnchor.constraint(equalToConstant: frame.height),
            rightSpaceView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightSpaceView.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightSpaceWidthConstraint
        ])
        
        watchlistTrailingConstraint = watchlistButton.rightAnchor.constraint(equalTo: rightSpaceView.leftAnchor, constant: stackViewPadding.right)
        
        watchedTrailingConstraint = watchedButton.trailingAnchor.constraint(equalTo: rightSpaceView.trailingAnchor, constant: stackViewPadding.right)
        
        NSLayoutConstraint.activate([
            watchlistButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            watchlistButton.topAnchor.constraint(equalTo: topAnchor, constant: minimunLineSpacing),
            watchlistButton.leftAnchor.constraint(equalTo: leftAnchor, constant: stackViewPadding.left),
            watchlistTrailingConstraint,
            
            watchedButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            watchedButton.topAnchor.constraint(equalTo: rightSpaceView.topAnchor, constant: minimunLineSpacing),
            watchedButton.leftAnchor.constraint(equalTo: rightSpaceView.leftAnchor, constant: stackViewPadding.left),
            watchedTrailingConstraint
        ])

//        horizontalStackView.addArrangedSubview(watchlistButton)
//        horizontalStackView.addArrangedSubview(watchedButton)
//        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
//        horizontalStackView.spacing = buttonSpacing
//        addSubview(horizontalStackView)
//        NSLayoutConstraint.activate([
//            horizontalStackView.topAnchor.constraint(equalTo: topAnchor, constant: stackViewPadding.top),
//            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: stackViewPadding.left),
//            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: stackViewPadding.right),
//        ])
        
        
        
    }
    
    class func createButton(title: String) -> UIButton {
        let bt = UIButton(type: UIButton.ButtonType.system)
        bt.setTitle(title, for: .normal)
        bt.layer.borderColor = UIColor.black.cgColor
        bt.layer.borderWidth = 2
        bt.backgroundColor = .white
        bt.setTitleColor(.black, for: .normal)
        bt.setTitleColor(.white, for: .highlighted)
        bt.titleLabel?.font = .boldSystemFont(ofSize: 18)
        bt.clipsToBounds = true
        return bt
    }
    
    class func horizontalStackView() -> UIStackView {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.alignment = .center
        return sv
    }
}
