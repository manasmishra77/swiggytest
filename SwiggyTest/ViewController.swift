//
//  ViewController.swift
//  SwiggyTest
//
//  Created by Manas1 Mishra on 28/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    var movie: Movie!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var idLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }
    
    func configureView() {
        self.nameLabel.text = movie.title
        self.idLabel.text = movie.imdbID
    }
    
    


}

