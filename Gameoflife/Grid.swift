//
//  Grid.swift
//  Gameoflife
//
//  Created by jumana obeid on 10/10/17.
//  Copyright © 2017 jumana obeid. All rights reserved.
//

import Foundation
import SpriteKit


class Creature: SKSpriteNode {
    
    /* Character side */
    var isAlive: Bool = false {
        didSet {
            /* Visibility */
            isHidden = !isAlive
        }
    }
    
    /* Living neighbor counter */
    var neighborCount = 0
    
    init() {
        /* Initialize with 'bubble' asset */
        let texture = SKTexture(imageNamed: "bubble")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        
        /* Set Z-Position, ensure it's on top of grid */
        zPosition = 1
        
        /* Set anchor point to bottom-left */
        anchorPoint = CGPoint(x: 0, y: 0)
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

}



class Grid: SKSpriteNode {
    
    /* Counters */
    var generation = 0
    var population = 0
    
    /* Creature Array */
    var gridArray = [[Creature]]()
    
    /* Grid array dimensions */
    let rows = 8
    let columns = 10
    
    /* Individual cell dimension, calculated in setup*/
    var cellWidth = 0
    var cellHeight = 0
    
    func populateGrid() {
        /* Populate the grid with creatures */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Initialize empty column */
            gridArray.append([])
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Create a new creature at row / column position */
                addCreatureAtGrid(x:gridX, y:gridY)
            }
        }
    }
    func countNeighbors() {
        /* Process array and update creature neighbor count */
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Grab creature at grid position */
                let currentCreature = gridArray[gridX][gridY]
                
                /* Reset neighbor count */
                currentCreature.neighborCount = 0
                
                /* Loop through all adjacent creatures to current creature */
                for innerGridX in (gridX - 1)...(gridX + 1) {
                    
                    /* Ensure inner grid column is inside array */
                    if innerGridX<0 || innerGridX >= columns { continue }
                    
                    for innerGridY in (gridY - 1)...(gridY + 1) {
                        
                        /* Ensure inner grid row is inside array */
                        if innerGridY<0 || innerGridY >= rows { continue }
                        
                        /* Creature can't count itself as a neighbor */
                        if innerGridX == gridX && innerGridY == gridY { continue }
                        
                        /* Grab adjacent creature reference */
                        let adjacentCreature:Creature = gridArray[innerGridX][innerGridY]
                        
                        /* Only interested in living creatures */
                        if adjacentCreature.isAlive {
                            currentCreature.neighborCount += 1
                        }
                    }
                }
            }
        }
    }
    func updateCreatures() {
        /* Process array and update creature status */
        
        /* Reset population counter */
        population = 0
        
        /* Loop through columns */
        for gridX in 0..<columns {
            
            /* Loop through rows */
            for gridY in 0..<rows {
                
                /* Grab creature at grid position */
                let currentCreature = gridArray[gridX][gridY]
                
                /* Check against game of life rules */
                switch currentCreature.neighborCount {
                case 3:
                    currentCreature.isAlive = true
                    break;
                case 0...1, 4...8:
                    currentCreature.isAlive = false
                    break;
                default:
                    break;
                }
                
                /* Refresh population count */
                if currentCreature.isAlive { population += 1 }
            }
        }
    }
    
    func evolve() {
        /* Updated the grid to the next state in the game of life */
        
        /* Update all creature neighbor counts */
        countNeighbors()
        
        /* Calculate all creatures alive or dead */
        updateCreatures()
        
        /* Increment generation counter */
        generation += 1
    }
    
    func addCreatureAtGrid(x: Int, y: Int) {
        /* Add a new creature at grid position*/
        
        /* New creature object */
        let creature = Creature()
        
        /* Calculate position on screen */
        let gridPosition = CGPoint(x: x*cellWidth, y: y*cellWidth)
        creature.position = gridPosition
        
        /* Set default isAlive */
        creature.isAlive = false
        
        /* Add creature to grid node */
        addChild(creature)
        
        /* Add creature to grid array */
        gridArray[x].append(creature)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        
        /* There will only be one touch as multi touch is not enabled by default */
        let touch = touches.first!
        let location = touch.location(in: self)
        
        /* Calculate grid array position */
        let gridX = Int(location.x) / cellWidth
        let gridY = Int(location.y) / cellHeight
        
        /* Toggle creature visibility */
        let creature = gridArray[gridX][gridY]
        creature.isAlive = !creature.isAlive
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        /* Enable own touch implementation for this node */
        isUserInteractionEnabled = true
        
        /* Calculate individual cell dimensions */
        cellWidth = Int(size.width) / columns
        cellHeight = Int(size.height) / rows
        
        /* Populate grid with creatures */
        populateGrid()
        
    }
}
