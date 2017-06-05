//https://github.com/apple/swift-evolution/blob/master/proposals/0107-unsaferawpointer.md
//https://github.com/apple/swift-evolution/blob/master/proposals/0138-unsaferawbufferpointer.md
//https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/InteractingWithCAPIs.html

import Foundation

MemoryLayout<Int>.size          // returns 8 (on 64-bit)
MemoryLayout<Int>.alignment     // returns 8 (on 64-bit)
MemoryLayout<Int>.stride        // returns 8 (on 64-bit)

MemoryLayout<Int16>.size        // returns 2
MemoryLayout<Int16>.alignment   // returns 2
MemoryLayout<Int16>.stride      // returns 2

MemoryLayout<Int8>.size        // returns 1
MemoryLayout<Int8>.alignment   // returns 1
MemoryLayout<Int8>.stride      // returns 1

MemoryLayout<Bool>.size         // returns 1
MemoryLayout<Bool>.alignment    // returns 1
MemoryLayout<Bool>.stride       // returns 1

MemoryLayout<Float>.size        // returns 4
MemoryLayout<Float>.alignment   // returns 4
MemoryLayout<Float>.stride      // returns 4

MemoryLayout<Double>.size       // returns 8
MemoryLayout<Double>.alignment  // returns 8
MemoryLayout<Double>.stride     // returns 8

MemoryLayout<String>.size           //24
MemoryLayout<String>.alignment      //8
MemoryLayout<String>.stride         //24


struct EmptyStruct {}

MemoryLayout<EmptyStruct>.size      // returns 0
MemoryLayout<EmptyStruct>.alignment // returns 1
MemoryLayout<EmptyStruct>.stride    // returns 1

struct SampleStruct {
    let number: UInt32
    let flag: Bool
}

MemoryLayout<SampleStruct>.size       // returns 5
MemoryLayout<SampleStruct>.alignment  // returns 4
MemoryLayout<SampleStruct>.stride     // returns 8


class EmptyClass {}

MemoryLayout<EmptyClass>.size      // returns 8 (on 64-bit)
MemoryLayout<EmptyClass>.stride    // returns 8 (on 64-bit)
MemoryLayout<EmptyClass>.alignment // returns 8 (on 64-bit)

class SampleClass {
    let number: Int64 = 0
    let flag: Bool = false
}

MemoryLayout<SampleClass>.size      // returns 8 (on 64-bit)
MemoryLayout<SampleClass>.stride    // returns 8 (on 64-bit)
MemoryLayout<SampleClass>.alignment // returns 8 (on 64-bit)

//指针类型
MemoryLayout<UnsafeMutablePointer<SampleClass>>.size           //8
MemoryLayout<UnsafeMutablePointer<SampleClass>>.alignment      //8
MemoryLayout<UnsafeMutablePointer<SampleClass>>.stride         //8

MemoryLayout<UnsafeMutableBufferPointer<SampleClass>>.size           //16
MemoryLayout<UnsafeMutableBufferPointer<SampleClass>>.alignment      //8
MemoryLayout<UnsafeMutableBufferPointer<SampleClass>>.stride         //16


// 1
let count = 2
let stride = MemoryLayout<Int>.stride
let alignment = MemoryLayout<Int>.alignment
let byteCount = stride * count

// 2
do {
    print("Raw pointers")
    
    // 3
    let pointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
    // 4
    defer {
        pointer.deallocate(bytes: byteCount, alignedTo: alignment)
    }
    
    // 5
    pointer.storeBytes(of: 42, as: Int.self)
    pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
    pointer.load(as: Int.self)
    pointer.advanced(by: stride).load(as: Int.self)
    
    // 6
    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
    bufferPointer[0]
    bufferPointer[8]
    for (index, byte) in bufferPointer.enumerated() {
        print("byte \(index): \(byte)")
    }
}

