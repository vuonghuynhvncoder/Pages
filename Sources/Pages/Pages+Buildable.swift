//
//  File.swift
//  
//
//  Created by OptiSigns on 22/10/2022.
//

import Foundation

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension Pages: Buildable {
    public func onPageChanged(_ callback: ((Int) -> Void)?) -> Self {
        mutating(keyPath: \.onPageChanged, value: callback)
    }
    
    public func onScrolled(_ callback: (() -> Void)?) -> Self {
        mutating(keyPath: \.onScrolled, value: callback)
    }
}
