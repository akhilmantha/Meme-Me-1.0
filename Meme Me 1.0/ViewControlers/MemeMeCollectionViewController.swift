//
//  MemeMeCollectionViewController.swift
//  Meme Me 1.0
//
//  Created by akhil mantha on 01/04/18.
//  Copyright © 2018 akhil mantha. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class MemeMeCollectionViewController: UICollectionViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    //Mark: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sent Memes"
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
        for tabBarItem in tabBarController!.tabBar.items!{
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return appDelegate.memes.count
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMeme = appDelegate.memes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memeDetailVC = storyboard.instantiateViewController(withIdentifier: "MemeMeDetailViewController") as! MemeMeDetailViewController
        memeDetailVC.selectedMeme = selectedMeme
        navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath as IndexPath) as! MemeMeCollectionViewCell
        
        // Configure the cell
        let meme = appDelegate.memes[indexPath.row]
        cell.memedImageView.image = meme.memedImage
        
        return cell
    }

}
