//
//  ViewController.swift
//  XCheater
//
//  Created by Vahagn Nurijanyan on 2021-06-26.
//  Copyright © 2021 X INC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

        private let cheater = Cheater()
        
        private let newButton: UIButton = {
            let button = UIButton(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - 140.0, y: 60.0), size: CGSize(width: 120.0, height: 40.0)), title: "New Game")
            return button
        }()

        private let purchaseButton: UIButton = {
            let button = UIButton(frame: CGRect(origin: CGPoint(x: UIScreen.main.bounds.width - 180.0, y: UIScreen.main.bounds.height - 60.0), size: CGSize(width: 160.0, height: 40.0)), title: "In App Purchase")
            return button
        }()

        private let gridCollectionView: UICollectionView = {
            let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
            collectionView.backgroundColor = .blue
            collectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: "grid")
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            return collectionView
        }()
        override func viewDidLoad() {
            super.viewDidLoad()
            gridCollectionView.dataSource = self
            gridCollectionView.delegate = self
            [newButton, purchaseButton, gridCollectionView].forEach(view.addSubview(_:))
            gridCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            gridCollectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            gridCollectionView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            gridCollectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
            newButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
            purchaseButton.addTarget(self, action: #selector(purchase), for: .touchUpInside)
            if cheater.isPurchased {
                purchaseButton.isHidden = true
            }
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                self.ask(title: Constants.newGameQuestion) { [weak self] _ in
                    if let index = self?.cheater.makeRecommendedMove() {
                        (self?.gridCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! GridCollectionViewCell).letter = "X"
                    }
                }
            }
        }

    // MARK: - Target Actions
        
        @objc func newGame() {
            cheater.letters = [String](repeating: " ", count: 9)
            gridCollectionView.reloadData()
            cheater.firstMoveIsMine = false//we need this because "No" hasn't action
            ask(title: Constants.newGameQuestion) { [weak self] _ in
                if let index = self?.cheater.makeRecommendedMove() {
                    (self?.gridCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! GridCollectionViewCell).letter = "X"
                }
                self?.cheater.firstMoveIsMine = true
            }
        }

        @objc func purchase() {
            ask(title: Constants.inAppPurchaseQuestion) { [weak self] _ in
                //In-App Purchise Code
                //if purchise was successful
                self?.purchaseButton.isHidden = true
                self?.cheater.isPurchased = true
            }

        }
    }

    extension ViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
            
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 9
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "grid", for: indexPath)
            (cell as! GridCollectionViewCell).letter = cheater.letters[indexPath.row]
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let widthHeight = UIScreen.main.bounds.width / 3.0 - 8.0
            return CGSize(width: widthHeight, height: widthHeight)
        }
        
        //inputs opponent's letter, then the player's recommended one
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let index = indexPath.row
            let letter = cheater.firstMoveIsMine ? "O" : "X"
            cheater.letters[index] = letter
            (collectionView.cellForItem(at: indexPath) as! GridCollectionViewCell).letter = letter
            //we assume if cheater.letters isn't empty, cheater.makeRecommendedMove() takes long time to be executed
            if(cheater.isPurchased) {
                collectionView.isUserInteractionEnabled = false//we need this for not queueing touch events to be executed later
                if let index = self.cheater.makeRecommendedMove() {
                    let letter = self.cheater.firstMoveIsMine ? "X" : "O"
//                    self.cheater.letters[index] = letter
                    (collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! GridCollectionViewCell).letter = letter
                }
                collectionView.isUserInteractionEnabled = true

            } else {
                //here we can use something like GoogleMobileAds framework
                let adViewController = AdViewController()
                present(adViewController, animated: true)
                DispatchQueue.global(qos: .utility).async { [unowned self] in
                    if let index = self.cheater.makeRecommendedMove() {
                        let letter = self.cheater.firstMoveIsMine ? "X" : "O"
//                        self.cheater.letters[index] = letter
                        //it must be in main thread because it triggers interface related functionality in the letter's observer
                        DispatchQueue.main.sync {
                            (collectionView.cellForItem(at: IndexPath(item: index, section: 0)) as! GridCollectionViewCell).letter = letter
                        }
                    }
                    //dismiss(_:) must be executed even if index is nil
                    DispatchQueue.main.sync {
                        adViewController.dismiss(animated: true)
                    }

                }
            }
        }
    }

