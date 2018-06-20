//
//  BottomSheetDelegate.swift
//  BottomSheet
//
//  Created by Marco Capano on 18/06/2018.
//  Copyright © 2018 Marco Capano. All rights reserved.
//

import Foundation

public protocol BottomSheetDelegate: class {
    func sheetDidReachTop()
    func sheetDidReachBottom()
}
