//
//  CreditController.swift
//  letsmovie
//
//  Created by Panupong Kukutapan on 29/11/2562 BE.
//  Copyright © 2562 Panupong Kukutapan. All rights reserved.
//

import UIKit

class CreditController: UIViewController {
    
    private var tmdbLogo = CreditController.tmdbLogo()
    private var tmdbAttributionText = CreditController.tmdbAttributionText()
    private var iconCredit = CreditController.iconCredit()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
}

//MARK:- UI Elements
extension CreditController {
    private func setupView() {
        view.backgroundColor = .systemBackground
        
        tmdbLogo.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tmdbLogo)
        NSLayoutConstraint.activate([
            tmdbLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tmdbLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -220),
            tmdbLogo.widthAnchor.constraint(equalToConstant: 128),
            tmdbLogo.heightAnchor.constraint(equalToConstant: 128)
        ])
        
        tmdbAttributionText.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tmdbAttributionText)
        NSLayoutConstraint.activate([
            tmdbAttributionText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            tmdbAttributionText.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            tmdbAttributionText.topAnchor.constraint(equalTo: tmdbLogo.bottomAnchor, constant: 20)
        ])
        
        iconCredit.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconCredit)
        NSLayoutConstraint.activate([
            iconCredit.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            iconCredit.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70),
            iconCredit.topAnchor.constraint(equalTo: tmdbAttributionText.bottomAnchor, constant: 100)
        ])
    }
    
    class func tmdbLogo() -> UIImageView {
        let iv = UIImageView()
        iv.image = UIImage(named: "tmdbLogo")
        iv.contentMode = .scaleAspectFill
        return iv
    }
    
    class func tmdbAttributionText() -> UILabel {
        let lb = UILabel()
        lb.text = "This product uses the TMDb API but is not endorsed or certified by TMDb."
        lb.font = .systemFont(ofSize: 18)
        lb.textColor = .label
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }
    
    class func iconCredit() -> UILabel {
        let lb = UILabel()
        lb.text = "Icons made by Gregor Cresnar from www.flaticon.com"
        lb.font = .systemFont(ofSize: 18)
        lb.textColor = .label
        lb.numberOfLines = 0
        lb.textAlignment = .center
        return lb
    }
}
