//
//  MediaPickerCollectionViewController.swift
//  ILSFilemanagerExample
//
//  Created by Vivek iLeaf on 1/30/18.
//  Copyright © 2018 Vivek iLeaf. All rights reserved.
//

import UIKit
import ILSFileManger
import Photos

protocol reloadTable
{
    func reloadCollection()
}
private let reuseIdentifier = "mediacell"

class MediaPickerCollectionViewController: UICollectionViewController {
    var isSelected = Bool()
    var albumName = String()
    var selectButton :UIBarButtonItem!
    var doneButton :UIBarButtonItem!
    
    var delegate : reloadTable?
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        selectButton = UIBarButtonItem(title: "Select", style: .plain, target: self, action: #selector(selectMedia(sender:)))
        doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneButtonAction(sender:)))

        self.title = albumName
        self.navigationItem.rightBarButtonItems = [selectButton,doneButton]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        DispatchQueue.main.async {
//            self.collectionView?.reloadData()
//        }

        // Do any additional setup after loading the view.
    }
    override func viewWillDisappear(_ animated: Bool) {
        PickerManagerModel.shared.selectedAssetsImage.removeAll()
    }
    
    @objc func doneButtonAction(sender:UIBarButtonItem)
    {
        if PickerManagerModel.shared.selectedAssetsImage.count > 0
        {
            for obj in PickerManagerModel.shared.selectedAssetsImage
            {
               let asset = PickerManagerModel.shared.imageArray[obj]
                let data = UIImageJPEGRepresentation(self.getAssetThumbnail(asset: asset, size:CGSize(width: 100, height: 100)), 1.0)
                _ = ILSFileManager.createFile(fileName: "\(self.albumName)\(ILSFileManager.getfileListatPath(folderName: self.albumName).count)", folderName: self.albumName, data: data!)
                self.delegate?.reloadCollection()
                
            }
            self.navigationController?.popViewController(animated: false)
        }
        else
        {
            self.navigationController?.popViewController(animated: false)
        }
    }
    func getAssetThumbnail(asset: PHAsset, size: CGSize) -> UIImage {
        let retinaScale = UIScreen.main.scale
        let retinaSquare = CGSize(width:size.width * retinaScale,height: size.height * retinaScale)
        let cropSizeLength = min(asset.pixelWidth, asset.pixelHeight)
        let square = CGRect(x:0,y: 0,width: CGFloat(cropSizeLength),height: CGFloat(cropSizeLength))
        
        let cropRect = square.applying(CGAffineTransform(scaleX: 1.0/CGFloat(asset.pixelWidth), y: 1.0/CGFloat(asset.pixelHeight)))
        
        let manager = PHImageManager.default()
        let options = PHImageRequestOptions()
        var thumbnail = UIImage()
        
        options.isSynchronous = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .exact
        options.normalizedCropRect = cropRect
        
        manager.requestImage(for: asset, targetSize: retinaSquare, contentMode: .aspectFit, options: options, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    @objc func selectMedia(sender:UIBarButtonItem)
    {
        if sender.title == "Select"
        {
            sender.title = "Cancel"
            self.isSelected = true
        }
        else
        {
            sender.title = "Select"
            self.isSelected = false
            PickerManagerModel.shared.selectedAssetsImage.removeAll()
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
            
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return PickerManagerModel.shared.imageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MediaCollectionViewCell
        PickerManagerModel.shared.caching.requestImage(for: PickerManagerModel.shared.imageArray[indexPath.row], targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFit, options: nil) { (image, info) in
            DispatchQueue.main.async {
                cell.assetImage.image = image
            }
        }
        if(isSelected)
        {
        if  PickerManagerModel.shared.selectedAssetsImage.contains(indexPath.row)
        {
           cell.checkbox.isHidden = false
            cell.shadeImage.isHidden = false
        }
        else
        {
           cell.checkbox.isHidden = true
            cell.shadeImage.isHidden = true
        }
        }
        else
        {
            cell.checkbox.isHidden = true
            cell.shadeImage.isHidden = true
        }
        
        
        return cell
        

    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
        if(self.isSelected)
        {
        if  PickerManagerModel.shared.selectedAssetsImage.contains(indexPath.row)
        {
            let index =  PickerManagerModel.shared.selectedAssetsImage.index(of: indexPath.row)
            PickerManagerModel.shared.selectedAssetsImage.remove(at: index!)
        }
        else
        {
          
            PickerManagerModel.shared.selectedAssetsImage.append(indexPath.row)
            
        }
        
        
        DispatchQueue.main.async {
            collectionView.reloadItems(at: [indexPath])
        }
        
        
        
        }
        else
        {
            
        }
    }
    
        
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
