//
//  DependencyContainerProtocol.swift
//  SwiftBuddiesIOS
//
//  Created by dogukaan on 26.09.2024.
//

import Foundation

public protocol DependencyContainerProtocol {
    static var shared: Self { get }
    
    func get<Product>(
        _ dependencyKey: DependencyKey<Product>
    ) throws -> Product
    
    func build() 
}
