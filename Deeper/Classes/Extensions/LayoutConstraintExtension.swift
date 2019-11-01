//
//  LayoutConstraintExtension.swift
//  Deeper
//
//  Created by Nguyễn Trung Kiên on 11/1/19.
//

import UIKit

extension Array where Element: NSLayoutConstraint {
    func get(_ attribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint? {
        for constraint in self {
            if constraint.firstAttribute == attribute {
                return constraint
            }
        }
        return nil
    }
}
