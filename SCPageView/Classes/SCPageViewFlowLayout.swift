//
//  SCPageViewFlowLayout.swift
//  PageViewDemo
//
//  Created by Sam Chiang on 2020/5/11.
//  Copyright © 2020 Sam Chiang. All rights reserved.
//

import UIKit

open class SCPageViewFlowLayout: UICollectionViewFlowLayout {
    // TODO:  是否要设置一个枚举，可以改变Item的靠边规则
    /// 让BannerCell 一直居中
    open override var itemSize: CGSize {
        didSet {
            let bounds = self.collectionView?.bounds ?? CGRect.zero
            let topAndBottom = (bounds.height - itemSize.height) / 2
            let leftAndRight = (bounds.width - itemSize.width) / 2
            sectionInset = UIEdgeInsets(top:  topAndBottom, left: leftAndRight, bottom: topAndBottom, right: leftAndRight)
            minimumInteritemSpacing = topAndBottom
        }
    }
}
