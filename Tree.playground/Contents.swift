//: Playground - noun: a place where people can play

import UIKit

class TreeNode {
    var val = 0
    var left: TreeNode?
    var right: TreeNode?

    init(_ val: Int) {
        self.val = val
    }
}

public class ListNode {
    var val: Int
    var next: ListNode?

    init(_ val: Int) {
        self.val = val
    }
}

//反转二叉树
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else {
        return nil
    }

    let left = root.left
    let right = root.right
    root.left = invertTree(right)
    root.right = invertTree(left)

    return root
}

//判断是否是合法二叉搜索树
var pre = Int.min
func isValidBST(_ root: TreeNode?) -> Bool {
    guard let root = root else {
        return true
    }

    if !isValidBST(root.left) {
        return false
    }

    if root.val <= pre {
        return false
    }
    pre = root.val

    return isValidBST(root.right)
}

//获取二叉树的最大深度
func maxDepth(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }

    return max(maxDepth(root.left), maxDepth(root.right)) + 1
}

//把升序链表转换为二叉搜索树
func sortedListToBST(_ head: ListNode?) -> TreeNode? {
    if head == nil {
        return nil
    }
    return toBST(head, tail: nil)
}

func toBST(_ head: ListNode?, tail: ListNode?) -> TreeNode? {
    if head === tail {
        return nil
    }

    var fast = head
    var slow = head

    while fast !== tail && fast?.next !== tail {
        fast = fast?.next?.next
        slow = slow?.next
    }

    guard let root = slow else {
        return nil
    }

    let node = TreeNode(root.val)
    node.left = toBST(head, tail: root)
    node.right = toBST(root.next, tail: tail)
    return node
}

//给定二叉搜索树，获取2个节点的最近公共祖先节点
func lowestCommonAncestor(_ root: TreeNode?, p: TreeNode?, q: TreeNode?) -> TreeNode? {
    guard let root = root, let p = p, let q = q else {
        return nil
    }

    if p.val < root.val && q.val < root.val {
        return lowestCommonAncestor(root.left, p: p, q: q)
    } else if p.val > root.val && q.val > root.val {
        return lowestCommonAncestor(root.right, p: p, q: q)
    }
    return root
}
