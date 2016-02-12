### SPTinderView
[![build-status](https://travis-ci.org/freesuraj/SPTinderView.svg?branch=master)](https://travis-ci.org/freesuraj/SPTinderView)
[![Twitter](https://img.shields.io/badge/twitter-@iosCook-blue.svg?style=flat)](http://twitter.com/iosCook)
[![CocoaPods](https://img.shields.io/cocoapods/v/SPTinderView.svg)]()

A clone of standard Tinder app's swipe left swipe right view

![screenshot](https://github.com/freesuraj/SPTinderView/blob/master/assets/screenshot.gif?raw=true)

#### Installation
###### CocoaPods
      pod SPTinderView
###### Manual:
  Copy the swift files in `Source` directory

#### Usage
There are two main classes:
`SPTinderView` is a subclass of `UIView` which acts as the container for all the _cards_ (aka Cells) in the tinder view. The _card_ is represented by `SPTinderViewCell` class which is also a subclass of `UIView`.

It can be used similar to how a `UITableView` is used with `SPTinderView` being equivalent to `UITableView` and `SPTinderViewCell` being equivalent to `UITableViewCell`

- Add `SPTinderView` to your view, set the `delegate` and `dataSource`
- Set your custom cell by subclassing `SPTinderViewCell`
- Register this class or nib to the `SPTinderView` using the method `registerClass: forIdentifier: ` or `registerNib: forIdentifier:`
- Implement the `dataSource` and `delegate` methods.

#### Example
This example can be found in the project as well.

1. Define Custom `SPTinderViewCell`

```objective-c
class MyTinderCell: SPTinderViewCell {
    let titleLabel: UILabel = UILabel(frame: CGRectZero)
    let imageView: UIImageView = UIImageView(frame: CGRectZero)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    required init(reuseIdentifier: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.frame = CGRect(origin: CGPointZero, size: CGSize(width: 300, height: 400))
        titleLabel.frame = CGRectMake(0, self.frame.height - 50, self.frame.width, 50)
        imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.height - 50)
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        titleLabel.textAlignment = .Center
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }
}
```

2. Set `SPTinderView` and set `dataSoruce` and `delegate`
```objective-c
class ViewController: UIViewController {
    @IBOutlet var tinderView: SPTinderView!
    let cellIdentifier = "MyTinderCell"

    override func viewDidLoad() {
        super.viewDidLoad()
        tinderView.frame = self.view.frame
        tinderView.registerClass(MyTinderCell.self, forCellReuseIdentifier: cellIdentifier)
        tinderView.dataSource = self
        tinderView.delegate = self
        tinderView.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
```
3. Implement the `dataSource` and `delegate` methods
```objective-c
extension ViewController: SPTinderViewDataSource, SPTinderViewDelegate {
    func numberOfItemsInTinderView(view: SPTinderView) -> Int {
        return 20
    }

    func tinderView(view: SPTinderView, cellAt index: Int) -> SPTinderViewCell? {
        if let cell = tinderView.dequeueReusableCellWithIdentifier(cellIdentifier) as? MyTinderCell {
            cell.titleLabel.text = "Model No: \(index+1)"
            cell.imageView.image = TinderModel.randomImage()
            return cell
        }
        return nil
    }

    func tinderView(view: SPTinderView, didMoveCellAt index: Int, towards direction: SPTinderViewCellMovement) {
        print("\(direction)")
    }
}
```

#### Contribution

All the contributions are welcome ! Fork, change and send a pull request.
