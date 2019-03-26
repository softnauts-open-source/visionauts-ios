//
//  HelpViewController.swift
//  visionauts
//
//  Created by Renata Makuch on 19/02/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController, CustomNavigationBarDelegate {
    
    @IBOutlet weak var customNavigationBar: CustomNavigationBar!
    @IBOutlet weak var textView: UITextView!
    
    // Coordinator
    weak var coordinator: Coordinator?
    
    // Voice synthesizer
    let voiceSynthesizer = ServiceFactory.voiceSynthesizerService
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        voiceSynthesizer.stopSpeaking()
    }
    
    //MARK: - Setup
    
    func setup() {
        customNavigationBar.delegate = self
        setupHelpText()
    }
    
    func setupHelpText() {
        let helpString = NSLocalizedString("helpText", comment: "")
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.65
        let atributes: [NSAttributedString.Key: Any] = [.font: UIFont(name: "ProximaNova-Bold", size: 18.0)!,
                                                       .foregroundColor: UIColor.white,
                                                       .paragraphStyle: style]
        
        textView.attributedText = NSAttributedString(string: helpString, attributes: atributes)
        textView.accessibilityLabel = helpString
        voiceSynthesizer.speak(helpString)
    }
    
    //MARK: - Navigation
    
    func leftButtonDidTap() {
        coordinator?.back()
    }
}

