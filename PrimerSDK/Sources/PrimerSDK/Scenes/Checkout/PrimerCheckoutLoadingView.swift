//
//  PrimerCheckoutLoadingView.swift
//  
//
//  Created by Fernando Menendez on 13/10/2021.
//

import Foundation
import UIKit

class PrimerCheckoutLoadingView : UIView {
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10,
                                                                 y: 5,
                                                                 width: 50,
                                                                 height: 50))
    
    
    var loadingTintColor : UIColor = .systemGreen
    
    override func layoutSubviews() {
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        loadingIndicator.tintColor = loadingTintColor
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(loadingIndicator)
        loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    }
}
