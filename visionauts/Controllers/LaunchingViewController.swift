//
//  LaunchScreenViewController.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit
import Alamofire

class LaunchingViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    // Main coordinator
    weak var coordinator: MainCoordinator?
    
    // Beacons view model
    lazy var beaconsViewModel: BeaconsViewModel = {
        return BeaconsViewModel()
    }()
    
   //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    //MARK: - Setup
    
    func setup() {
        if ServiceFactory.apiService.isConnectedToNetwork() {
            getBeaconsFromAPI()
        } else {
            setupProgressView()
        }
    }
    
    func setupProgressView() {
        DispatchQueue.main.async {
            CATransaction.begin()
            CATransaction.setCompletionBlock({
                self.goToMainScreen()
            })
            self.progressView.setProgress(1.0, animated: true)
            CATransaction.commit()
        }
    }
    
    // MARK: - Beacons from api
    
    func getBeaconsFromAPI() {
        ServiceFactory.apiService.apiDataRequest(BeaconsRouter.getBeacons, OAuth: false) { [weak self] (response) in
            guard let strongSelf = self else { return }
            switch response {
            case .success(let data):
                strongSelf.beaconsViewModel.saveBeacons(data)
                strongSelf.setupProgressView()
            case .failure(let message):
                print(message)
            }
        }
    }
    
    //MARK: - Main screen
    
    func goToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.prepareTransition()
            self.coordinator?.openDetectingBeacons()
        }
    }
    
    func prepareTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        
        self.navigationController?.view.layer.add(transition, forKey: nil)
    }
}

