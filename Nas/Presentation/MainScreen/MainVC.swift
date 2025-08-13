//
//  ViewController.swift
//  Nas
//
//  Created by Ye Lin Aung on 12/08/2025.
//

import UIKit

class MainVC: UIViewController {
    
    private let mainVM = MainVM.shared
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.subscribeData()
        
        self.fetchData()
    }
    
    private func setupUI() {
        
    }
    
    private func subscribeData() {
        
    }
    
    private func fetchData() {
        self.mainVM.fetchNews()
    }

}
