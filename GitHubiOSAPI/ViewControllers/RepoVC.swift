//
//  RepoVC.swift
//  GitHubiOSAPI
//
//  Created by Melaniia Hulianovych on 4/13/17.
//  Copyright © 2017 Melaniia Hulianovych. All rights reserved.
//

import UIKit


class RepoVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var qtyReposits: UILabel!
    @IBOutlet weak var stars: UILabel!
    
    
    var repositories = [Repository]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatar.setImageWithURL(url: DataSource.shared.user.avatarURL)
        userName.text = DataSource.shared.user.name
        qtyReposits.text = "5"
        stars.text = "1"
        
        repositories = DataSource.shared.repositories

          self.title = DataSource.shared.user.login
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoCell
        let repo = repositories[indexPath.row]
        cell?.configure(withRepo: repo)
        return cell!
    }
    
    

}

class RepoCell: UITableViewCell {
    
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var repoLanguage: UILabel!
    @IBOutlet weak var repoFork: UILabel!
    @IBOutlet weak var lastUpdate: UILabel!
    @IBOutlet weak var forkIV: UIImageView!
    
    func configure(withRepo repo:Repository) {
        repoName.text = repo.repoName
        repoLanguage.text = repo.language
        repoFork.text = "\(repo.forks)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        lastUpdate.text = "Updated on \(dateFormatter.string(from: repo.lastUpdate))"
        forkIV.maskDownloadImageView()
        
    }
    
    func maskDownloadImageView() {
        forkIV.image = forkIV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        forkIV.tintColor = UIColor(colorLiteralRed: 87/255, green: 96/255, blue: 104/255, alpha: 1)
    }
}
