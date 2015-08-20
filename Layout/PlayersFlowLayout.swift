//
//  PlayersFlowLayout.swift
//  Layout
//
//  Created by Aynur Galiev on 20.08.15.
//  Copyright (c) 2015 Flatstack. All rights reserved.
//

import UIKit

class PlayersFlowLayout: UICollectionViewLayout {
    
    var center: CGPoint!
    var minimumScale: CGFloat!
    var numberOfItems: Int!
    var overlapWidth: CGFloat!
    
    private var attributes: [PlayerAttributes]! = []
    private var cellSize: CGSize!
    
    override class func layoutAttributesClass() -> AnyClass {
        return PlayerAttributes.self
    }
    
    override func prepareLayout() {
        
        self.cellSize = CGSizeMake((self.collectionView!.frame.size.width + CGFloat(self.numberOfItems - 1)*self.overlapWidth)/CGFloat(self.numberOfItems), self.collectionView!.frame.size.height)
        
        for var i=0; i<self.collectionView!.numberOfItemsInSection(0); i++ {
            let attribute = PlayerAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
            attribute.frame = CGRect(origin: CGPointMake(CGFloat(i)*(cellSize.width - self.overlapWidth), 0), size: cellSize)
            attribute.imageAlpha = Double(1.0)
            attributes.append(attribute)
        }
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {

        let center = self.collectionView!.convertPoint(self.attributes[indexPath.item].center, toView: self.collectionView!.superview!)
        println(center.x)
        let value = self.calculateValue(center.x)
        attributes[indexPath.item].imageAlpha = value
        return attributes[indexPath.item]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        
        var indexPathsInRect = self.attributes.filter { (attribute: PlayerAttributes) -> Bool in
            return attribute.frame.intersects(rect)
        }.map({ (attribute: PlayerAttributes) -> NSIndexPath in
            return attribute.indexPath
        }) as [NSIndexPath]
        
        var layoutAttributes = [PlayerAttributes]()
        
        for var i=0; i<self.attributes.count; i++ {
            if contains(indexPathsInRect, attributes[i].indexPath) {
                attributes[i] = self.layoutAttributesForItemAtIndexPath(attributes[i].indexPath) as! PlayerAttributes
                layoutAttributes.append(attributes[i])
            }
        }
        return layoutAttributes
    }
    
    override func collectionViewContentSize() -> CGSize {
        return CGSizeMake(self.cellSize.width*CGFloat(self.attributes.count) - CGFloat(self.attributes.count)*self.overlapWidth, self.collectionView!.frame.height)
    }
    
    //0...10, max = 3
    func calculateValue(offset: CGFloat) -> Double {   //returns value from 0.0 to 1.0 with normal distribution exp(-(x-3)^2/20)
        let normalizedValue = Double(self.normalizeValue(offset))
        return exp(-normalizedValue*normalizedValue/0.4)
        
    }
    
    func normalizeValue(offset: CGFloat) -> CGFloat {
        let distance = max(self.collectionView!.frame.size.width - self.center.x, self.center.x)
        let dx = fabs(distance - offset)
        return dx/distance
    }
}

func * (left: CGPoint, right: CGFloat) -> CGPoint {
    return CGPointMake(left.x*right, left.y*right)
}

public func*(left: CGSize, right: CGFloat) -> CGSize {
    return CGSizeMake(left.width*right, left.height*right)
}

class PlayerAttributes: UICollectionViewLayoutAttributes {
    var imageAlpha: Double!
    
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let attributes: PlayerAttributes = super.copyWithZone(zone) as! PlayerAttributes
        attributes.imageAlpha = self.imageAlpha
        return attributes
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        if let layoutAttributes = object as? UICollectionViewLayoutAttributes {
            if super.isEqual(layoutAttributes) {
                if let playerAttributes = layoutAttributes as? PlayerAttributes where playerAttributes.imageAlpha == self.imageAlpha {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
}