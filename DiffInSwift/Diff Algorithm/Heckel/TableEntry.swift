//
//  TableEntry.swift
//  DiffInSwift
//
//  Created by xurunkang on 2019/8/1.
//  Copyright © 2019 xurunkang. All rights reserved.

import Foundation

// use entry to keep
// oc(old count)
// nc(new count)
// olno(the index of old element in old array)
class TableEntry {

    private var nc: Int
    private var oc: Int

    private var olno: [Int]

    var isAppearInBoth: Bool {
        return self.oc > 0 && self.nc > 0
    }

    init(
        nc: Int = 0,
        oc: Int = 0,
        olno: [Int] = [] ) {
        self.nc = nc
        self.oc = oc
        self.olno = olno
    }

    func increaseNC() {
        self.nc += 1
    }

    func increaseOC(with index: Int) {
        self.oc += 1
        self.olno.append(index)
    }

    func popFirstOldIndex() -> Int? {
        if !olno.isEmpty {
            return olno.removeFirst()
        }

        return nil
    }
}

extension TableEntry: CustomDebugStringConvertible {
    var debugDescription: String {
        return "nc: \(nc), oc: \(oc), olno: \(olno)"
    }
}
