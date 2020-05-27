//
//  SlidsViewController.swift
//  MyResponse
//
//  Created by Сергей Цыганков on 27.05.2020.
//  Copyright © 2020 Сергей Цыганков. All rights reserved.
//

import UIKit

class SlidsViewController: UIViewController {

    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var pages: UIPageControl!
    
    var presentText = ""
    var curentPage = 0
    var numderOfPages = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = presentText
        pages.numberOfPages = numderOfPages
        pages.currentPage = curentPage
    }
    
}
