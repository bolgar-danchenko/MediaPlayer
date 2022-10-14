//
//  ViewController.swift
//  AVFoundation_Audio
//
//  Created by Niki Pavlove on 18.02.2021.
//

import UIKit
import AVFoundation

class MusicPlayerController: UIViewController {
    
    var Player = AVAudioPlayer()
    let fileManager = FileManager.default
    var resourcePath = Bundle.main.resourcePath
    var songs = [String]()
    let urls = Bundle.main.urls(forResourcesWithExtension: "mp3", subdirectory: nil)
    var counter = 0

    @IBOutlet weak var songNameLabel: UILabel!

    @IBOutlet weak var playPauseButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        readyToPlay()
        songNameLabel.text = "\(Player.url?.lastPathComponent ?? "")"
    }

    @IBAction func playButton(_ sender: Any) {
        if Player.isPlaying {
            Player.stop()
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @IBAction func stopButton(_ sender: Any) {
        if Player.currentTime != 0 {
            Player.stop()
            Player.currentTime = 0
            playPauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        }
        else {
            print("Already stopped!")
        }
    }

    @IBAction func backwardButton(_ sender: Any) {
        guard let urls = urls else { return }
        if counter == 0 {
            counter = urls.count - 1
            readyToPlay()
            play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            counter -= 1
            readyToPlay()
            play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    @IBAction func forwardButton(_ sender: Any) {
        guard let urls = urls else { return }
        if counter == urls.count - 1 {
            counter = 0
            readyToPlay()
            play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        } else {
            counter += 1
            readyToPlay()
            play()
            playPauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }

    private func play() {
        Player.play()
        songNameLabel.text = Player.url?.lastPathComponent
    }

    private func readyToPlay() {
        do {
            guard let urls = urls else { return }
            Player = try AVAudioPlayer(contentsOf: urls[counter])
            Player.prepareToPlay()
        }
        catch {
            print(error)
        }
    }
}
