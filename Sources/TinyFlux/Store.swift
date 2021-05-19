//
//  Store.swift
//  
//
//  Created by Amir Lahav on 19/05/2021.
//

import Foundation

public class Store<State> {
    
    var subscriptions: Set<SubscriptionWrapper<State>> = []
    
    var currentState: State {
        didSet {
            subscriptions.forEach {
                if $0.subscriber == nil {
                    subscriptions.remove($0)
                } else {
                    $0.newValues(oldState: oldValue, newState: currentState)
                }
            }
        }
    }
    
    public init(intialState: State) {
        self.currentState = intialState
    }
    
    fileprivate func _subscribe<SelectedState, V: StoreSubscriber>(
        _ subscriber: V, originalSubscription: Subscription<State>,
        transformedSubscription: Subscription<SelectedState>?)
        where V.StoreSubscriberStateType == SelectedState
    {
        let subscriptionBox = self.subscriptionBox(
            originalSubscription: originalSubscription,
            transformedSubscription: transformedSubscription,
            subscriber: subscriber
        )

        subscriptions.insert(subscriptionBox)

        originalSubscription.newValues(oldState: nil, newState: self.currentState)
    }

    open func subscribe<V: StoreSubscriber>(_ subscriber: V)
        where V.StoreSubscriberStateType == State {
            subscribe(subscriber, transform: nil)
    }

    open func subscribe<SelectedState, V: StoreSubscriber>(
        _ subscriber: V, transform: ((Subscription<State>) -> Subscription<SelectedState>)?
    ) where V.StoreSubscriberStateType == SelectedState
    {
        // Create a subscription for the new subscriber.
        let originalSubscription = Subscription<State>()
        // Call the optional transformation closure. This allows callers to modify
        // the subscription, e.g. in order to subselect parts of the store's state.
        let transformedSubscription = transform?(originalSubscription)

        _subscribe(subscriber, originalSubscription: originalSubscription,
                   transformedSubscription: transformedSubscription)
    }

    func subscriptionBox<T>(
        originalSubscription: Subscription<State>,
        transformedSubscription: Subscription<T>?,
        subscriber: AnyStoreSubscriber
        ) -> SubscriptionWrapper<State> {

        return SubscriptionWrapper(
            originalSubscription: originalSubscription,
            transformedSubscription: transformedSubscription,
            subscriber: subscriber
        )
    }

    open func unsubscribe(_ subscriber: AnyStoreSubscriber) {
        #if swift(>=5.0)
        if let index = subscriptions.firstIndex(where: { return $0.subscriber === subscriber }) {
            subscriptions.remove(at: index)
        }
        #else
        if let index = subscriptions.index(where: { return $0.subscriber === subscriber }) {
            subscriptions.remove(at: index)
        }
        #endif
    }
}
