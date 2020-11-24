import Dispatch

/// [Atomic](https://www.objc.io/blog/2018/12/18/atomic-variables/) wrapper to provide synchronized access to a variable.
///
/// However this one is analogous to read-write queue but without overhead of lookup by dispatch specific key.
/// Reads are concurrent, while writes are serial (using barrier). Both operations perform synchronously.
internal final class Atomic<T> {

    /// Private wrapped value.
    private var _value: T

    /// Synchronization queue.
    private let queue: DispatchQueue

    /// Concurrent synchronized getter for wrapped value.
    internal var value: T {
        return self.queue.sync { _value }
    }

    /// Initializes wrapper with initial value and unique identifier.
    ///
    /// - Parameters:
    ///     - id: Unique identifier. Mostly used for internal queue label and debugging purposes. Defaults to `"swifty-redux.atomic"`
    ///     - value: Value to wrap.
    internal init(id: String = "swifty-redux.atomic", value: T) {
        self._value = value
        self.queue = DispatchQueue(label: id + ".queue", attributes: .concurrent)
    }

    /// Serial mutating function for wrapped value.
    /// Next time you call `value` after `mutate` function it will have updated value.
    ///
    /// - Parameters:
    ///     - transform: A function to transform inout value.
    ///     - value: Inout value to transform.
    ///
    /// - Remark: Performs synchronously.
    internal func mutate(_ transform: (_ value: inout T) -> Void) {
        queue.sync(flags: .barrier) {
            transform(&self._value)
        }
    }
    
    @discardableResult
    public func mutate<R>(_ body: (inout T) -> (R)) -> R {
        self.queue.sync(flags: .barrier) {
            return body(&self._value)
        }
    }

}
