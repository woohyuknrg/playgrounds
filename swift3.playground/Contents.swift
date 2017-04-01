//: Playground - noun: a place where people can play

import UIKit

/*-----是小数，例如 6.33，就会失败。如果可以用 Int 来表示，例如 6.0，就会成功-----*/
let grade = Int(exactly: 6.3)
let grade2 = Int(exactly: 6.0)


/*-----Sequence 协议增加了两个新函数，用于数据过滤：prefix(while:) 和 drop(while:)-----*/
let names = ["Michael Jackson", "Michael Jordan", "Michael Caine", "Taylor Swift", "Adele Adkins", "Michael Douglas"]

//prefix(while:) 返回满足某 predicate 的最长子序列。从序列的开头开始，并且在第一个从给定闭包中返回 false 的元素处停下
let prefixed = names.prefix { $0.hasPrefix("Michael") }
print(prefixed) //返回前三个值的数组

//drop(while:) 做相反的操作：从第一个在闭包中返回 false 的元素开始，直到序列的结束，返回此子序列
let dropped = names.drop { $0.hasPrefix("Michael") }
print(dropped) //返回后三个值的数组

let fibonacci = sequence(state: (0, 1)) {
    (state: inout (Int, Int)) -> Int? in
    defer {state = (state.1, state.0 + state.1)}
    return state.0
}

//使用 prefix(while:) 和 drop(while:) 来获取位于序列两个给定值之间所有的元素
let interval = fibonacci.prefix{$0 < 1000}.drop{$0 < 100}
for element in interval {
    print(element) // 144 233 377 610 987
}


/*-----扩展约束条件泛型参数：可指定where后的泛型对象为具体的类型-----*/
extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}

extension String {
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespaces).isEmpty
    }
}

let foo: String? = nil
let bar: String? = "  "
let baz: String? = "x"

let value1 = foo.isBlank
let value2 = bar.isBlank
let value3 = baz.isBlank


/*-----泛型用于嵌套类型：嵌套子类型可处于泛型父类型里，并且可共享父类型的泛型，或者拥有自己的新泛型-----*/
struct Message<T> {
    struct Attachment {
        var contents: T
    }
    var title: T
    var attachment: Attachment
}