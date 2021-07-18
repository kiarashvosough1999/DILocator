//
//  Locator++Protocols.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/27/1400 AP.
//

import Foundation

typealias LocatorFactory<Service> = () -> Service?
typealias LocatorFactoryLocator<Service> = (_ resolver: ServiceLocator) -> Service?
typealias LocatorFactoryWithArguments<Service> = (_ args: ServiceLocator.Args) -> Service?
typealias LocatorFactoryMutator<Service> = (_ resolver: ServiceLocator, _ service: Service) -> Void

protocol ServiceLocatorProtocol {
    func addService<Service>(name:ServiceLocator.Name, factory: @escaping LocatorFactoryWithArguments<Service>)
    func addService<Service>(name:ServiceLocator.Name, factory: @escaping LocatorFactory<Service>)
}

protocol LocatorOptionsProtocol {
    var scope: LocatorScopeType { get }
    func scope(_ scope: LocatorScope) -> Self
}

protocol LocatorMoreOptionsProtocol: LocatorOptionsProtocol {
    associatedtype Service
    var key: Int { get }
    var cacheKey: String { get }
    func resolve(resolver: ServiceLocator, args: Any?) -> Service?
    func resolveProperties(_ block: @escaping LocatorFactoryMutator<Service>) -> Self
}

extension LocatorMoreOptionsProtocol {
    func resolve(resolver: ServiceLocator, args: Any?) -> Service? { nil }
}


protocol Route {
  associatedtype Output
   func callAsFunction<T>(_ route:T) -> Output?
}

protocol LocatorScopeType: AnyObject {
    func resolve<Reg:LocatorMoreOptionsProtocol>(resolver: ServiceLocator, registration: Reg, args: Any?) -> Reg.Service?
    func reset()
}

extension LocatorScopeType {
    func reset() {}
}
