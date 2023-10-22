//
//  CollectionLayout.swift
//  bossia
//
//  Created by ONUR BOSTAN on 21.07.2023.
//

import UIKit

class CollectionLayout: UICollectionViewFlowLayout {

    let colmnsNumber : Int
    var heightRatio : CGFloat = (1.0 / 1.0)
    
    //minColmnsNumber = MinimumSutünAralığı , minCell = minimumSatıraralığı
    init(colmnsNumber : Int, minColmnsNumber : CGFloat = 0, minCell : CGFloat = 0)
    {
        self.colmnsNumber = colmnsNumber
        super.init()
        
        self.minimumInteritemSpacing = minColmnsNumber
        self.minimumLineSpacing = minCell
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepare() {
        super.prepare()
        
        guard let collectionView = collectionView else {return}
        
        let intervals = collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(colmnsNumber-1)
        
        let width = ((collectionView.bounds.size.width - intervals) / CGFloat(colmnsNumber)).rounded(.down)
        let height = width * heightRatio
        
        itemSize = CGSize(width: width, height: height)
        
    }
}
