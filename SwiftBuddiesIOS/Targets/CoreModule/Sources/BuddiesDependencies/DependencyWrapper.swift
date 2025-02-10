//
//  Dependency.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 26.09.2024.
//

import Foundation

public struct DependencyKey<Product> {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
    
    public init(type: Product.Type = Product.self) {
        var name = String(reflecting: type)
        //        trimFoundationPrefix(&name)
        self.init(name: name)
    }
    
    public init(typeOf product: Product) {
        self.init(type: type(of: product))
    }
}

@propertyWrapper 
public struct Dependency<P> {
    public var wrappedValue: P {
        do {
            return try tryGet()
        } catch {
            assertionFailure(error.localizedDescription)
            preconditionFailure(error.localizedDescription)
        }
    }
    
    public func tryGet() throws -> P {
        try container().get(key)
    }
    
    let container: () -> DependencyContainerProtocol
    let key: DependencyKey<P>
    
    public init<Container: DependencyContainerProtocol>(
        container: @autoclosure @escaping () -> DependencyContainerProtocol = DependencyContainer.shared,
        _ keyPath: KeyPath<Container, DependencyKey<P>>
    ) {
        self.container = container
        self.key = DependencyKey<P>()
    }
}
