//
//  UIImage.swift
//  Nas
//
//  Created by Ye Lin Aung on 15/08/2025.
//

import UIKit

extension UIImage {
    
    static func getPlaceholder(
        size: CGSize,
        color: UIColor = UIColor.red,
        iconRatio: CGFloat = 0.1,
        iconCenter: Bool = false
    ) -> UIImage? {
        
        let view = UIView(frame: CGRect(origin: .zero, size: size))
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [color.withAlphaComponent(0.7).cgColor, color.cgColor]
        view.layer.addSublayer(gradientLayer)
        
        let icon: UIImage = .launchScreen
        let iconImageView = UIImageView(image: icon)
        iconImageView.contentMode = .scaleAspectFit
        let iconSize = size.width * iconRatio
        
        if iconCenter {
            let x = (size.width - iconSize) / 2
            let y = (size.height - iconSize) / 2
            iconImageView.frame = CGRect(x: x, y: y, width: iconSize, height: iconSize)
        } else {
            iconImageView.frame = CGRect(x: size.width - iconSize - 12, y: 12, width: iconSize, height: iconSize)
        }
        
        view.addSubview(iconImageView)
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        if let context = UIGraphicsGetCurrentContext() {
            view.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        
        return nil
        
    }
    
}
