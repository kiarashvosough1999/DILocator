//
//  ServiceLocator.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/26/1400 AP.
//

import Foundation

final class ServiceLocator {
    
    static let shared = ServiceLocator()
    static var defaultScope:LocatorScope = .graph
    
    private let NONAME = "*"
    private var childContainers: [ServiceLocator] = []
    private var registrations = [Int : [String : Any]]()
    
    @discardableResult
    final func register<Service>(_ type: Service.Type = Service.self, name: ServiceLocator.Name? = nil,
                                        factory: @escaping LocatorFactory<Service>) -> some LocatorMoreOptionsProtocol {
        let key = ObjectIdentifier(Service.self).hashValue
        let registration = Registeration<Service>(resolver: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return registration
    }
    
    @discardableResult
    public final func register<Service>(_ type: Service.Type = Service.self, name: ServiceLocator.Name? = nil,
                                        factory: @escaping LocatorFactoryWithArguments<Service>) -> some LocatorMoreOptionsProtocol  {
        let key = ObjectIdentifier(Service.self).hashValue
        let registration = Registeration<Service>(resolver: self, key: key, name: name, factory: factory)
        add(registration: registration, with: key, name: name)
        return registration
    }
    
    private final func add(registration: LocatorOptionsProtocol, with key: Int, name: ServiceLocator.Name?) {
        if var container = registrations[key] {
            container[name?.rawValue ?? NONAME] = registration
            registrations[key] = container
        } else {
            registrations[key] = [name?.rawValue ?? NONAME : registration]
        }
    }
    
    final func resolve<Service>(name: ServiceLocator.Name? = nil, args: Any? = nil) -> Service? {
        if let registration = lookup(Service.self, name: name),
           let service = registration.scope.resolve(resolver: self, registration: registration, args: args) {
            return service
        }
        return nil
    }
    
    private final func lookup<Service>(_ type: Service.Type, name: ServiceLocator.Name?) -> Registeration<Service>? {
        let key = ObjectIdentifier(Service.self).hashValue
        let containerName = name?.rawValue ?? NONAME
        if let container = registrations[key], let registration = container[containerName] {
            return registration as? Registeration<Service>
        }
        return nil
    }
}
