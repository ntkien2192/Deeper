//
//  Start.swift
//  Futurep
//
//  Created by Nguyễn Trung Kiên on 8/6/19.
//  Copyright © 2019 Nguyễn Trung Kiên. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

public class Start: Application {
    
    public let store = StartStore.share
    
    public class func on() -> Start? {
        let app = Start()
        return app
    }
    
    public func setup(_ handle: ((StartStore) -> Void)? = nil) -> Start {
        handle?(store)
        return self
    }
    
    override init() {
        super.init()
        
        let theme = store.database.metadata.theme.value
        
        switch theme {
        case .deeper:
            let view = Storyboard.start.get(StartViewController.self)!
            _ = view.wake().on(completed: { [weak self] in
                _ = self?.store.imageUrl.on({ imageUrl in
                    view.imageView.set(imageUrl)
                })
                _ = self?.store.image.on({ image in
                    view.imageView.set(placeholder: image)
                })
                
            })
            
            let screen = Screen(.onNavigation(view, hideNavigationBar: true))
            _ = store.animation.to(screen.animation)
            prepare(screen)
        }
    }
}
