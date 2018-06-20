//
//  ViewController+Extension.swift
//  BottomSheetProject
//
//  Created by Marco Capano on 15/06/2018.
//  Copyright © 2018 Marco Capano. All rights reserved.
//

import Foundation
import UIKit

public extension UIViewController {
    
    public func add(_ child: UIViewController) {
        addChildViewController(child)
        view.addSubview(child.view)
        child.didMove(toParentViewController: self)
    }
    
    public func remove() {
        guard parent != nil else {
            return
        }
        
        willMove(toParentViewController: nil)
        removeFromParentViewController()
        view.removeFromSuperview()
    }
    
    @discardableResult
    public func addBottomSheet(_ contentViewController: UIViewController) -> BottomSheetViewController {
        let bottomSheet = BottomSheetViewController(contentViewController)
        let height = view.frame.height
        let width  = view.frame.width
        bottomSheet.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
        
        add(bottomSheet)
        return bottomSheet
    }
}
