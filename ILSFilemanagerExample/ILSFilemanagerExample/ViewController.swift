//
//  ViewController.swift
//  ILSFilemanagerExample
//
//  Created by Vivek iLeaf on 1/30/18.
//  Copyright © 2018 Vivek iLeaf. All rights reserved.
//

import UIKit
import ILSFileManger

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var albumTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addAlbum(_ sender: Any)
    {
        let alertControler = UIAlertController(title: "Create Album", message: "Please Enter your album name", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { (alert) in
            
            _ = ILSFileManager.createDirectory(directoryName: alertControler.textFields![0].text!)
            DispatchQueue.main.async {
                self.albumTable.reloadData()
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertControler.addTextField { (textField) in
            textField.placeholder = "Enter album name"
        }
        alertControler.addAction(saveAction)
        alertControler.addAction(cancel)
        self.present(alertControler, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ILSFileManager.getDirectorylistatPath(folderName: nil).count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "albumcell")!
        cell.textLabel?.text = ILSFileManager.getDirectorylistatPath(folderName: nil)[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let gallery = self.storyboard?.instantiateViewController(withIdentifier: "GalleryCollectionViewController") as! GalleryCollectionViewController
        gallery.albumName = ILSFileManager.getDirectorylistatPath(folderName: nil)[indexPath.row]
        self.navigationController?.pushViewController(gallery, animated: true)
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, indexPath) in
         let path =  ILSFileManager.getDirectorylistatPath(folderName: nil)[indexPath.row];
       _ = ILSFileManager.removeDirectory(foldername: path)
            DispatchQueue.main.async {
                 tableView.reloadData()
            }
           
        }
        return[deleteAction]
    }


}

