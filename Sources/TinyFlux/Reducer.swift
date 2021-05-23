//
//  Reducer.swift
//  
//
//  Created by Amir Lahav on 19/05/2021.
//

import Foundation

public struct Reducer<S, A, E> {
    public init(reduce: @escaping (inout S, A, E) -> Void
    ) {
        self.reduce = reduce
    }
    
    var reduce: (inout S, A, E) -> Void
}
