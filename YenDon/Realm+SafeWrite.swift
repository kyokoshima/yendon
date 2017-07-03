//
//  Realm+SafeWrite.swift
//  YenDon
//
//  Created by 横島健一 on 2017/07/03.
//  Copyright © 2017年 info.tmpla. All rights reserved.
//

import Foundation
import RealmSwift
extension Realm {
    public func safeWrite(_ block: (() throws -> Void)) throws {
        if isInWriteTransaction {
            try block()
        } else {
            try write(block)
        }
    }
}
