//: Playground - noun: a place where people can play

import Foundation

let demo = Demo()

print("start new thread")
Thread.detachNewThreadSelector(#selector(Demo.runOnNewThread), toTarget: demo, with: nil)
while !demo.end {
    print("runloop")
    RunLoop.current.run(mode: .defaultRunLoopMode, before: Date.distantFuture)
    print("runloop end")
}
print("ok")

class Demo: NSObject {

    var end = false

    func runOnNewThread() {
        print("run for new thread")
        sleep(1)
        self.performSelector(onMainThread: #selector(self.setEnd), with: nil, waitUntilDone: false)
        print("end")
    }

    func setEnd() {
        end = true
    }
}
