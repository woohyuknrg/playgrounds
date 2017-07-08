//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

/*
class MyClass: NSObject {
    dynamic var date = NSDate()
}

class ViewController: UIViewController {

    private var myContext = 0

    var myObject: MyClass!

    override func viewDidLoad() {
        super.viewDidLoad()

        myObject = MyClass()
        print("MyClass init. Date: \(myObject.date)")
        myObject.addObserver(self,
                             forKeyPath: "date",
                             options: .new,
                             context: &myContext)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.myObject.date = NSDate()
        }
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == &myContext {
            print("Date is changed. \(change?[NSKeyValueChangeKey.newKey] ?? "")")
        }
    }

    deinit {
        myObject.removeObserver(self, forKeyPath: "date")
    }
}

ViewController().view
*/

@objcMembers class Foo: NSObject {
    dynamic var string = "hotdog"
}

let foo = Foo()
foo.observe(\.string) { (foo, change) in
    print("new foo.string: \(foo.string)")
}

foo.string = "not hotdog"
