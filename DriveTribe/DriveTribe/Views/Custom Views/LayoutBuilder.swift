//
//  LayoutBuilder.swift
//  DriveTribe
//
//  Created by stanley phillips on 3/17/21.
//

import UIKit

public class LayoutBuilder {
    public static func buildMediaVerticalScrollLayout() -> NSCollectionLayoutSection {
        let heightDimension = NSCollectionLayoutDimension.fractionalHeight(1)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: heightDimension)
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.37))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
        group.interItemSpacing = .fixed(12)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
        
        return section
    }
}


