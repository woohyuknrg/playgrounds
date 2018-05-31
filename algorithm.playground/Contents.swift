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
