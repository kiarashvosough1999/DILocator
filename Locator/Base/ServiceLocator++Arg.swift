//
//  ServiceLocator++Arg.swift
//  Locator
//
//  Created by Kiarash Vosough on 4/27/1400 AP.
//

import Foundation

extension ServiceLocator {
    
    public struct Args {

        private var args: [String:Any?]

        public init(_ args: Any?) {
            if let args = args as? Args {
                self.args = args.args
            } else if let args = args as? [String:Any?] {
                self.args = args
            } else {
                self.args = ["" : args]
            }
        }

        #if swift(>=5.2)
        public func callAsFunction<T>() -> T {
            assert(args.count == 1, "argument order indeterminate, use keyed arguments")
            return (args.first?.value as? T)!
        }

        public func callAsFunction<T>(_ key: String) -> T {
            return (args[key] as? T)!
        }
        #endif

        public func optional<T>() -> T? {
            return args.first?.value as? T
        }

        public func optional<T>(_ key: String) -> T? {
            return args[key] as? T
        }

        public func get<T>() -> T {
            assert(args.count == 1, "argument order indeterminate, use keyed arguments")
            return (args.first?.value as? T)!
        }

        public func get<T>(_ key: String) -> T {
            return (args[key] as? T)!
        }

    }
}
