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



    // Created instance from Video struct
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
        let width = (view.frame.size.width - 30) / 2
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
        let selectedVideo = data.videos[index]
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let vc = mainStoryBoard.instantiateViewController(identifier: "VideoPlayerViewController") as? VideoPlayerViewController {
            vc.video = selectedVideo
            var newItemIndex = index
            for _ in 0..<self.data.videos.count {
                if newItemIndex >= data.videos.count {
                    newItemIndex = 0
                }
                vc.videos.append(self.data.videos[newItemIndex])
                newItemIndex += 1
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

