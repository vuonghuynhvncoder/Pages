<p align="center">
  <img src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/banner.png" height=58 width=182/>
</p>
<p align="center">
    <strong><a href="#getting-started">Getting Started</a></strong> |
    <strong><a href="#customization">Customization</a></strong> |
    <strong><a href="#installation">Installation</a></strong>
</p>

<br/>

<p align="middle">
  <img src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/art-demo.gif" data-canonical-src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/art-demo.gif" width="200"/>
        
  <img src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/onboarding-demo.gif" data-canonical-src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/onboarding-demo.gif" width="200"/>
  
  <img src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/book-preview.gif" data-canonical-src="https://github.com/nachonavarro/PagesDemo/blob/master/Screenshots/book-preview.gif" width="200"/>
</p>

## Getting Started

### Basic usage

Using Pages is as easy as:

```swift
Pages {
    Text("A page here...")             // First page
    Text("...and a page there")        // Second page
    Circle()                           // Third page
        .fill(Color.blue)
        .frame(width: 50, height: 50)
    VStack {                           // Fourth page
        Capsule()
            .fill(Color.yellow)
            .frame(width: 100, height: 300)
        Text("A capsule on the fourth page")
            .font(.title)
            .padding(.top)
    }
}
```

One can also use Pages with dynamic content:

```swift
struct Car {
    var model: String
}

let cars = [Car(model: "Ford"), Car(model: "Ferrari")]

ModelPages(cars) { index, car in
    Text("The \(index) car is a \(car.model)")
        .padding(50)
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(10)
}
```

### How it works

`Pages` uses a [function builder](https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md) to accomplish a SwiftUI
feel while using a `UIPageViewController` under the hood. As in `VStack` or `HStack`, the current limit of pages to
add in a static way using the `Pages` view is 10. If more are needed use a `ModelPages` instead. The `Pages` view will take up all the available space it is given.

> Note: The `Pages` view needs more than one page. Otherwise the compiler treats what's inside `Pages` as [a closure](https://stackoverflow.com/questions/58409839/function-builder-not-working-when-only-one-value).

## Customization

The following aspects of `Pages` can be customized:

- `navigationOrientation`: Whether to paginate horizontally or vertically. Default is `.horizontal`.

```swift
Pages(navigationOrientation: .vertical) {
    Text("Page 1")
    Text("Page 2")
}
```

- `transitionStyle`: Whether to perform a page curl or a scroll effect on page turn. The first two examples in the GIFs above use a scroll effect, and the last one uses page curl. Default is `.scroll`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl
) {
    Text("Page 1")
    Text("Page 2")
}
```

- `bounce`: Whether to perform a bounce effect when the user tries to scroll past the number of pages. Default is `true`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl,
    bounce: false
) {
    Text("Page 1")
    Text("Page 2")
}
```

- `wrap`: Whether to wrap the pages once a user tries to go to the next page after the last page. Similarly whether
to go to the last page when the user scrolls to the previous page of the first page. Default is `false`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl,
    bounce: false,
    wrap: true
) {
    Text("Page 1")
    Text("Page 2")
}
```

- `hasControl`: Whether to display a page control or not. Default is `true`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl,
    bounce: false,
    wrap: true,
    hasControl: false
) {
    Text("Page 1")
    Text("Page 2")
}
```

- `control`: A user-defined control if one wants to tune it. If this field is not provided and `hasControl` is `true` then 
the classical iOS page control will be used. Note `control` must conform to `UIPageControl`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl,
    bounce: false,
    wrap: true,
    control: MyPageControl()
) {
    Text("Page 1")
    Text("Page 2")
}
```

- `controlAlignment`: Where to put the page control inside `Pages`. Default is `.bottom`.

```swift
Pages(
    navigationOrientation: .vertical,
    transitionStyle: .pageCurl,
    bounce: false,
    wrap: true,
    controlAlignment: .topLeading
) {
    Text("Page 1")
    Text("Page 2")
}
```

## Demos

All of the demos shown on the GIF can be checked out on the [demo repo](https://github.com/nachonavarro/PagesDemo).

## Installation

Pages is available using the [Swift Package Manager](https://swift.org/package-manager/):

Using Xcode 11, go to `File -> Swift Packages -> Add Package Dependency` and enter https://github.com/nachonavarro/Pages


## Requirements

- iOS 13.0+
- Xcode 11.0+

## Contributing

Feel free to contribute to `Pages`!

1. Fork `Pages`
2. Create your feature branch with your changes
3. Create pull request

## License

`Pages` is available under the MIT license. See the [LICENSE](https://github.com/nachonavarro/Pages/blob/master/LICENSE) for more info.
