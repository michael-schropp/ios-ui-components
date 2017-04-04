# ios-ui-components
This is a repository to provide reusable components for iOS development


## FanControl

![With Images](https://github.com/michael-schropp/ios-ui-components/blob/master/screenshots/Fan1.gif)
![With Titles](https://github.com/michael-schropp/ios-ui-components/blob/master/screenshots/Fan2.gif)

### Usage

```swift
override func viewDidLoad() {
    super.viewDidLoad()

	let fanControl = FanControl.init(frame: CGRect.init(x: 0, y: 0, width: 50, height: 50))
	fanControl.setupWithTitles(["add", "fav", "delete"])
	fanControl.addTarget(self, action: #selector(ViewController.fanControlDidChoose(_:)), for: .valueChanged)
	view.addSubview(fanControl)
}
```   
Instead of strings for the title you can can aso use images

```swift
fanControl.setupWithImages([
	#imageLiteral(resourceName: "clip"),
	#imageLiteral(resourceName: "empty"),
	#imageLiteral(resourceName: "cloud")
])
```

The action is invoked when the user selects one item

```swift
func fanControlDidChoose(_ fanControl:FanControl) {
    dump(fanControl.selectedIndex)
}
```

### Configuration

```swift

/** the tintColor of the FanControl is used to highlight the items
 /*
var tintColor:UIColor

/** position of first item. default is above view
 value is in degrees. 0 would be right, 90 top and 180 is left
 from center. default is 135
 /*
var startAngle:CGFloat

/** returns last segment pressed. default is -1 if no segment is pressed
 */
var selectedIndex: Int

/** size of the items, default is {50,50}
 */
var itemSize:CGSize

/** radius where items are positioned. default is 100
 */
var radius:CGFloat

/** backgroundColor of items. Default is lightGray
 */
var itemColor
```