//
//  NavControllerRemoveBackText.swift
//  RvChecklistCDi
//
//  Created by Ron Lisle on 7/27/21.
//

import SwiftUI

extension UINavigationController {
    // Remove back button text
    open override func viewWillLayoutSubviews() {
        navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
