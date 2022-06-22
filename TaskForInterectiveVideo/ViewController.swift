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
        view.isHidden = true
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
    
    let startTargetVector: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "Vector")
        return view
    }()
    
    let timerLeftLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    let timerRightLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    var countdownTimer = Timer()
    var durationTimer = 0
    
    // Создал 2 переменные для настроек констрейнтов startTargetVector, чтобы в дальнейшем их использовать для анимации
    private var centralXAnchorTargetVector = NSLayoutConstraint()
    private var centralYAnchorTargetVector = NSLayoutConstraint()
    
    
    
    
    //MARK: - Делаем Инициализацию
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        layout()
        setupStartGestures()
        playVideo()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupHandmovingGestures()
    }
    
    
    func layout() {
        view.addSubview(videoLayer)
        videoLayer.addSubview(allowdedForTapArea)
        [leftTimer, leftTimerShadow, rightTimer, rightTimerShadow, timerLeftLabel, timerRightLabel, startTargetVector, userVector].forEach{allowdedForTapArea.addSubview($0)}
        
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
            
            timerLeftLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            timerLeftLabel.leadingAnchor.constraint(equalTo: allowdedForTapArea.leadingAnchor, constant: 48),
            
            rightTimer.topAnchor.constraint(equalTo: allowdedForTapArea.topAnchor, constant: 48),
            rightTimer.trailingAnchor.constraint(equalTo: allowdedForTapArea.trailingAnchor, constant: -25),
            rightTimer.bottomAnchor.constraint(equalTo: allowdedForTapArea.bottomAnchor, constant: -48),
            
            rightTimerShadow.topAnchor.constraint(equalTo: rightTimer.topAnchor),
            rightTimerShadow.trailingAnchor.constraint(equalTo: rightTimer.trailingAnchor,constant: -5),
            rightTimerShadow.bottomAnchor.constraint(equalTo: rightTimer.bottomAnchor),
            
            timerRightLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            timerRightLabel.trailingAnchor.constraint(equalTo: allowdedForTapArea.trailingAnchor, constant: -48),
            
        ])
        
        // Переписываю констрейнты targetVector в другом формате для анимации
        centralXAnchorTargetVector = startTargetVector.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        centralYAnchorTargetVector = startTargetVector.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        
        NSLayoutConstraint.activate([
            centralXAnchorTargetVector,
            centralYAnchorTargetVector,
        ])
        
    }
    
    //MARK: - Создаем Методы
    
    // Функция воспроизведения видео на заднем фоне
    func playVideo() {
        guard let url = Bundle.main.url(forResource: "FastTyping", withExtension: "mp4") else {
            return
        }
        let asset = AVAsset(url: url)
        let duration = asset.duration
        let durationTime = CMTimeGetSeconds(duration)
        
        print(durationTime)
        durationTimer = Int(durationTime)
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.view.bounds
        playerLayer.videoGravity = .resizeAspectFill
        self.videoLayer.layer.addSublayer(playerLayer)
        
        player.play()
        
        [allowdedForTapArea, userVector, leftTimer, leftTimerShadow, rightTimer, rightTimerShadow, timerLeftLabel, timerRightLabel, startTargetVector].forEach{videoLayer.bringSubviewToFront($0)}
        
    }
    
    // Настраваем таймер обратного отсчета
    private func setupStartGestures() {
        startTargetVector.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tapToStart)))
        startTargetVector.isUserInteractionEnabled = true
    }
    
    @objc func timerAction() {
        userVector.isHidden = false
        if durationTimer > 0 {
            durationTimer -= 1
        }
        
        timerLeftLabel.text = "\(durationTimer)"
        timerRightLabel.text = "\(durationTimer)"
        
        if durationTimer == 0 {
            countdownTimer.invalidate()
        }
    }
    
    @objc private func tapToStart() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    
    // Настраваем анимацию руки по движению по экрану
    private func setupHandmovingGestures() {
        startTargetVector.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(self.handlePanGesture)))
        startTargetVector.isUserInteractionEnabled = true
    }
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .began {
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
