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

//给定二叉树，获取2个节点的最近公共祖先节点
func lowestCommonAncestor2(_ root: TreeNode?, p: TreeNode?, q: TreeNode?) -> TreeNode? {
    if root == nil || p === root || q === root {
        return root
    }

    let left = lowestCommonAncestor2(root?.left, p: p, q: q)
    let right = lowestCommonAncestor2(root?.right, p: p, q: q)

    if left != nil && right != nil {
        return root
    }
    return left ?? right
}

//----------------作业----------------//
//获取二叉树的最小深度
func minDepth(_ root: TreeNode?) -> Int {
    guard let root = root else {
        return 0
    }

    let leftDepth = minDepth(root.left)
    let rightDepth = minDepth(root.right)

    if leftDepth == 0 {
        return rightDepth + 1
    } else if rightDepth == 0 {
        return leftDepth + 1
    }
    return min(leftDepth, rightDepth) + 1
}

//给定二叉树，判断是否是对称树
//https://leetcode.com/problems/symmetric-tree/description/
func isSymmetric(_ root: TreeNode?) -> Bool {
    guard let root = root else {
        return true
    }

    return judgeSymmetric(root.left, right: root.right)
}

func judgeSymmetric(_ left: TreeNode?, right: TreeNode?) -> Bool {
    if left == nil && right == nil {
        return true
    }

    if left?.val != right?.val {
        return false
    }

    return judgeSymmetric(left?.left, right: right?.right) && judgeSymmetric(left?.right, right: right?.left)
}

//把二叉树转换为链表树(没做对)
//https://leetcode.com/problems/flatten-binary-tree-to-linked-list/description/

var preNode: TreeNode?

func flatten(_ root: TreeNode?) {
    guard let root = root else {
        return
    }

    flatten(root.right)
    flatten(root.left)
    root.right = preNode
    root.left = nil
    preNode = root
}

//恢复二叉搜索树
//https://leetcode.com/problems/recover-binary-search-tree/description/

var first: TreeNode?
var second: TreeNode?
var previous = TreeNode(Int.min)

func recoverTree(_ root: TreeNode?) {
    traversal(root)
    if let first = first, let second = second {
        swap(&first.val, &second.val)
    }
}

func traversal(_ root: TreeNode?) {
    guard let root = root else {
        return
    }

    traversal(root.left)

    if first == nil && previous.val > root.val {
        first = previous
    }
    if first != nil && previous.val > root.val {
        second = root
    }
    previous = root

    traversal(root.right)
}
