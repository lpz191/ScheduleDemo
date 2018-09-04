//
//  Array+Extension.swift
//  ScheduleProject
//
//  Created by pactera on 2018/9/4.
//  Copyright © 2018年 pactera. All rights reserved.
//

import Foundation

extension Array {
    // 去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
