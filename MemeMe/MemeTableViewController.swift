//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Huong Tran on 1/10/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let delegate = object as! AppDelegate
        return delegate.memes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addMeme))
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
        print("LIST \(memes.count)")
        
        if memes.count == 0 {
            addMemeWithNoAnimation()
        }
    }
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print("COUNT table\(memes.count)")
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeTableViewCell") as! MemeTableViewCell
        let dic = memes[(indexPath as NSIndexPath).row]
        cell.memeImage.image = dic.memedImage
        cell.memeLabel.text = dic.topText.prefix(5) + "..." + dic.bottomText.suffix(5)
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let showVC = storyboard?.instantiateViewController(identifier: "MemeShowViewController") as! MemeShowViewController
        let memeToSend = memes[(indexPath as NSIndexPath).row]
        showVC.memeToShow = memeToSend
        navigationController?.pushViewController(showVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.height/6.0
    }
    
    @objc func addMeme() {
        let editVC = storyboard?.instantiateViewController(identifier: "MemeEditViewController") as! MemeEditViewController
        navigationController?.pushViewController(editVC, animated: true)
    }
    func addMemeWithNoAnimation() {
        let editVC = storyboard?.instantiateViewController(identifier: "MemeEditViewController") as! MemeEditViewController
        editVC.cancelButonIsEnabled = false
        navigationController?.pushViewController(editVC, animated: false)
    }
}
