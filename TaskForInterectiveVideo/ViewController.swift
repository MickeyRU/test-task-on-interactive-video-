//
//  ViewController.swift
//  TaskForInterectiveVideo
//
//  Created by Павел Афанасьев on 21.06.2022.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Создаем объекты
    
    let videoLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let allowdedForTapArea: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let userVector: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Hand")
        return view
    }()
    
    let leftTimer: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "BasicWhiteLeftVector")
        return view
    }()
    
    let leftTimerShadow: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ShadowBasicWhiteLeftVector")
        return view
    }()
    
    let rightTimer: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "BasicWhiteRightVector")
        return view
    }()
    
    let rightTimerShadow: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "ShadowBasicWhiteRightVector")
        return view
    }()
    
    let targetVector: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Vector")
        return view
    }()
    
    //MARK: - Делаем Инициализацию
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        playVideo()
        setupGestures()
    }
    
    func layout() {
        view.addSubview(videoLayer)
        videoLayer.addSubview(allowdedForTapArea)
        [userVector, leftTimer, leftTimerShadow, rightTimer, rightTimerShadow, targetVector].forEach{allowdedForTapArea.addSubview($0)}
        
        NSLayoutConstraint.activate([
            videoLayer.topAnchor.constraint(equalTo: view.topAnchor),
            videoLayer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoLayer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            videoLayer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            allowdedForTapArea.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            allowdedForTapArea.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            allowdedForTapArea.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            allowdedForTapArea.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            userVector.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            userVector.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
            leftTimer.topAnchor.constraint(equalTo: allowdedForTapArea.topAnchor, constant: 48),
            leftTimer.leadingAnchor.constraint(equalTo: allowdedForTapArea.leadingAnchor, constant: 25),
            leftTimer.bottomAnchor.constraint(equalTo: allowdedForTapArea.bottomAnchor, constant: -48),
            
            leftTimerShadow.topAnchor.constraint(equalTo: leftTimer.topAnchor),
            leftTimerShadow.leadingAnchor.constraint(equalTo: leftTimer.leadingAnchor,constant: 5),
            leftTimerShadow.bottomAnchor.constraint(equalTo: leftTimer.bottomAnchor),
            
            rightTimer.topAnchor.constraint(equalTo: allowdedForTapArea.topAnchor, constant: 48),
            rightTimer.trailingAnchor.constraint(equalTo: allowdedForTapArea.trailingAnchor, constant: -25),
            rightTimer.bottomAnchor.constraint(equalTo: allowdedForTapArea.bottomAnchor, constant: -48),
            
            rightTimerShadow.topAnchor.constraint(equalTo: rightTimer.topAnchor),
            rightTimerShadow.trailingAnchor.constraint(equalTo: rightTimer.trailingAnchor,constant: -5),
            rightTimerShadow.bottomAnchor.constraint(equalTo: rightTimer.bottomAnchor),
            
            targetVector.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            targetVector.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            
        ])
    }
    
    //MARK: - Создаем Методы
    
    // Функция воспроизведения видео на заднем фоне
    func playVideo() {
        guard let path = Bundle.main.path(forResource: "FastTyping", ofType: "mp4") else {
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        [allowdedForTapArea, userVector, leftTimer, leftTimerShadow, rightTimer, rightTimerShadow, targetVector].forEach{videoLayer.bringSubviewToFront($0)}
    }
    
    // Настраваем анимацию руки по движению по экрану
    private func setupGestures() {
        userVector.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        userVector.isUserInteractionEnabled = true
    }
    
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
            print("began")
        } else if gesture.state == .changed {
            let translation = gesture.translation(in: allowdedForTapArea)
            userVector.transform = CGAffineTransform(
                translationX: translation.x,
                y: translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 1, options: .curveEaseIn) {
                self.userVector.transform = .identity
            }
        }
        
    }
}
