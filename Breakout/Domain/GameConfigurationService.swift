//
//  GameConfigService.swift
//  Breakout
//
//  Created by Ole Kristian Sunde on 09/10/2025.
//

import Foundation

struct GameConfigurationService {
    let dataSource: GameConfigurationDataSource
    
    init(using dataSource: GameConfigurationDataSource) {
        self.dataSource = dataSource
    }
    
    
    func loadConfiguration() throws -> GameConfiguration {
        let data: Data
        do {
            data = try dataSource.data(
                forResource: "GameConfiguration",
                withExtension: "plist"
            )
            
        } catch {
            throw GameConfigurationError.resourceNotFound(name: "GameConfiguration", ext: "plist")
        }

        let decoder = PropertyListDecoder()
        
        do {
            let config = try decoder.decode(GameConfiguration.self, from: data)
            return config
        } catch {
            throw GameConfigurationError.decodingFailed
        }
    }
    
}
