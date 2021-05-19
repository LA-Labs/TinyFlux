//
//  Reducer.swift
//  
//
//  Created by Amir Lahav on 19/05/2021.
//

import Foundation

public struct Reducer<S,A> {
    public init(reduce: @escaping (inout S, A) -> Void
    ) {
        self.reduce = reduce
    }
    
    var reduce: (inout S, A) -> Void
}
