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


/*----------------找出无序数组里的第k大元素----------------*/
//https://leetcode.com/problems/kth-largest-element-in-an-array/discuss/
func findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    if nums.count == 0 {
        return 0
    }
    return divideAndConquer(nums, 0, nums.count - 1, nums.count - k)
}

func divideAndConquer(_ nums: [Int], _ start: Int, _ end: Int, _ k: Int) -> Int {
    print("nums=\(nums) start=\(start) end=\(end) k=\(k)")
    let pivot = nums[end]
    var newNums = nums
    var left = start
//    var right = end

    for i in start..<end {
        if newNums[i] <= pivot {
            if left != i {
                newNums.swapAt(left, i)
                print("for swap newNums=\(newNums)")
            }
            left += 1
        }
    }
//    while left < right {
//        while newNums[left] > pivot && left < right {
//            left += 1
//        }
//        while newNums[right] <= pivot && left < right {
//            right -= 1
//        }
//        newNums.swapAt(left, right)
//    }

    if left != end {
        newNums.swapAt(left, end)
        print("swap newNums=\(newNums) left=\(left) end=\(end)")
    }
    print("left=\(left) end=\(end) k=\(k)")

    if left == k {
        return newNums[left]
    } else if left > k {
        print("left part")
        return divideAndConquer(newNums, start, left - 1, k)
    } else {
        print("right part")
        return divideAndConquer(newNums, left + 1, end, k)
    }
}

findKthLargest([5,6,4,3,2,1], 2)
//findKthLargest([3,2,3,1,2,4,5,5,6], 4)
