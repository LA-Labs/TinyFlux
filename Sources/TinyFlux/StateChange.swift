//
//  StateChange.swift
//  
//
//  Created by Amir Lahav on 14/05/2021.
//

import Foundation

/// Contains new and old value
@dynamicMemberLookup
public struct StateChange<State> {

    /// New value of changes
    public let new: State

    /// Old value of changes
    public let old: State?

    /// Returns specified value when it has changed
    public func changedProperty<Value: Equatable>(for keyPath: KeyPath<State, Value>) -> PropertyChange<Value>? {
        self[dynamicMember: keyPath]
    }

    public subscript<Value: Equatable>(dynamicMember keyPath: KeyPath<State, Value>) -> PropertyChange<Value>? {
        let newValue = new[keyPath: keyPath]
        return newValue == old?[keyPath: keyPath] ? nil : PropertyChange(value: newValue)
    }
}

extension StateChange {

    /// Contains a changed value of specified property
    public struct PropertyChange<T> {
        public let value: T
    }
}
