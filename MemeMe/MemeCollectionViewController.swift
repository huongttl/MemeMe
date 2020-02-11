//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Huong Tran on 1/10/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

let showControllerID = "MemeShowViewController"
let editControllerID = "MemeEditViewController"
let cellControllerID = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let delegate = object as! AppDelegate
        return delegate.memes
    }
    let sectionInsets = UIEdgeInsets(top: 5.0, left: 20.0, bottom: 5.0, right: 20.0)
    let itemsPerRow: CGFloat = 3.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellControllerID, for: indexPath) as! MemeCollectionViewCell
        let dic = self.memes[(indexPath as NSIndexPath).row]
        cell.imageView.image = dic.memedImage
        return cell
    }

    @objc func addMeme() {
        let editVC = storyboard?.instantiateViewController(identifier: editControllerID) as! MemeEditViewController
        navigationController?.pushViewController(editVC, animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let showVC = storyboard?.instantiateViewController(identifier: showControllerID) as! MemeShowViewController
        let dic = memes[(indexPath as NSIndexPath).row]
        showVC.memeToShow = dic
        navigationController?.pushViewController(showVC, animated: true)
    }
    // MARK: UICollectionViewDelegate

}
extension MemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding = sectionInsets.left * (itemsPerRow + 1)
        let cellWidth = (view.frame.width - padding) / itemsPerRow
        return CGSize(width: cellWidth, height: cellWidth)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
