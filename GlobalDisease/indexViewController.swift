//
//  ViewController.swift
//  GlobalDisease
//
//  Created by 姚思妤 on 2020/6/14.
//  Copyright © 2020 姚思妤. All rights reserved.
//

import UIKit

class indexViewController: UIViewController {

    @IBOutlet weak var indexView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        indexView.image = UIImage(named: "virus.png")
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        performSegue(withIdentifier: "indexToSystem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "indexToSystem"{
            //設定segue的終點view為想跳過去的controller dest為一個controller
            let dest = segue.destination
            dest.modalPresentationStyle = .fullScreen
        }
    }
}

