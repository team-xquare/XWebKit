# XWebKit
<img src="https://user-images.githubusercontent.com/67373938/217841382-38f34bb2-904c-459d-9869-5969e62f79ce.png" width="100px"></img>

## Usage
```swift
import SwiftUI
import XWebKit

...

NavigationView {
   XWebKitView(
      urlString: <URLString of webview>,
      accessTokenGetter: { <Access token> }
   )
}
.navigationViewStyle(.stack)

```
