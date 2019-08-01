//
//  HeckelTest.swift
//  DiffInSwiftTests
//
//  Created by xurunkang on 2019/8/1.
//  Copyright © 2019 xurunkang. All rights reserved.

import XCTest

private extension String {
    var toArray: [String] {
        return self.map( String.init )
    }
}

class HeckelTest: XCTestCase {

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
            Change.delete((0, "A")),
            Change.delete((1, "B")),
            Change.delete((2, "C")),
            Change.insert((0, "a")),
            Change.insert((1, "b")),
            Change.insert((2, "c"))
        ]

        XCTAssert(res == exp)
    }

    func testSamePrefix() {
        let o = "aBc".toArray
        let n = "ab".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((1, "B")),
            Change.delete((2, "c")),
            Change.insert((1, "b"))
        ]

        XCTAssert(res == exp)
    }

    func testReversed() {
        let o = "abc".toArray
        let n = "cba".toArray

        let res = diff(o, n)

        let exp = [
            Change.move((2, 0, "c")),
            Change.move((0, 2, "a"))
        ]

        XCTAssert(res == exp)
    }

    func testSmallChangesAtEdges() {
        let o = "sitting".toArray
        let n = "kitten".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((0, "s")),
            Change.delete((4, "i")),
            Change.delete((6, "g")),
            Change.insert((0, "k")),
            Change.insert((4, "e"))
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
            Change.delete((1, "i")),
            Change.insert((1, "a"))
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
            Change.delete((0, "a")),
            Change.delete((1, "b")),
            Change.delete((2, "c")),
            Change.insert((0, "d")),
        ]

        XCTAssert(res == exp)
    }

    func testExample() {
        let o = "ABCE".toArray
        let n = "ACDF".toArray

        let res = diff(o, n)

        let exp = [
            Change.delete((1, "B")),
            Change.delete((3, "E")),
            Change.insert((2, "D")),
            Change.insert((3, "F"))
        ]

        XCTAssert(res == exp)
    }

    private func diff<T: Hashable>(_ o: [T], _ n: [T]) -> [Change<T>] {
        let heckel = Heckel<T>()
        return heckel.diff(o: o, n: n)
    }
}
