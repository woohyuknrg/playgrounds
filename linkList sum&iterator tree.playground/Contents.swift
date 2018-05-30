//: Playground - noun: a place where people can play

import UIKit

/*-----------求两个链表表示的数的和-------------*/
//给你两个链表，分别表示两个非负的整数。每个链表的节点表示一个整数位。为了方便计算，整数的低位在链表头
class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {

    class func getNodeValue(_ node: ListNode?) -> Int {
        return node.flatMap { $0.val } ?? 0
    }

    class func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?)
        -> ListNode? {
            if l1 == nil || l2 == nil {
                return l1 ?? l2
            }
            var p1 = l1
            var p2 = l2
            let result = ListNode(0)
            var current = result
            var extra = 0
            while p1 != nil || p2 != nil || extra != 0 {
                var tot = getNodeValue(p1) +
                    getNodeValue(p2) + extra
                extra = tot / 10
                tot = tot % 10
                let sum = ListNode(tot)
                current.next = sum
                current = sum
                print("current.val=\(current.val)")
                p1 = p1?.next
                p2 = p2?.next
            }
            return result.next
    }
}

let node1 = ListNode(1)
let node2 = ListNode(4)
let node3 = ListNode(2)
node3.next = node2
node2.next = node1

let node4 = ListNode(1)
let node5 = ListNode(6)
let node6 = ListNode(5)
node6.next = node5
node5.next = node4

var node = Solution.addTwoNumbers(node3, node6)
var arr = [Int]()
while let realNode = node {
    arr.append(realNode.val)
    node = realNode.next
}
print(arr.reduce("", { $0 + "\($1)" }))


/*-----------按层遍历二叉树的节点-------------*/
class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

class Solution2 {
    class func levelOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }
        var result = [[TreeNode]]()
        var level = [TreeNode]()

        level.append(root)
        while !level.isEmpty {
            result.append(level)
            var nextLevel = [TreeNode]()
            for node in level {
                if let leftNode = node.left {
                    nextLevel.append(leftNode)
                }
                if let rightNode = node.right {
                    nextLevel.append(rightNode)
                }
            }
            print(nextLevel.map({ $0.val }))
            level = nextLevel
        }

        return result.map { $0.map { $0.val }}
    }
}

let rootNode = TreeNode(3)
let treeNode1 = TreeNode(9)
let treeNode2 = TreeNode(20)
let treeNode3 = TreeNode(15)
let treeNode4 = TreeNode(7)

rootNode.left = treeNode1
rootNode.right = treeNode2
treeNode2.left = treeNode3
treeNode2.right = treeNode4

print(Solution2.levelOrder(rootNode))