do {
    print("Typed pointers")
    
    let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
    pointer.initialize(to: 0, count: count)
    defer {
        pointer.deinitialize(count: count)
        pointer.deallocate(capacity: count)
    }
    
    pointer.pointee = 42
    pointer.advanced(by: 1).pointee = 6
    pointer.pointee
    pointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Converting raw pointers to typed pointers")
    
    let rawPointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
    defer {
        rawPointer.deallocate(bytes: byteCount, alignedTo: alignment)
    }
    
    //bindMemory
    let typedPointer = rawPointer.bindMemory(to: Int.self, capacity: count)
    typedPointer.initialize(to: 0, count: count)
    defer {
        typedPointer.deinitialize(count: count)
    }
    
    typedPointer.pointee = 42
    typedPointer.advanced(by: 1).pointee = 6
    typedPointer.pointee
    typedPointer.advanced(by: 1).pointee
    
    let bufferPointer = UnsafeBufferPointer(start: typedPointer, count: count)
    for (index, value) in bufferPointer.enumerated() {
        print("value \(index): \(value)")
    }
}

do {
    print("Getting the bytes of an instance")
    
    var sampleStruct = SampleStruct(number: 25, flag: true)
    
    //withUnsafeBytes: also available as an instance method on Array and Data
    withUnsafeBytes(of: &sampleStruct) { bytes in
        bytes[0]
        bytes[1]
        bytes[2]
        bytes[3]
        bytes[4]
        for byte in bytes {
            print(byte)
        }
    }
}

do {
    print("Checksum the bytes of a struct")
    
    var sampleStruct = SampleStruct(number: 25, flag: true)
    
    //withUnsafeBytes(of:) can return a result
    let checksum = withUnsafeBytes(of: &sampleStruct) { (bytes) -> UInt32 in
        return ~bytes.reduce(UInt32(0)) { $0 + numericCast($1) }
    }
    
    print("checksum", checksum) // prints checksum 4294967269
}

//-------------------三原则-------------------//

// Rule #1
do {
    print("1. Don't return the pointer from withUnsafeBytes!")
    
    var sampleStruct = SampleStruct(number: 25, flag: true)
    
    let bytes = withUnsafeBytes(of: &sampleStruct) { bytes in
        return bytes // strange bugs here we come ☠️☠️☠️
    }
    
    print("Horse is out of the barn!", bytes)  /// undefined !!!
}

// Rule #2
do {
    print("2. Only bind to one type at a time!")
    
    let count = 3
    let stride = MemoryLayout<Int16>.stride
    let alignment = MemoryLayout<Int16>.alignment
    let byteCount =  count * stride
    
    let pointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
    
    let typedPointer1 = pointer.bindMemory(to: UInt16.self, capacity: count)
    
    // Breakin' the Law... Breakin' the Law  (Undefined behavior)
    let typedPointer2 = pointer.bindMemory(to: Bool.self, capacity: count * 2)
    
    // If you must, use withMemoryRebound
    typedPointer1.withMemoryRebound(to: Bool.self, capacity: count * 2) {
        (boolPointer: UnsafeMutablePointer<Bool>) in
        print(boolPointer.pointee)  // See Rule #1, don't return the pointer
    }
}

// Rule #3... wait
do {
    print("3. Don't walk off the end... whoops!")
    
    let count = 3
    let stride = MemoryLayout<Int16>.stride
    let alignment = MemoryLayout<Int16>.alignment
    let byteCount =  count * stride
    
    let pointer = UnsafeMutableRawPointer.allocate(bytes: byteCount, alignedTo: alignment)
    //count参数不对
    let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount + 1) // OMG +1????
    
    for byte in bufferPointer {
        print(byte)  // pawing through memory like an animal
    }
}


//https://mp.weixin.qq.com/s/zIkB9KnAt1YPWGOOwyqY3Q
//操作内存修改一个 Struct 类型实例的属性的值
enum Kind {
    case wolf
    case fox
    case dog
    case sheep
}

struct Animal: CustomStringConvertible {
    private var a: Int = 1       //8 byte
    var b: String = "animal"     //24 byte
    var c: Kind = .wolf          //1 byte
    var d: String?               //25 byte
    var e: Int8 = 8              //1 byte

    var description: String {
        return "\(a) \(b) \(c) \(d ?? "") \(e)"
    }

    //返回指向 Animal 实例头部的指针
    mutating func headPointerOfStruct() -> UnsafeMutablePointer<Int8> {
        return withUnsafeMutablePointer(to: &self) {
            return UnsafeMutableRawPointer($0).bindMemory(to: Int8.self, capacity: MemoryLayout<Animal>.stride)
        }
    }
}

