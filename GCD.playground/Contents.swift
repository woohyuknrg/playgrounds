//: Playground - noun: a place where people can play

import Dispatch
import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

//变量同步
class MyData{
    private var privateData:Int = 0
    private let dataQueue = DispatchQueue(label: "com.leo.dataQueue")
    var data:Int{
        get{
            return dataQueue.sync{ privateData }
        }
        set{
            dataQueue.sync { privateData = newValue}
        }
    }
}

public func readDataTask(label:String, cost: UInt32 = 2){
    print("thread \(label) \(Thread.current)")
    print("Start sync task \(label)")
    sleep(cost)
    print("End sync task \(label)")
}

public func networkTask(label:String, cost:UInt32, complete:@escaping ()->()){
    NSLog("Start network Task task%@",label)
    DispatchQueue.global().async {
        sleep(cost)
        NSLog("End networkTask task%@",label)
        DispatchQueue.main.async {
            complete()
        }
    }
}

public func usbTask(label:String, cost:UInt32, complete:@escaping ()->()){
    NSLog("Start usb task%@",label)
    sleep(cost)
    NSLog("End usb task%@",label)
    complete()
}


//串行队列 + 异步执行：开启了一条新线程，但是任务还是串行，所以任务是一个一个执行
//let serialQueue = DispatchQueue(label: "com.leo.serialQueue")
//print("Main queue Start")
//serialQueue.async {
//    readDataTask(label: "1")
//}
//serialQueue.async {
//    readDataTask(label: "2")
//}
//print("Main queue End")

//串行队列 + 同步执行
//let serialQueue = DispatchQueue(label: "com.leo.queue")
//print("Main queue Start")
//serialQueue.sync {
//    readDataTask(label: "1")
//}
//serialQueue.sync {
//    readDataTask(label: "2")
//}
//print("Main queue End")


//并行队列 + 异步执行
//print("Main queue Start")
//let concurrentQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
//concurrentQueue.async {
//    readDataTask(label: "3")
//}
//concurrentQueue.async {
//    readDataTask(label: "4")
//}
//print("Main queue End")


//并行队列 + 同步执行：所有任务都是在主线程中执行的。由于只有一个线程，所以任务只能一个一个执行
//print("Main queue Start")
//let concurrentQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
//concurrentQueue.sync {
//    readDataTask(label: "3")
//}
//concurrentQueue.sync {
//    readDataTask(label: "4")
//}
//print("Main queue End")


//主队列 + 同步执行：直接运行报错：EXC_BAD_INSTRUCTION
//print("Main queue Start")
//let mainQueue = DispatchQueue.main
//mainQueue.sync {
//    readDataTask(label: "3")
//}
//print("Main queue End")


//延迟执行：DispatchTime的精度是纳秒，DispatchWallTime的精度是微秒
//let deadline = DispatchTime.now() + 2.0
//print("Start")
//DispatchQueue.global().asyncAfter(deadline: deadline) {
//    print("End")
//}
//
//let walltime = DispatchWallTime.now() + 2.0
//print("Start")
//DispatchQueue.global().asyncAfter(wallDeadline: walltime) {
//    print("End wallDeadline")
//}


//计时器
//public let timer = DispatchSource.makeTimerSource()
//
//timer.setEventHandler {
//    //这里要注意循环引用，[weak self] in
//    print("Timer fired at \(Date())")
//}
//timer.setCancelHandler {
//    print("Timer canceled at \(Date())" )
//}
//timer.scheduleRepeating(deadline: .now() + 1, interval: 2.0, leeway: .microseconds(10))
//print("Timer resume at \(Date())")
//timer.resume()
//DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute:{
//    timer.cancel()
//})



//NSLog("Group created")
//let group = DispatchGroup()
//group.enter()
//networkTask(label: "1", cost: 2, complete: {
//    group.leave()
//})
//
//group.enter()
//networkTask(label: "2", cost: 4, complete: {
//    group.leave()
//})
//NSLog("Before wait")
////在这个点，等待三秒钟
//group.wait(timeout:.now() + .seconds(7))
//NSLog("After wait")
//group.notify(queue: .main, execute:{
//    print("All network is done")
//})


//信号量：可用于线程依次同步执行
//let semaphore = DispatchSemaphore(value: 2)
//let queue = DispatchQueue(label: "com.leo.concurrentQueue", qos: .default, attributes: .concurrent)
//
//queue.async {
//    semaphore.wait()
//    usbTask(label: "1", cost: 2, complete: {
//        semaphore.signal()
//    })
//}
//
//queue.async {
//    semaphore.wait()
//    usbTask(label: "2", cost: 2, complete: {
//        semaphore.signal()
//    })
//}
//
//queue.async {
//    semaphore.wait()
//    usbTask(label: "3", cost: 1, complete: {
//        semaphore.signal()
//    })
//}


//queue里之前的任务执行完了新任务才开始；新任务开始后提交的任务都要等待新任务执行完毕才能继续执行
//以barrier提交的任务能够保证其在并行队列执行的时候，是唯一的一个任务。（只对自己创建的队列有效，对gloablQueue无效）
//let concurrentQueue = DispatchQueue(label: "com.leo.concurrent", attributes: .concurrent)
//concurrentQueue.async {
//    readDataTask(label: "1", cost: 3)
//}
//
//concurrentQueue.async {
//    readDataTask(label: "2", cost: 3)
//}
//concurrentQueue.async(flags: .barrier, execute: {
//    NSLog("Task from barrier 1 begin")
//    sleep(3)
//    NSLog("Task from barrier 1 end")
//})
//
//concurrentQueue.async {
//    readDataTask(label: "2", cost: 3)
//}


//两个协议都是用来合并数据的变化，只不过一个是按照+(加)的方式，一个是按照|(位或)的方式
//GCD会帮助我们自动的将这些改变合并，然后在适当的时候（target queue空闲），去回调EventHandler,从而避免了频繁的回调导致CPU占用过多
let userData = DispatchSource.makeUserDataAddSource()//makeUserDataOrSource
var globalData:UInt = 0
userData.setEventHandler {
    let pendingData = userData.data
    globalData = globalData + pendingData
    print("Add \(pendingData) to global and current global is \(globalData)")
}
userData.resume()
let serialQueueData = DispatchQueue(label: "com")
serialQueueData.async {
    for _ in 1...1000{
        userData.add(data: 1)
    }
    for _ in 1...1000{
        userData.add(data: 1)
    }
}
