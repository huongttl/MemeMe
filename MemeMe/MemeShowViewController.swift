//
//  MemeShowViewController.swift
//  MemeMe
//
//  Created by Huong Tran on 1/12/20.
//  Copyright © 2020 RiRiStudio. All rights reserved.
//

import UIKit

class MemeShowViewController: UIViewController {
    var memeToShow: Meme!
    
    @IBOutlet weak var memedImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editMeme))
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        memedImage.image = memeToShow.memedImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @objc func editMeme() {
        let editVC = storyboard?.instantiateViewController(identifier: "MemeEditViewController") as! MemeEditViewController
        editVC.memeToEdit = memeToShow
        navigationController?.pushViewController(editVC, animated: true)
    }
}
