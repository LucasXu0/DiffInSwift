//
//  Heckel.swift
//  DiffInSwift
//
//  Created by xurunkang on 2019/8/1.
//  Copyright © 2019 xurunkang. All rights reserved.

import Foundation

private enum Reference {
    case tableEntry(TableEntry)
    case indexInOther(Int)
}

extension Reference: CustomDebugStringConvertible {
    var debugDescription: String {
        switch self {
        case .tableEntry(let entry):
            return "table entry: \(entry)"
        case .indexInOther(let index):
            return "index in other: \(index)"
        }
    }
}

class Heckel<T: Hashable>: DiffAlgorithm {

    typealias T = T

    private var table: [Int: TableEntry] = [:] // T.hasValue -> TableEntry

    private var nrs: [Reference] = [] // new references
    private var ors: [Reference] = [] // old references

    func diff(o: [T], n: [T]) -> [Change<T>] {

        firstBuildNRS(n)
        secondBuildORS(o)

        thirdFindTheBothShowElement()

        return forthDiversion(o, n)
    }
}

private extension Heckel {

    // 1. build new references
    // the new references is corresponding to new array
    private func firstBuildNRS(_ n: [T]) {

        // new array -> new references
        n.enumerated().forEach { (index, element) in

            // get entry from table if exist. otherwise, create new one.
            let entry = table[element.hashValue] ?? TableEntry()
            // entry's new count plus 1
            entry.increaseNC()
            // store it in the table
            table[element.hashValue] = entry

            // append it to new references
            nrs.append(.tableEntry(entry))
        }
    }

    // 2. build old references
    private func secondBuildORS(_ o: [T]) {

        // old array -> old references
        o.enumerated().forEach { (index, element) in

            // get entry from table if exist. otherwise, create new one.
            let entry = table[element.hashValue] ?? TableEntry()
            // entry' old count plus 1 and keep old index
            entry.increaseOC(with: index)
            // store it in the table
            table[element.hashValue] = entry

            // append it to new references
            ors.append(.tableEntry(entry))
        }
    }

    // 3. find the element both show in table
    private func thirdFindTheBothShowElement() {

        nrs.enumerated().forEach { (newIndex, newReference) in

            // we only focus on .tableEntry element.
            // and there is only one type in the new reference currently.
            guard case let Reference.tableEntry(entry) = newReference else { return }

            // if entry is appear in both new references and old references
            // and entry's olno is not empty
            if entry.isAppearInBoth, let oldIndex = entry.popFirstOldIndex() {

                // use .indexInOthre to replace .tableEntry
                nrs[newIndex] = Reference.indexInOther(oldIndex)
                ors[oldIndex] = Reference.indexInOther(newIndex)
            }
        }
    }

    // 4. diversion
    // the reference(.tableEntry case) exist in old references means delete
    // the reference(.tableEntry case) exist in new references means insert
    // the reference(.indexInOther case) exist in new references means move
    private func forthDiversion(_ o: [T], _ n: [T]) -> ChangeSet {

        var changeSet: ChangeSet = []

        var deleteCount = 0

        // 1. find the element should be deleted
        // 2. record delete count in deletions
        let deletions = ors.enumerated().map { (index, reference) -> Int in

            let deleteCountBeforeIndex = deleteCount

            if case Reference.tableEntry(_) = reference {
                changeSet.append(.delete((index, o[index])))
                deleteCount += 1
            }

            return deleteCountBeforeIndex
        }

        var insertCount = 0

        // 3. find the element should be inserted or moved
        nrs.enumerated().forEach { (newIndex, reference) in

            switch reference {

            // tableEntry -> Insert
            case .tableEntry:
                changeSet.append(.insert((newIndex, n[newIndex])))
                insertCount += 1

            // indexInOther -> move && oldIndex(consider of delete & insert offset) != newIndex
            case .indexInOther(let oldIndex):
                let deleteCountBeforeNewIndex = deletions[oldIndex]
                if newIndex != oldIndex - deleteCountBeforeNewIndex + insertCount {
                    changeSet.append(.move((oldIndex, newIndex, n[newIndex])))
                }
            }
        }

        return changeSet
    }

    private func debugTablePrint() {
        print("===================================")
        table.forEach { (key, entry) in
            print("\(key)\t" + entry.debugDescription)
        }
        print("===================================")
    }

    private func debugReferencePrint(for rs: [Reference]) {
        print("===================================")
        rs.forEach { reference in
            print(reference.debugDescription)
        }
        print("===================================")
    }
}
