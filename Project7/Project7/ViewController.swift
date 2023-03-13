//
//  ViewController.swift
//  Project7
//
//  Created by Nezuko on 06/01/23.
//

import UIKit

class ViewController: UITableViewController {
    // MARK: - Properties
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()
    
    // MARK: - View Management
    override func viewDidLoad() {
        super.viewDidLoad()
        let credits = UIImage(systemName: "info.circle")
        let creditsButton = UIBarButtonItem(image: credits, style: .plain, target: self, action: #selector(showCredits))

        let filter = UIImage(systemName: "line.3.horizontal.decrease.circle")
        let filterButton = UIBarButtonItem(image: filter, style: .plain, target: self, action: #selector(filterPetitions))

        let reset = UIImage(systemName: "arrow.counterclockwise")
        let resetButton = UIBarButtonItem(image: reset, style: .plain, target: self, action: #selector(resetContent))
        
        navigationItem.rightBarButtonItem = creditsButton
        navigationItem.leftBarButtonItems = [filterButton, resetButton]
        
        fetchJSON()
        tableView.reloadData()
        
    }
    
    func fetchJSON(){
        /* "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100" */
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://hackingwithswift.com/samples/petitions-2.json"
        }
        
        DispatchQueue.global(qos: .background).async {
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    self.parse(json: data)
                    return
                }
            }
        }
        showError()
    }
    
    // MARK: - Methods
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    
    func showError(){
        DispatchQueue.main.async {
            let eror = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            eror.addAction(UIAlertAction(title: "Mkay", style: .default))
            self.present(eror, animated: true)
        }
    }
    
    @objc func showCredits(){
        let showInfo = UIAlertController(title: "Info aja nih geys", message: "This all data are comes from We The People API of the Whitehouse.", preferredStyle: .alert)
        showInfo.addAction(UIAlertAction(title: "Sip!", style: .default))
        present(showInfo, animated: true)
    }
    
    @objc func filterPetitions(){
        let ac = UIAlertController(title: "Filter petitions", message: "Type in to filter...", preferredStyle: .alert)
        ac.addTextField()
        
        let filterAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] _ in
            guard let filterWord = ac?.textFields?[0].text else { return }
            self?.performSelector(inBackground: #selector(self?.showPetitions(for:)), with: filterWord)
            self?.tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        ac.addAction(filterAction)
        present(ac, animated: true)
    }
    
    @objc func showPetitions(for filter: String) {
        filteredPetitions = petitions.filter { $0.title.lowercased().contains(filter.lowercased()) }
        print(filteredPetitions)
      
    }
    
    @objc func resetContent(){
        filteredPetitions = petitions
        tableView.reloadData()
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = filteredPetitions[indexPath.row]
        
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // MARK: - Table View Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc .detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
