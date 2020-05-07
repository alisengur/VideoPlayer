//
//  MainViewController.swift
//  customVideoPlayer
//
//  Created by Ali Şengür on 7.05.2020.
//  Copyright © 2020 Ali Şengür. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = Video() {
        didSet {
            if self.collectionView != nil {
                self.collectionView.reloadData()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        setCollectionView()
    }
    
    fileprivate func setCollectionView(){
        let width = (view.frame.size.width - 10) / 2
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout ///  UICollectionViewFlowLayout have an itemSize
        layout.itemSize = CGSize(width: width, height: width)

    }
    


}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MainCollectionViewCell
        cell.cellInit(imageURL: data.imageURLS[indexPath.item], description: data.videosDesc[indexPath.item])
        cell.delegate = self
        cell.index = indexPath
        return cell
    }
    
}


extension MainViewController: MainCollectionViewCellDelegate {
    func didTapPlayButton(index: Int) {
        print("tapped")
    }
}

