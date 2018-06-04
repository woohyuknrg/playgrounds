//: Playground - noun: a place where people can play

import UIKit

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    if matrix.isEmpty {
        return []
    }

    var mutableMatrix = matrix

    var result = mutableMatrix.remove(at: 0)

    if mutableMatrix.isEmpty {
        return result
    }

    for index in 0..<mutableMatrix.count - 1 {
        if !mutableMatrix[index].isEmpty {
            result.append(mutableMatrix[index].removeLast())
        }
    }

    if !mutableMatrix.isEmpty {
        result.append(contentsOf: mutableMatrix.removeLast().reversed())
    }

    for index in (0..<mutableMatrix.count).reversed() {
        if !mutableMatrix[index].isEmpty {
            result.append(mutableMatrix[index].remove(at: 0))
        }
    }

    result.append(contentsOf: spiralOrder(mutableMatrix))

    return result
}

let arr = [[0, 1, 2, 3, 4],
           [10, 11, 12, 13, 14],
           [20, 21, 22, 23, 24],
           [30, 31, 32, 33, 34]]

spiralOrder(arr)

/*----------------获取整型二进制数1的个数----------------*/
func getOneAmount(_ num: Int) -> Int {
    var count = 0
    var newNum = num
    while newNum != 0 {
        newNum &= (newNum - 1)
        count += 1
    }
    return count
}

print(getOneAmount(7))

/*----------------合并2个有序链表----------------*/
//https://leetcode.com/problems/merge-two-sorted-lists/description/

public class ListNode {
    public var val: Int
    public var next: ListNode?

    public init(_ val: Int) {
        self.val = val
    }
}
func mergeTwoLists(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    guard let l1 = l1 else {
        return l2
    }
    guard let l2 = l2 else {
        return l1
    }

    if l1.val < l2.val {
        l1.next = mergeTwoLists(l1.next, l2)
        return l1
    } else {
        l2.next = mergeTwoLists(l1, l2.next)
        return l2
    }
}

/*----------------找出中位数----------------*/
//https://leetcode.com/problems/sliding-window-median/description/
func medianSlidingWindow(_ nums: [Int], _ k: Int) -> [Double] {
    var result = [Double]()
    let isEven = k % 2 == 0
    let middle = k / 2

    for index in 0...nums.count - k {
        let sliding = nums[index..<k + index].sorted()
        result.append(isEven ? Double(sliding[middle] + sliding[middle - 1]) / 2 : Double(sliding[middle]))
    }

    return result
}

medianSlidingWindow([1,3,-1,-3,5,3,6,7], 3)
