import Foundation

extension Array where Element: Comparable {
    
    func insertionSort() -> [Element] {
        guard count > 1 else {
            return self
        }
        
        var output = self
        
        for index in 1..<count {
            let key = output[index]
            var secondIndex = index - 1
            
            while secondIndex > -1 {
                
                print("comparing \(key) and \(output[secondIndex])")
                if key < output[secondIndex] {
                    output.swapAt(secondIndex + 1, secondIndex)
                    print("output=\(output)")
                } else {
                    break
                }
                
                secondIndex -= 1
            }
        }
        
        return output
    }
    
    func bubbleSort() -> [Element] {
        guard count > 1 else {
            return self
        }

        //如果前后数据进行了交换，则为true，否则为false。如果没有数据交换，则排序完成
        var flag = true
        var output = self
        var arrCount = count

        while flag {
            flag = false

            for index in 0..<arrCount - 1 {
                print("bubbleSort comparing \(output[index]) and \(output[index + 1])")
                if output[index] > output[index + 1] {
                    output.swapAt(index, index + 1)
                    print("output=\(output)")
                    flag = true
                }
            }
            arrCount -= 1
        }

//        for index in 0..<count {
//            let passes = count - 1 - index
//
//            for secondIndex in 0..<passes {
//                let key = output[secondIndex]
//                print("bubbleSort comparing \(key) and \(output[secondIndex + 1])")
//                if key > output[secondIndex + 1] {
//                    output.swapAt(secondIndex, secondIndex + 1)
//                    print("output=\(output)")
//                }
//            }
//        }

        return output
    }
    
    //https://en.wikipedia.org/wiki/Selection_sort
    func selectionSort() -> [Element] {
        guard count > 1 else {
            return self
        }
        
        var output = self
        
        for index in 0..<count {
            var minimum = index
            var secondIndex = index + 1
            
            while secondIndex < count {
                print("comparing \(output[minimum]) and \(output[secondIndex])")
                //store lowest value as minimum
                if output[minimum] > output[secondIndex] {
                    minimum = secondIndex
                }
                secondIndex += 1
            }
            
            if index != minimum {
                output.swapAt(index, minimum)
                print("output=\(output)")
            }
        }
        
        return output
    }
    
    //https://en.wikipedia.org/wiki/Quicksort
    mutating func quickSort() -> [Element] {
        
        func qSort(start startIndex: Int, _ pivot: Int) {
            print("startIndex=\(startIndex) pivot=\(pivot)")
            print("===============")
            if startIndex < pivot {
                let iPivot = qPartition(start: startIndex, pivot)
                print("iPivot=\(iPivot) lower start=\(startIndex) to=\(iPivot - 1)")
                qSort(start: startIndex, iPivot - 1)
                print("higher start=\(iPivot + 1) to=\(pivot)")
                qSort(start: iPivot + 1, pivot)
            }
        }
        
        qSort(start: 0, endIndex - 1)
        return self
    }
    
    mutating func qPartition(start startIndex: Int, _ pivot: Int) -> Int {
        var wallIndex = startIndex
        
        for currentIndex in startIndex..<pivot {
            print("current is: \(self[currentIndex]). pivot is \(self[pivot])")
            if self[currentIndex] <= self[pivot] {
                if wallIndex != currentIndex {
                    self.swapAt(currentIndex, wallIndex)
                    print("self=\(self)")
                }
                
                wallIndex += 1
                print("wallIndex=\(wallIndex)")
            }
        }
        
        if wallIndex != pivot {
            self.swapAt(wallIndex, pivot)
            print("self=\(self)")
        }
        
        print("return wallIndex=\(wallIndex)")
        return wallIndex
    }
}

let numberList = [8, 2, 10, 9, 7, 5]
print("=======插入排序 o(n²)========")
let results1 = numberList.insertionSort()
print("\n=======冒泡排序 o(n²)========")
let results2 = numberList.bubbleSort()
print("\n=======选择排序 o(n²)========")
let results3 = numberList.selectionSort()
print("\n=======快速排序 o(nlogn)========")
var sequence = [7, 2, 1, 6, 8, 5, 3, 4]
let results4 = sequence.quickSort()
