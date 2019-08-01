//
//  PrettyPrint.swift
//  DiffInSwiftTests
//
//  Created by xurunkang on 2019/8/1.
//  Copyright © 2019 xurunkang. All rights reserved.

import Foundation

func prettyPrint<T: Hashable>(_ changeSet: [Change<T>]) {
    changeSet.enumerated().forEach { (index, elm) in
        print("\(index): \(elm)")
    }
}
