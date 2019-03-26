//
//  DetectingCollectionView.swift
//  visionauts
//
//  Created by Piotr Błachewicz on 17/03/2019.
//  Copyright © 2019 Softnauts. All rights reserved.
//

import UIKit

protocol DetectingPlayerDelegate: class {
    func playButtonDidTap()
    func nextButtonDidTap()
    func previousButtonDidTap()
}

@IBDesignable
class DetectingCollectionView: BaseNibView {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonPrevious: UIButton!
    @IBOutlet weak var buttonPlay: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    
    weak var delegate: DetectingPlayerDelegate?
    var currentIndex: Int = 0
    var isFromPlayButton: Bool = false
    
    var items: [BeaconModel] = []
    
    var testItems: [String] = [
        "This is first item of the collection to show",
        "This is 2nd item of the collection",
        "This is 3rd item of the collection"
    ]
    
    override func setViewApperance() {
        setUpCollectionView()
        setupAccessibility()
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(DetectingCollectionViewCell.self)
    }
    
    func setupAccessibility() {
        buttonPrevious.accessibilityTraits = UIAccessibilityTraits.button
        buttonPrevious.accessibilityLabel = NSLocalizedString("PreviousButtonDescripion", comment: "")
        buttonPlay.accessibilityTraits = UIAccessibilityTraits.button
        buttonPlay.accessibilityLabel = NSLocalizedString("PlayButtonDescription", comment: "")
        buttonNext.accessibilityTraits = UIAccessibilityTraits.button
        buttonNext.accessibilityLabel = NSLocalizedString("NextButtonDescription", comment: "")
    }
}

//MARK: - Player Controls

extension DetectingCollectionView {
    
    @IBAction func buttonPlayTap(_ sender: Any) {
        delegate?.playButtonDidTap()
        UIAccessibility.post(notification: .layoutChanged, argument: collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)))
        self.view.accessibilityElements = [buttonPrevious, buttonPlay, buttonNext]
    }
    
    @IBAction func buttonPreviousTap(_ sender: Any) {
        delegate?.previousButtonDidTap()
    }
    
    @IBAction func buttonNextTap(_ sender: Any) {
        delegate?.nextButtonDidTap()
    }
}

//MARK: - Collection View Delegate

extension DetectingCollectionView: UICollectionViewDelegate {
    
}

//MARK: - Collection Flow Layout

extension DetectingCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.size.width
        let height: CGFloat = collectionView.frame.size.height
        return CGSize(width: width, height: height)
    }
}

//MARK: - Collection View Data Source

extension DetectingCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return testItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: DetectingCollectionViewCell = collectionView.dequeReusableCell(for: indexPath)
        
        let testItem = testItems[indexPath.row]
        
        cell.configure(for: testItem)
        return cell
    }
}
