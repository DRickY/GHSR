//
//  Atomic.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import Foundation

public final class Atomic<Value> {
    private let _lock: NSLocking = NSRecursiveLock()
    private var _value: Value
    
    public var value: Value {
        get { return self.withValue { $0 } }
        set { self.swap(newValue) }
    }
    
    public init(_ value: Value) {
        self._value = value
    }
    
    @discardableResult
    public func mutate<R>(_ body: (inout Value) -> (R)) -> R {
        self._lock.lock()
        defer { self._lock.unlock() }
        
        return body(&self._value)
    }
    
    @discardableResult
    public func withValue<R>(_ body: (Value) -> (R)) -> R {
        self._lock.lock()
        defer { self._lock.unlock() }
        
        return body(self._value)
    }
    
    @discardableResult
    public func swap(_ newValue: Value) -> Value {
        return self.mutate { (val) in
            let oldValue = val
            val = newValue
            
            return oldValue
        }
    }
}


