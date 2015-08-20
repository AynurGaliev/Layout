//
//  ViewController.swift
//  Layout
//
//  Created by Aynur Galiev on 20.08.15.
//  Copyright (c) 2015 Flatstack. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func loadView() {
        super.loadView()
        let layout = self.collectionView.collectionViewLayout as! PlayersFlowLayout
        layout.center = CGPointMake(500, 0)
        layout.minimumScale = 0.7
        layout.numberOfItems = 4
        layout.overlapWidth = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCell", forIndexPath: indexPath) as! PlayerCell
        cell.prepareCell(indexPath)
        return cell
    }
}

class PlayerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageVIew: UIImageView!
    @IBOutlet weak var indexPathLabel: UILabel!
    
    func prepareCell(indexPath: NSIndexPath) {
        self.indexPathLabel.text = "\(indexPath.section) \(indexPath.item)"
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes!) {
        let attributes = layoutAttributes as! PlayerAttributes
        if let imagealpha = attributes.imageAlpha {
            self.imageVIew.alpha = CGFloat(imagealpha)
        }
    }
}