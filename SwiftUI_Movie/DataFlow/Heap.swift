//
//  Heap.swift
//  EhPanda
//
//  Created by 荒木辰造 on R 4/02/06.
//

private final class Reference<T: Equatable>: Equatable {
    var value: T
    init(_ value: T) {
        self.value = value
    }
    static func == (lhs: Reference<T>, rhs: Reference<T>) -> Bool {
        lhs.value == rhs.value
    }
}

@propertyWrapper struct Heap<T: Equatable>: Equatable {
    private var reference: Reference<T>
    
    init(_ value: T) {
        reference = .init(value)
    }
    
    var wrappedValue: T {
        get { reference.value }
        set {
            if !isKnownUniquelyReferenced(&reference) {
                reference = .init(newValue)
                return
            }
            reference.value = newValue
        }
    }
    var projectedValue: Heap<T> {
        self
    }
}

//
@propertyWrapper
enum Indirect<T> {
    indirect case wrapped(T)
    
    init(wrappedValue initialValue: T) {
        self = .wrapped(initialValue)
    }
    
    var wrappedValue: T {
        get { switch self { case .wrapped(let x): return x } }
        set { self = .wrapped(newValue) }
    }
}

extension Indirect: Equatable where T: Equatable {}

extension Indirect: Decodable where T: Decodable {
    init(from decoder: Decoder) throws {
        try self.init(wrappedValue: T(from: decoder))
    }
}

extension Indirect: Encodable where T: Encodable {
    func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(to: encoder)
    }
}

extension KeyedDecodingContainer {
    func decode<T: Decodable>(_: Indirect<T>.Type, forKey key: Key) throws -> Indirect<T> {
        return try Indirect(wrappedValue: decode(T.self, forKey: key))
    }
    
    func decode<T: Decodable>(_: Indirect<Optional<T>>.Type, forKey key: Key) throws -> Indirect<Optional<T>> {
        return try Indirect(wrappedValue: decodeIfPresent(T.self, forKey: key))
    }
}

//
public struct Recursive<State: Equatable>: Equatable {
    private class Box: Equatable{
        var storage: State
        
        init(_ storage: State) {
            self.storage = storage
        }
        
        static func == (lhs: Box, rhs: Box) -> Bool {
            lhs.storage == rhs.storage
        }
    }
    
    public static func == (lhs: Recursive<State>, rhs: Recursive<State>) -> Bool {
        lhs.box == rhs.box
    }
    
    private var box: Box? = nil
    
    public init(_ state: State? = nil) {
        if let state {
            box = Box(state)
        }
    }
    
    public var accessor: State? {
        get { box?.storage }
        set { if let newValue = newValue { box = Box(newValue) } else { box = nil } }
    }
    
    public func callAsFunction() -> State? {
        box?.storage
    }
}
