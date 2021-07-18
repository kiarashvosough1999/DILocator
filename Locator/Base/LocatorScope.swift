//
//  LocatorScope.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/27/1400 AP.
//

import Foundation

enum LocatorScope {
    case application
    case cached
    case graph
    case shared
    case unique
    
    var scope: LocatorScopeType {
        switch self {
            case .application : return ResolverScopeCache()
            case .cached : return ResolverScopeCache()
            case .graph : return ResolverScopeGraph()
            case .shared : return ResolverScopeShare()
            case .unique : return ResolverScopeUnique()
        }
    }
}

class ResolverScopeCache:LocatorScopeType {
    
    func resolve<Reg:LocatorMoreOptionsProtocol>(resolver: ServiceLocator, registration: Reg, args: Any?) -> Reg.Service? {
        if let service = cachedServices[registration.cacheKey] as? Reg.Service {
            return service
        }
        let service = registration.resolve(resolver: resolver, args: args)
        if let service = service {
            cachedServices[registration.cacheKey] = service
        }
        return service
    }

    final func reset() {
        cachedServices.removeAll()
    }

    fileprivate var cachedServices = [String : Any](minimumCapacity: 32)
}

final class ResolverScopeGraph: LocatorScopeType {
    
    func resolve<Reg:LocatorMoreOptionsProtocol>(resolver: ServiceLocator, registration: Reg, args: Any?) -> Reg.Service? {
        if let service = graph[registration.cacheKey] as? Reg.Service {
            return service
        }
        resolutionDepth = resolutionDepth + 1
        let service = registration.resolve(resolver: resolver, args: args)
        resolutionDepth = resolutionDepth - 1
        if resolutionDepth == 0 {
            graph.removeAll()
        } else if let service = service, type(of: service as Any) is AnyClass {
            graph[registration.cacheKey] = service
        }
        return service
    }
    

    var graph = [String : Any?](minimumCapacity: 32)
    var resolutionDepth: Int = 0
}

final class ResolverScopeShare: LocatorScopeType {
    
    func resolve<Reg:LocatorMoreOptionsProtocol>(resolver: ServiceLocator, registration: Reg, args: Any?) -> Reg.Service? {
        if let service = cachedServices[registration.cacheKey]?.service as? Reg.Service {
            return service
        }
        let service = registration.resolve(resolver: resolver, args: args)
        if let service = service, type(of: service as Any) is AnyClass {
            cachedServices[registration.cacheKey] = BoxWeak(service: service as AnyObject)
        }
        return service
    }
    

    final func reset() {
        cachedServices.removeAll()
    }

    struct BoxWeak {
        weak var service: AnyObject?
    }

    var cachedServices = [String : BoxWeak](minimumCapacity: 32)
}

final class ResolverScopeUnique: LocatorScopeType {
    
    func resolve<Reg:LocatorMoreOptionsProtocol>(resolver: ServiceLocator, registration: Reg, args: Any?) -> Reg.Service? {
        return registration.resolve(resolver: resolver, args: args)
    }
}
