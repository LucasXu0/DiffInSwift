//
//  WagnerFischerTest.swift
//  DiffInSwiftTests
//
//  Created by xurunkang on 2019/7/31.
//  Copyright © 2019 xurunkang. All rights reserved.

import XCTest

private extension String {
    var toArray: [String] {
        return self.map( String.init )
    }
}

class WagnerFischerTest: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAllInsert() {
        let o = "".toArray
        let n = "abc".toArray

        let res = diff(o, n)

        let exp = [
            Change.insert((0, "a")),
            Change.insert((1, "b")),
            Change.insert((2, "c"))
        ]

        XCTAssert(res == exp)
    }

    func testAllDelete() {
        let o = "abc".toArray
        let n = "".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((0, "a")),
            Change.delete((1, "b")),
            Change.delete((2, "c"))
        ]

        XCTAssert(res == exp)
    }

    func testAllSubstitute() {
        let o = "ABC".toArray
        let n = "abc".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((0, "A", "a")),
            Change.substitute((1, "B", "b")),
            Change.substitute((2, "C", "c"))
        ]

        XCTAssert(res == exp)
    }

    func testSamePrefix() {
        let o = "aBc".toArray
        let n = "ab".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((1, "B", "b")),
            Change.delete((2, "c"))
        ]

        XCTAssert(res == exp)
    }

    func testReversed() {
        let o = "abc".toArray
        let n = "cba".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((0, "a", "c")),
            Change.substitute((2, "c", "a"))
        ]

        XCTAssert(res == exp)
    }

    func testSmallChangesAtEdges() {
        let o = "sitting".toArray
        let n = "kitten".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((0, "s", "k")),
            Change.substitute((4, "i", "e")),
            Change.delete((6, "g"))
        ]

        XCTAssert(res == exp)
    }

    func testSamePostfix() {
        let o = "abcdef".toArray
        let n = "def".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((0, "a")),
            Change.delete((1, "b")),
            Change.delete((2, "c"))
        ]

        XCTAssert(res == exp)
    }

    func testKitKat() {
        let o = "kit".toArray
        let n = "kat".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((1, "i", "a")),
        ]

        XCTAssert(res == exp)
    }

    func testShift() {
        let o = "abcd".toArray
        let n = "cdef".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((0, "a")),
            Change.delete((1, "b")),
            Change.insert((2, "e")),
            Change.insert((3, "f"))
        ]

        XCTAssert(res == exp)
    }

    func testReplaceWholeNewWord() {
        let o = "abc".toArray
        let n = "d".toArray

        let res = diff(o, n)

        let exp = [
            Change.substitute((0, "a", "d")),
            Change.delete((1, "b")),
            Change.delete((2, "c"))
        ]

        XCTAssert(
            res == exp
        )
    }

    func testExample() {
        let o = "ABCE".toArray
        let n = "ACDF".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((1, "B")),
            Change.insert((2, "D")),
            Change.substitute((3, "E", "F")),
        ]

        XCTAssert(
            res == exp
        )

        prettyPrint(res)
    }

    func testLargeData() {
//        let largeRange = (0..<10000)
//        let o = largeRange.map(String.init)
//        let n = largeRange.reversed().map(String.init)
//
//        let res = diff(o, n)
    }

    private func diff<T: Hashable>(_ o: [T], _ n: [T]) -> [Change<T>] {
        let wagnerFischer = WagnerFischer<T>()
        return wagnerFischer.diff(o: o, n: n)
    }

    private func prettyPrint<T: Hashable>(_ changeSet: [Change<T>]) {
        changeSet.enumerated().forEach { (index, elm) in
            print("\(index): \(elm)")
        }
    }
}
