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
}

extension Storyboard {
    func get<T>(_ type: T.Type) -> T? {
        let podBundle = Bundle(for: Deeper.self)
        guard let bundleURL = podBundle.url(forResource: "Deeper", withExtension: "bundle"), let bundle = Bundle(url: bundleURL) else {
            return nil
        }
        
        return UIStoryboard(name: self.rawValue, bundle: bundle)
            .instantiateViewController(withIdentifier: String(describing: type)) as? T
    }
}
