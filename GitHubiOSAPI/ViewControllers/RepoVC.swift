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
    var selectedRow = 0
    
    var repositories = [Repository]()
    override func viewDidLoad() {
        super.viewDidLoad()
        userAvatar.setImageWithURL(url: DataSource.shared.user.avatarURL)
        userName.text = DataSource.shared.user.name
        qtyReposits.text = "\(DataSource.shared.user.publicRepo)"
        stars.text = "\(DataSource.shared.user.starsCount)"
        navigationItem.hidesBackButton = true
        repositories = DataSource.shared.repositories
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
          self.title = DataSource.shared.user.login
        self.automaticallyAdjustsScrollViewInsets = false
    }

    
    func signOut() {
        ServerManager.shared.signOutAsUser()
        self.navigationController?.popToRootViewController(animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath) as? RepoCell
        let repo = repositories[indexPath.row]
        cell?.configure(withRepo: repo)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        ServerManager.shared.getCommitsForRepository(withRepo: repositories[indexPath.row].repoName) {
            [weak self](result: [Commit]?) in
            DataSource.shared.repositories[indexPath.row].commits = result!
            self?.instantiateCommits()
        }
        
        
    }
    
    func tableView( _ tableView: UITableView, heightForHeaderInSection section: Int ) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func instantiateCommits() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            let sb = UIStoryboard.init(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "CommitsVC") as! CommitsTVC
            vc.commits = DataSource.shared.repositories[self.selectedRow].commits
            vc.nameOfRepo = DataSource.shared.repositories[self.selectedRow].repoName
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        if repo.forks == 0 {
            repoFork.isHidden = true
            forkIV.isHidden = true
        } else {
            repoFork.isHidden = false
            forkIV.isHidden = false
            repoFork.text = "\(repo.forks)"
        }
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
