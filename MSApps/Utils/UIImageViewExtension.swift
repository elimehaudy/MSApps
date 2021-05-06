//
//  UIImageViewExtension.swift
//  MSApps
//
//  Created by Eli Mehaudy on 03/05/2021.
//

import UIKit

extension UIImageView {
    func loadImageFromURL(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