MemoryLayout<Animal>.size       // 8 + 24 + 8 + 25 + 1 = 66
MemoryLayout<Animal>.alignment  // returns 8
MemoryLayout<Animal>.stride     // 8 + 24 + 8 + 32 = 72

var animal = Animal()
let animalPtr = animal.headPointerOfStruct()

//将之前得到的指向 animal 实例的指针转化为 rawPointer 指针类型，方便我们进行指针偏移操作
let animalRawPtr = UnsafeMutableRawPointer(animalPtr)

let aPtr = animalRawPtr.advanced(by: 0).assumingMemoryBound(to: Int.self)
aPtr.pointee          // 1
aPtr.initialize(to: 100)
aPtr.pointee          // 100

let bPtr = animalRawPtr.advanced(by: 8).assumingMemoryBound(to: String.self)
bPtr.pointee = "haha"

let cPtr = animalRawPtr.advanced(by: 32).assumingMemoryBound(to: Kind.self)
cPtr.pointee = .fox

let dPtr = animalRawPtr.advanced(by: 40).assumingMemoryBound(to: String?.self)
dPtr.pointee
dPtr.pointee = "woohyuk"

let ePtr = animalRawPtr.advanced(by: 65).assumingMemoryBound(to: Int8.self)
ePtr.pointee = 2

print(animal)


//操作内存修改一个 Class 类型实例属性的值
//类型信息区域在 32bit 的机子上是 4byte，在 64bit 机子上是 8 byte。引用计数占用 8 byte。所以，在堆上，类属性的地址是从第 16 个字节开始的
class Human {
    var age: Int?
    var name: String?
    var nicknames: [String] = [String]()

    //返回指向 Human 实例头部的指针
    func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Human>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}

let human = Human()

//拿到指向 human 堆内存的 void * 指针
let humanRawPtr = UnsafeMutableRawPointer(human.headPointerOfClass())

//nicknames 数组在内存中偏移 64byte 的位置(16 + 16 + 32)
let humanNickNamesPtr =  humanRawPtr.advanced(by: 64).assumingMemoryBound(to: [String].self)
human.nicknames

humanNickNamesPtr.initialize(to: ["goudan","zhaosi", "wangwu"])
human.nicknames

//获取数组值
let arrPtr = humanRawPtr.advanced(by: 64).assumingMemoryBound(to: UnsafeMutablePointer<String>.self).pointee
//需要偏移32位
let firstElementPtr = UnsafeMutableRawPointer(arrPtr).bindMemory(to: Int8.self, capacity: 32).advanced(by: 32)
UnsafeMutableRawPointer(firstElementPtr).bindMemory(to: String.self, capacity: 3).pointee
UnsafeMutableRawPointer(firstElementPtr).bindMemory(to: String.self, capacity: 3).advanced(by: 1).pointee
UnsafeMutableRawPointer(firstElementPtr).bindMemory(to: String.self, capacity: 3).advanced(by: 2).pointee


//替换一下 Type
class Wolf {
    var name: String = "wolf"

    func soul() {
        print("my soul is wolf")
    }

    func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Wolf>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}

class Fox {
    var name: String = "fox"

    func soul() {
        print("my soul is fox")
    }

    func headPointerOfClass() -> UnsafeMutablePointer<Int8> {
        let opaquePointer = Unmanaged.passUnretained(self as AnyObject).toOpaque()
        let mutableTypedPointer = opaquePointer.bindMemory(to: Int8.self, capacity: MemoryLayout<Fox>.stride)
        return UnsafeMutablePointer<Int8>(mutableTypedPointer)
    }
}

let wolf = Wolf()
var wolfPtr = UnsafeMutableRawPointer(wolf.headPointerOfClass())

let fox = Fox()
var foxPtr = UnsafeMutableRawPointer(fox.headPointerOfClass())
foxPtr.advanced(by: 0).bindMemory(to: UnsafeMutablePointer<Wolf.Type>.self, capacity: 1).initialize(to: wolfPtr.advanced(by: 0).assumingMemoryBound(to: UnsafeMutablePointer<Wolf.Type>.self).pointee)

print(type(of: fox))        //Wolf
fox.name                    //"fox"
fox.soul()                  //my soul is wolf
