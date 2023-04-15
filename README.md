# [MyCover.ai](https://www.mycover.ai/) Insurance SDK

<div align="center">
      <img title="http://MyCover.ai" height="200" src="https://www.mycover.ai/images/logos/mycover.svg" width="200px"/>
</div>

An iOS library built natively with Swift and SwiftUI, for buying insurance policies, powered by the [mycover.ai](https://www.mycover.ai/) platform.

# Installation

## Using Swift Package manager

### in your swift package file add the mycover.ai dependency
```swift

dependencies: [
    .package(url: "https://github.com/ibuildgenius/mca-ios-sdk", .upToNextMajor(from: "1.0.0"))
]

```

## Usage
Add the swift view to your app

### first add the import statement

```swift
import MyCoverAISDK

```

### then call the SwiftUI view with your API key
```swift

MyCoverAISDK(apiKey: "<YOUR-API-KEY>")

```


#### NOTE:  you can also refer to [this doc](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app) from the apple team. 
