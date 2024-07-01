//
//  Array + Replace.swift
//  TCAProject
//
//  Created by Erfan mac mini on 6/29/24.
//

import Foundation

public extension Array {
    mutating func replaceOrAppend<Value>(_ item: Element,
                                         firstMatchingKeyPath keyPath: KeyPath<Element, Value>)
    where Value: Equatable
    {
        let itemValue = item[keyPath: keyPath]
        replaceOrAppend(item, whereFirstIndex: { $0[keyPath: keyPath] == itemValue })
    }
    
    mutating func replaceOrAppend(_ item: Element, whereFirstIndex predicate: (Element) -> Bool) {
        if let idx = self.firstIndex(where: predicate){
            self[idx] = item
        } else {
            append(item)
        }
    }
}
