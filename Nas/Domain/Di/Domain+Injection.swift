//
//  Domain+Injection.swift
//  Nas
//
//  Created by Ye Lin Aung on 13/08/2025.
//

import Foundation
import FactoryKit

extension Container {
    
    var getNewsUseCase: Factory<GetNewsUseCase> {
        Factory(self) { GetNewsUseCaseImpl() }
    }
    
}
