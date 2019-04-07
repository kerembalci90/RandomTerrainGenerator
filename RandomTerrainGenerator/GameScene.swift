//
//  GameScene.swift
//  RandomTerrainGenerator
//
//  Created by Kerem BALCI on 2019-04-07.
//  Copyright © 2019 Hextorm. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        createRandomTerrain()
    }
    
    private func createRandomTerrain() {
        removeAllChildren()
        
        let map = SKNode()
        addChild(map)
        map.xScale = 0.3
        map.yScale = 0.3
        
        let tileSet = SKTileSet(named: "Sample Grid Tile Set")!
        let tileSize = CGSize(width: 128, height: 128)
        let columns = 128
        let rows = 128
        
        let waterTiles = tileSet.tileGroups.first { $0.name == "Water" }
        let grassTiles = tileSet.tileGroups.first { $0.name == "Grass" }
        let sandTiles = tileSet.tileGroups.first { $0.name == "Sand" }
        
        let bottomLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        bottomLayer.fill(with: sandTiles)
        map.addChild(bottomLayer)
        
        let noiseMap = makeNoiseMap(with: columns, and: rows)
        let topLayer = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSize)
        topLayer.enableAutomapping = true
        map.addChild(topLayer)
        
        for column in 0..<columns {
            for row in 0..<rows {
                let location = vector2(Int32(row), Int32(column))
                let terrainHeight = noiseMap.value(at: location)
                if terrainHeight < 0 {
                    topLayer.setTileGroup(waterTiles, forColumn: column, row: row)
                } else {
                    topLayer.setTileGroup(grassTiles, forColumn: column, row: row)
                }
            }
        }
    }
    
    private func makeNoiseMap(with columns: Int, and rows: Int) ->GKNoiseMap {
        let source = GKPerlinNoiseSource(frequency: 2, octaveCount: 3, persistence: 0.5, lacunarity: 2, seed: Int32(arc4random_uniform(UInt32(500 - 1))))
        let noise = GKNoise(source)
        let size = vector2(1.0, 1.0)
        let origin = vector2(0.0, 0.0)
        let sampleCount = vector2(Int32(columns), Int32(rows))
        
        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        createRandomTerrain()
    }
}
