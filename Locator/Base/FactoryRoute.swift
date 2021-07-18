//
//  FactoryRoute.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/27/1400 AP.
//

import Foundation

struct FactoryRoute<Service>:Route {
    
    typealias Output = Service
    
    weak var locator:ServiceLocator?
    var arg:ServiceLocator.Args?
    
    func callAsFunction<T>(_ route: T) -> Service? {
        if let fac = route as? LocatorFactory<Service> {
            return fac()
        }
        else if let fac = route as? LocatorFactoryLocator<Service> {
            return fac(locator!)
        }else if let fac = route as? LocatorFactoryWithArguments<Service> {
            return fac(arg!)
        }
        return nil
    }
}

protocol k {
    func callAsFunction<T>(_ route: T) -> T?
}
