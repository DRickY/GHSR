//
//  Store+Extension.swift
//  GHSR
//
//  Created by Dmytro.k on 11/23/20.
//

import Foundation

extension Store {
    static func createStore() -> Store<AppState> {        
        return Store<AppState>(id: "GHSR.App.Store",
                                state: .defaultValue,
                                reducer: AppState.reducer(state: action:),
                                middleware: [searchMiddleware])
    }
    
    
    public func observe(on queue: DispatchQueue? = .main,
                          includingCurrentState: Bool = true,
                          observer: @escaping (_ state: State) -> Void) -> Deallocator
    {        
        return .init(self.subscribe(on: queue, includingCurrentState: includingCurrentState, observer: observer).dispose)
    }
}
