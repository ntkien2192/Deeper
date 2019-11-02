# Deeper

[![CI Status](https://img.shields.io/travis/ntkien2192/Deeper.svg?style=flat)](https://travis-ci.org/ntkien2192/Deeper)
[![Version](https://img.shields.io/cocoapods/v/Deeper.svg?style=flat)](https://cocoapods.org/pods/Deeper)
[![License](https://img.shields.io/cocoapods/l/Deeper.svg?style=flat)](https://cocoapods.org/pods/Deeper)
[![Platform](https://img.shields.io/cocoapods/p/Deeper.svg?style=flat)](https://cocoapods.org/pods/Deeper)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

Deeper is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Deeper'
```
### Step 1

Import Deeper to  AppDelegate
```
import UIKit
import Deeper

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
```

 or SceneDelegate
```
import UIKit
import Deeper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
```

### Step 2

Use it your way
```
let theme = Theme.hemera

Deeper.on(window, theme: theme) {
    _ = Deeper .open(Start.on())
}
```

Add the following command if you use SceneDelegate
```
guard let window = window else { return }
```


## Author

ntkien2192, ntkien2192@gmail.com

## License

Deeper is available under the MIT license. See the LICENSE file for more info.
