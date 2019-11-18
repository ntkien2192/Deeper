//
//  Storyboard.swift
//  SOA
//
//  Created by Nguyễn Trung Kiên on 11/23/18.
//  Copyright © 2018 Whale Land. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case start = "Start"
    case welcome = "Welcome"
}

extension Bundle {
    static var deeperBundle: Bundle? {
        let podBundle = Bundle(for: Deeper.self)
        guard let bundleURL = podBundle.url(forResource: "Deeper", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            return nil
        }
        return bundle
    }
}

extension Storyboard {
    func get<T>(_ type: T.Type) -> T? {
        guard let bundle = Bundle.deeperBundle else {
            return nil
        }
        return UIStoryboard(name: self.rawValue, bundle: bundle)
            .instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
