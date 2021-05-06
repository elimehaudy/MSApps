//
//  UIViewControllerExtension.swift
//  MSApps
//
//  Created by Eli Mehaudy on 05/05/2021.
//

import UIKit

extension UIViewController {
    func viewControllerIsVisible(_ viewController: UIViewController) -> Bool{
        return viewController.navigationController?.topViewController == viewController
    }
}
