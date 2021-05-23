//
//  StoreSubscriber.swift
//  
//
//  Created by Amir Lahav on 19/05/2021.
//

import Foundation

public protocol AnyStoreSubscriber: AnyObject {

    func _newState(newValue: Any, oldValue: Any?)
}

public protocol StoreSubscriber: AnyStoreSubscriber {
    associatedtype StoreSubscriberStateType
    associatedtype Action
    associatedtype Environment
    associatedtype State: Equatable
    
    
    var store: Store<State> { get set }
    var reducer: Reducer<State, Action, Environment> { get set }
    
    func dispatch(action: Action, environment: Environment)
    
    func newState(newValue: StoreSubscriberStateType, oldValue: StoreSubscriberStateType)
    func changeState(change: StateChange<StoreSubscriberStateType>)
}

extension StoreSubscriber {

    public func _newState(newValue: Any, oldValue: Any?) {
        if let typedState = newValue as? StoreSubscriberStateType,
           let oldTypedState = oldValue as? StoreSubscriberStateType {
            let newChangeState = StateChange<StoreSubscriberStateType>(new: typedState, old: oldTypedState)
            changeState(change: newChangeState)
            newState(newValue: typedState, oldValue: oldTypedState)
        }
    }
    
    public func dispatch(action: Action,
                         environment: Environment) {
        reducer.reduce(&store.currentState, action, environment)
    }
}
