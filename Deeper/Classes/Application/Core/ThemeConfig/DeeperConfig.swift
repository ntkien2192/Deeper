//
//  ThemeConfig.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/18/19.
//

import UIKit
import RxSwift
import RxRelay

public class DeeperConfig: NSObject {
    let theme = BehaviorRelay<Theme>(value: .none)
    
    public func set(theme: Theme) {
        self.theme.accept(theme)
    }
}
