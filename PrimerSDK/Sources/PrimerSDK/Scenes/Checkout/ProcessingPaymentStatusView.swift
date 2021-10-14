//
//  File.swift
//  
//
//  Created by Fernando Menendez on 14/10/2021.
//

import Foundation
import UIKit

class ProcessingPaymentStatusView : UIView {
    
    var imageView : UIImageView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                            width: 80, height: 80))
    var label : UILabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                width: 100, height: 100))
    
    var stackView : UIStackView = UIStackView()
    
    var state : CheckoutStates = .ready {
        didSet {
            switch state {
            case .success:
                imageView.image = UIImage(systemName: "checkmark.circle")
                imageView.tintColor = .systemGreen
                configureFinishState()
            case .error:
                imageView.image = UIImage(systemName: "xmark.circle")
                imageView.tintColor = .systemRed
                configureFinishState()
            case .ready:
                break
            case .processing:
                configureProcessingState()
            }
        }
    }
    
    override func layoutSubviews() {
        self.backgroundColor = Primer.shared.theme.colorTheme.background
        stackView.backgroundColor = .clear
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        stackView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(label)
        imageView.widthAnchor.constraint(equalToConstant: 80.0)
            .isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80.0)
            .isActive = true
    }
    
    private func configureProcessingState() {
        imageView.image = UIImage(systemName: "arrow.triangle.2.circlepath.circle")
        imageView.tintColor = .systemBlue
        label.text = "Loading..."
        
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 1.2, 1.0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 1.5
        animation.repeatCount = Float.infinity
        
        let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotation.toValue = Double.pi * 2.0
        rotation.duration = 1
        rotation.isCumulative = true
        rotation.repeatCount = .greatestFiniteMagnitude
        
        imageView.layer.add(animation, forKey: "scaleAnimation")
        imageView.layer.add(rotation, forKey: "rotation")
    }
    
    private func configureFinishState() {
        label.isHidden = true
        imageView.layer.removeAllAnimations()
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values = [1.0, 3.0, 1.0]
        animation.keyTimes = [0, 0.5, 1]
        animation.duration = 0.7
        animation.repeatCount = Float.infinity
        imageView.layer.add(animation, forKey: nil)
    }
}
