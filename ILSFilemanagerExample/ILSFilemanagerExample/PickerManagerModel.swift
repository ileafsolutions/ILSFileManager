//
//  PickerManagerModel.swift
//  EasyShare
//
//  Created by Vivek iLeaf on 6/26/17.
//  Copyright © 2017 iOS. All rights reserved.
//

import UIKit
import Photos

class PickerManagerModel: NSObject
{

    let caching = PHCachingImageManager()
    var imageArray = [PHAsset]()
    var videoArray = [PHAsset]()
    var selectedAssetsVideo = [Int]()
    var selectedAssetsImage = [Int]()
   
    
    static var shared = PickerManagerModel()
    
    func fetchPhotos()
    {
         self.imageArray.removeAll()
        let options = PHFetchOptions()
        
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let results = PHAsset.fetchAssets(with: .image, options: options)
        
        results.enumerateObjects({ (object, _, _) in
            
            self.imageArray.append(object)
        })
        caching.startCachingImages(for: self.imageArray, targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFit, options: nil)
        
    }
    func fetchVideos()
    {
        let options = PHFetchOptions()
        
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        
        let results = PHAsset.fetchAssets(with: .video, options: options)
        
        results.enumerateObjects({ (object, _, _) in
            
            self.videoArray.append(object)
        })
        caching.startCachingImages(for: self.videoArray, targetSize: CGSize(width: 100, height: 100), contentMode: PHImageContentMode.aspectFit, options: nil)
        
    }

    
    
    

}
