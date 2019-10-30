// The MIT License (MIT)
//
// Copyright (c) 2015 Meng To (meng@designcode.io)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

class SpringView: UIView, Springable {
    @IBInspectable var autostart: Bool = false
    var autohide: Bool = false
    @IBInspectable var animation: String = ""
    var force: CGFloat = 1
    @IBInspectable var delay: CGFloat = 0
    @IBInspectable var duration: CGFloat = 0.7
    var damping: CGFloat = 0.7
    var velocity: CGFloat = 0.7
    var repeatCount: Float = 1
    var x: CGFloat = 0
    var y: CGFloat = 0
    var scaleX: CGFloat = 1
    var scaleY: CGFloat = 1
    var rotate: CGFloat = 0
    var curve: String = ""
    var opacity: CGFloat = 1
    var animateFrom: Bool = false

    lazy private var spring : Spring = Spring(self)

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.spring.customAwakeFromNib()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        spring.customLayoutSubviews()
    }
    
    func animate() {
        self.spring.animate()
    }

    func animateNext(completion: @escaping () -> ()) {
        self.spring.animateNext(completion: completion)
    }

    func animateTo() {
        self.spring.animateTo()
    }

    func animateToNext(completion: @escaping () -> ()) {
        self.spring.animateToNext(completion: completion)
    }
    
    func setAnimation(_ handle: Handle = nil) {
        force = 1
        autostart = true
        alpha = 0
        animateNext {
            handle?()
        }
    }
    
    func dismissAnimation(_ handle: Handle = nil) {
        alpha = 1
        force = 1
        autostart = true
        animateToNext {
            handle?()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if autostart {
            setAnimation(nil)
        }
    }
}
