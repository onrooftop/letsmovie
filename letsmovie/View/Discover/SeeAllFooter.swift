//
//  SeeAllFooter.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 19/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class SeeAllFooter: UICollectionReusableView {
    
    var activityIndicatorView = SeeAllFooter.activityIndicatorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK:- UI Element
extension SeeAllFooter {
    private func setupView() {
        backgroundColor = .systemGroupedBackground
        addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    class func activityIndicatorView() -> UIActivityIndicatorView{
        let av = UIActivityIndicatorView(style: .large)
        av.startAnimating()
        return av
    }
}
