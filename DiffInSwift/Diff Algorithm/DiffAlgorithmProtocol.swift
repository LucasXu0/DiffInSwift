//
//  Change.swift
//  DEMO_PROJECT
//
//  Created by xurunkang on 2019/7/26.
//  Copyright © 2019 xurunkang. All rights reserved.

import Foundation

// in: two hashable array
// out: change array (changeSet)
protocol DiffAlgorithm {

    associatedtype T: Hashable

    typealias ChangeSet = [Change<T>]

    func diff(o: [T], n: [T]) -> ChangeSet
}

// define edit operation
enum Change<T: Equatable> {

    typealias InsertItem = (index: Int, item: T)
    typealias DeleteItem = (index: Int, item: T)
    typealias SubstituteItem = (index: Int, from: T, to: T)
    typealias MoveItem = (from: Int, to: Int, item: T)

    case insert(InsertItem)
    case delete(DeleteItem)
    case substitute(SubstituteItem)
    case move(MoveItem)
}

extension Change: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .insert(let insertItem):
            return "insert \(insertItem.item) to \(insertItem.index)"
        case .delete(let deleteItem):
            return "delete \(deleteItem.item) in \(deleteItem.index)"
        case .substitute(let substituteItem):
            return "substitute \(substituteItem.from) for \(substituteItem.to) in \(substituteItem.index)"
        case .move(let moveItem):
            return "move \(moveItem.item) from \(moveItem.from) to \(moveItem.to)"
        }
    }
}

extension Change: Equatable {
    static func == (lhs: Change<T>, rhs: Change<T>) -> Bool {
        switch (lhs, rhs) {
        case (.insert(let t1), .insert(let t2)):
            return t1 == t2
        case (.delete(let t1), .delete(let t2)):
            return t1 == t2
        case (.substitute(let t1), .substitute(let t2)):
            return t1 == t2
        case (.move(let t1), .move(let t2)):
            return t1 == t2
        default:
            return false
        }
    }
}
