//
//  FooterView.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 28/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private var activityIndicatorView = FooterView.activityIndicatorView()
    
    init() {
        var viewFrame: CGRect = .zero
        viewFrame.size.height = 50
        super.init(frame: viewFrame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}

extension FooterView {
    private func setupView() {
        backgroundColor = .systemBackground
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
