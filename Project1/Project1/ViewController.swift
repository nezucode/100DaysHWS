//
//  ViewController.swift
//  Project1
//
//  Created by Nezuko on 20/11/22.
//

import LinkPresentation
import UIKit

class ViewController: UITableViewController {
    
    var picture = [String]()
    var metadata: LPLinkMetadata?
   
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(sharedTapped))
        
        performSelector(inBackground: #selector(loadBundle), with: nil) //Use GCD DispatchQueue.(qos: .background) instead 
        
        tableView.reloadData()
    }
    
    @objc func loadBundle() {
        let fm = FileManager.default // Access to filesystem
        let path = Bundle.main.resourcePath! // Shows the location of the requested file from app bundle[directory]
        let items = try! fm.contentsOfDirectory(atPath: path) // Returns the contents of the file from the bundle at a path
        
        for item in items { // Each time an item is found this loop will iterate
            if item.hasPrefix("nssl"){
                //this is a picture to load
                picture.append(item)
            }
        }
        picture.sort() // Displays each item in a sorted order in the table view
    }
    
    @objc func sharedTapped() -> LPLinkMetadata? {
        let activityView = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        present(activityView, animated: true)
        
        metadata = LPLinkMetadata()
        metadata?.iconProvider = NSItemProvider(object: UIImage(named: "image")!)
        metadata?.imageProvider = NSItemProvider.init(contentsOf:
        Bundle.main.url(forResource: "image", withExtension: "JPG"))
        return metadata
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picture.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = "Picture \(indexPath.row + 1) of \(picture.count)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = picture[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}



