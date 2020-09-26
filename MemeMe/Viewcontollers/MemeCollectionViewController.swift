//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Robert Jeffers on 9/12/20.
//  Copyright © 2020 AsapInc. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes = [MemeData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //memes = appDelegate.memes

        configureLayoutFlow()
    }
    
    override func viewWillAppear(_ animated: Bool) {
          
          // Access to the shared data model
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          memes = appDelegate.memes
        
          collectionView?.reloadData()
      }
    
    func configureLayoutFlow() {
        
        let sectionInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)

        let itemPerRow:CGFloat = 3.0
        let space:CGFloat = sectionInsets.left * (itemPerRow + 1)
        let availableWidth = view.frame.width - space
                let widthPerItem = availableWidth / itemPerRow

        flowLayout.minimumInteritemSpacing = 3
        flowLayout.minimumLineSpacing = 3
        flowLayout.sectionInset = sectionInsets
        flowLayout.itemSize = CGSize(width: widthPerItem, height: widthPerItem)
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "viewcontroller") as! ViewController
        present(vc, animated: true)
    }
}

    extension MemeCollectionViewController {
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return memes.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
               let meme = memes[indexPath.row]
            
            cell.contentView.frame = cell.bounds
            cell.contentView.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
               
               cell.memeiamge.image = meme.memedImage
               
               return cell
           }
        
        
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
                let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
                
            memeGeneratorVC.sentTopText = memes[indexPath.row].topText
            memeGeneratorVC.sentBottomText = memes[indexPath.row].bottomText
            memeGeneratorVC.sentImage = memes[indexPath.row].originalImage
                
                present(memeGeneratorVC, animated: true)
        }
    }
