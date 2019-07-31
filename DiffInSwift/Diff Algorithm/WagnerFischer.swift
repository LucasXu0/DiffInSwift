//
//  WagnerFischer.swift
//  DEMO_PROJECT
//
//  Created by xurunkang on 2019/7/26.
//  Copyright © 2019 xurunkang. All rights reserved.

import Foundation

struct WagnerFischer<T: Hashable>: DiffAlgorithm {

    typealias T = T

    typealias Row = [ChangeSet]

    func diff(o: [T], n: [T]) -> ChangeSet {

        let nc = n.count

        // we don't need to use double dimensional array
        // because we only focus on previous row and current row
        // define previous row
        var previousRow: Row = Array(repeating: [], count: nc + 1)

        // first line represent .insert op
        n.enumerated().forEach { (index, ele) in
            let insertItem = (index, ele)
            previousRow[index + 1] = append(change: .insert(insertItem), to: previousRow[index])
        }

        // define current row
        var currentRow: Row = previousRow

        o.enumerated().forEach { (oldIndex, oldEle) in

            // first row represent .delete op
            let deleteItem = (oldIndex, oldEle)
            currentRow[0] = append(change: .delete(deleteItem), to: previousRow[0])

            n.enumerated().forEach({ (newIndex, newEle) in

                if oldEle == newEle { // levenshtein distance + 0 if two elements are equal

                    // use top-left ele
                    currentRow[newIndex + 1] = previousRow[newIndex]

                } else { // otherwise, levenshtein distance = min(previous_op_s) + 1

                    // calculate min op
                    let leftTop = previousRow[newIndex]
                    let left = currentRow[newIndex]
                    let top = previousRow[newIndex + 1]

                    let minimum = min(
                        leftTop.count,
                        left.count,
                        top.count
                    )

                    // top -> next means delete
                    if minimum == top.count {

                        currentRow[newIndex + 1] = append(change: .delete((oldIndex, oldEle)), to: top)

                    } else if minimum == left.count { // left -> next means insert

                        currentRow[newIndex + 1] = append(change: .insert((newIndex, newEle)), to: left)

                    } else if minimum == leftTop.count { // top-left -> next means substitute

                        currentRow[newIndex + 1] = append(change: .substitute((newIndex, oldEle, newEle)), to: leftTop)
                    }
                }

            })

            previousRow = currentRow // replace previousRow to currentRow
        }

        guard let last = currentRow.last else {
            return []
        }

        return last
    }

}

private extension WagnerFischer {

    private func append(change: Change<T>, to changeSet: ChangeSet) -> ChangeSet {
        var changeSet = changeSet
        changeSet.append(change)
        return changeSet
    }
}
