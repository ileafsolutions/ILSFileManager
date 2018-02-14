//
//  GalleryCollectionViewController.swift
//  ILSFilemanagerExample
//
//  Created by Vivek iLeaf on 1/30/18.
//  Copyright © 2018 Vivek iLeaf. All rights reserved.
//

import UIKit
import ILSFileManger
private let reuseIdentifier = "gallerycell"


class GalleryCollectionViewController: UICollectionViewController,UINavigationControllerDelegate,UIImagePickerControllerDelegate,reloadTable {
    var isSelected = Bool()
    var albumName = String()
    var selectButton : UIBarButtonItem!
    var addPhoto : UIBarButtonItem!
    var imagePicker : UIImagePickerController!
    var deleteButton : UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = albumName
         deleteButton = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(delete(sender:)))
        selectButton = UIBarButtonItem(title: "Select", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.selectMedia(sender:)))
        addPhoto = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(self.addPhotoAction(sender:)))
        self.deleteButton.isEnabled = false
        self.navigationItem.rightBarButtonItems = [deleteButton,addPhoto,selectButton]
       
       // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    @objc func addPhotoAction(sender:UIBarButtonItem)
    {
        PickerManagerModel.shared.fetchPhotos()

        let picker = self.storyboard?.instantiateViewController(withIdentifier: "MediaPickerCollectionViewController") as! MediaPickerCollectionViewController
        picker.albumName = self.albumName
        picker.delegate = self
        self.navigationController?.pushViewController(picker, animated: false)
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
    @objc func delete(sender:UIBarButtonItem)
    {
        let array = ILSFileManager.getDirectorylistatPath(folderName: albumName)
        for obj in PickerManagerModel.shared.selectedAssetsImage
        {
            let path = array[obj]
            
            if ILSFileManager.removeFile(filepath: "\(albumName)/\(path)")
            {
            PickerManagerModel.shared.selectedAssetsImage.remove(at:  PickerManagerModel.shared.selectedAssetsImage.index(of: obj)!)
            }

        }
        PickerManagerModel.shared.selectedAssetsImage.removeAll()
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
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
        return ILSFileManager.getDirectorylistatPath(folderName: albumName).count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GalleryCollectionViewCell
        let file = ILSFileManager.getDirectorylistatPath(folderName: albumName)[indexPath.row]
        let data = ILSFileManager.getDatafileatPath(filePath: "\(albumName)/\(file)")
        
        cell.photoImage.image = UIImage(data: data!)
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
    
        // Configure the cell
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(self.isSelected)
        {
            if  PickerManagerModel.shared.selectedAssetsImage.contains(indexPath.row)
            {
                let index : Int = PickerManagerModel.shared.selectedAssetsImage.index(of: indexPath.row)!
                PickerManagerModel.shared.selectedAssetsImage.remove(at: index)
            }
            else
            {
               
                PickerManagerModel.shared.selectedAssetsImage.append(indexPath.row)
                
            }
            
            
            DispatchQueue.main.async {
                collectionView.reloadItems(at: [indexPath])
            }
            
            if  PickerManagerModel.shared.selectedAssetsImage.count > 0
            {
                self.deleteButton.isEnabled = true
            }
            else
            {
                self.deleteButton.isEnabled = false
            }
            
        }
        else
        {
            
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 1.0)
       _ = ILSFileManager.createFile(fileName: "\(self.albumName)\(ILSFileManager.getfileListatPath(folderName: self.albumName).count)", folderName: self.albumName, data: data!)
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
         picker.dismiss(animated: true, completion: nil)
        
    }
    
    func reloadCollection() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }

}
