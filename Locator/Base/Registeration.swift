//
//  Options.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/27/1400 AP.
//

import Foundation

class Registeration<Service>: LocatorMoreOptionsProtocol {

    // MARK: - Parameters
    
    var scope: LocatorScopeType
    
    var key: Int
    
    var cacheKey: String
    
    private  var mutator: LocatorFactoryMutator<Service>?
    
    private  var factory: Any
    
    private weak var resolver: ServiceLocator?
    

    // MARK: - Lifecycle

    init<Factory>(resolver: ServiceLocator, key: Int, name: ServiceLocator.Name?, factory: Factory) {
        self.factory = factory
        self.resolver = resolver
        self.scope = ServiceLocator.defaultScope.scope
        self.key = key
        if let namedService = name {
            self.cacheKey = String(key) + ":" + namedService.rawValue
        } else {
            self.cacheKey = String(key)
        }
    }

    @discardableResult
    final func scope(_ scope: LocatorScope) -> Self {
        self.scope = scope.scope
        return self
    }
    
    @discardableResult
    final func resolveProperties(_ block: @escaping LocatorFactoryMutator<Service>) -> Self  {
        mutator = block
        return self
    }
    
    func resolve(resolver: ServiceLocator, args: Any?) -> Service? {
        guard let service:Service = FactoryRoute<Service>(locator: resolver, arg: ServiceLocator.Args(args))(factory) else {
            return nil
        }
        return service
    }
}
