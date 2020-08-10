//
//  CollectionViewDataSource.swift
//  CollectionViewDataSource
//
//  Created by Havelio Henar on 09/09/20.
//  Copyright © 2020 Havelio Henar. All rights reserved.
//
import UIKit

/**
 CollectionViewDataSource is a class for handling general dataSource of UiCollectionView,
 So we don't need exten UICollectionViewDataSource to each controller
 how to use:
 
 class UserCell: BaseCollectionViewCell<User> {
     override var item: User! {
         didSet {
            // hanlde your data here
        }
     }
 }

 // define the generic model type:
 var dataSource: CollectionViewDataSource<UserCell, User>!

 let users = [User]()
 dataSource = .make(items: users, collection: collectionView)

 // for reload collectionView:
 dataSource.reload(data: users)

 // for custom configuration:
 dataSource = .make(items: users, collection: collectionView) { [weak self] cell, indexPath  in
    // handle your custom code here
 }
*/

class CollectionViewDataSource<Cell: BaseCollectionViewCell<Model>, Model>: NSObject, UICollectionViewDataSource {
    typealias PrepareCell = (Cell, IndexPath) -> Void

    private var prepareCell: PrepareCell? = nil
    private var collection: UICollectionView? = nil

    var items: [Model]! {
        didSet { collection?.reloadData() }
    }

    static func make(items: [Model], collection: UICollectionView,
                     prepareCell: PrepareCell? = nil) -> CollectionViewDataSource {

        let colelctionDataSource = CollectionViewDataSource()
        colelctionDataSource.collection = collection
        colelctionDataSource.items = items
        colelctionDataSource.prepareCell = prepareCell

        collection.dataSource = colelctionDataSource
        return colelctionDataSource
    }

    func reload(data: [Model]) {
        self.items = data
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.identifier,
                                                      for: indexPath) as! Cell
        cell.item = items[indexPath.row]
        prepareCell?(cell, indexPath)
        return cell
    }
}

class BaseCollectionViewCell<Model>: UICollectionViewCell {
    class var identifier: String { return String(describing: self) }
    var item: Model!
}
