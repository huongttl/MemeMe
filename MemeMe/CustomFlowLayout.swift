//
//  CustomFlowLayout.swift
//  MemeMe
//
//  Created by Huong Tran on 2/10/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import Foundation
import UIKit
class CustomFlowLayout:UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        var leftMargin = sectionInset.left
        var maxY: CGFloat = 0.0
        let horizontalSpacing:CGFloat = 3
        attributes?.forEach {
            layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY || layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            if layoutAttribute.frame.origin.x == sectionInset.left {
                leftMargin = sectionInset.left
            }
            else {
                layoutAttribute.frame.origin.x = leftMargin
            }
            leftMargin += layoutAttribute.frame.width + horizontalSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        return attributes
    }
}
