//
//  VoiceRecorderControllerViewController.swift
//  AVFoundation_Audio
//
//  Created by Konstantin Bolgar-Danchenko on 14.10.2022.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isAudioRecordingGranted: Bool!
    var isRecording = false
    var isPlaying = false

    override func viewDidLoad() {
        super.viewDidLoad()
        checkRecordPermission()
    }

    // MARK: - Record Permission

    func checkRecordPermission() {
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            isAudioRecordingGranted = true
            break
        case AVAudioSession.RecordPermission.denied:
            isAudioRecordingGranted = false
            break
        case AVAudioSession.RecordPermission.undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission( { (allowed) in
                if allowed {
                    self.isAudioRecordingGranted = true
                } else {
                    self.isAudioRecordingGranted = false
                }
            })
            break
        default:
            break
        }
    }

    // MARK: - File Manager

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    func getFileURL() -> URL {
        let fileName = "myRecording.m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        return filePath
    }

    // MARK: - Recording

    func setupRecorder() {
        if isAudioRecordingGranted {
            let session = AVAudioSession.sharedInstance()
            do {
                try session.setCategory(
                    AVAudioSession.Category.playAndRecord,
                    options: .defaultToSpeaker
                )
                try session.setActive(true)
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                audioRecorder = try AVAudioRecorder(
                    url: getFileURL(),
                    settings: settings
                )
                audioRecorder.delegate = self
                audioRecorder.isMeteringEnabled = true
                audioRecorder.prepareToRecord()
            } catch let error {
                displayAlert(
                    messageTitle: "Error",
                    messageDescription: error.localizedDescription,
                    actionTitle: "OK"
                )
            }
        } else {
            displayAlert(
                messageTitle: "Error",
                messageDescription: "Missing access to Microphone",
                actionTitle: "OK"
            )
        }
    }

    @IBAction func startRecording(_ sender: Any) {
        if (isRecording) {
            finishAudioRecording(success: true)
            playButton.isEnabled = true
            isRecording = false
        } else {
            setupRecorder()

            audioRecorder.record()
            playButton.isEnabled = false
            isRecording = true
        }
    }

    func finishAudioRecording(success: Bool) {
        if success {
            audioRecorder.stop()
            audioRecorder = nil
        } else {
            displayAlert(
                messageTitle: "Error",
                messageDescription: "Recording failed",
                actionTitle: "OK"
            )
        }
    }

    func audioRecorderDidFinishRecording(
        _ recorder: AVAudioRecorder,
        successfully flag: Bool
    ) {
        if !flag {
            finishAudioRecording(success: false)
        }
        playButton.isEnabled = true
    }

    // MARK: - Playing

    func preparePlay() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL())
            audioPlayer.delegate = self
            audioPlayer.prepareToPlay()
        } catch {
            print("Error")
        }
    }

    @IBAction func playRecording(_ sender: Any) {
        if (isPlaying) {
            audioPlayer.stop()
            recordButton.isEnabled = true
            isPlaying = false
        } else {
            if FileManager.default.fileExists(atPath: getFileURL().path) {
                recordButton.isEnabled = false
                preparePlay()
                audioPlayer.play()
                isPlaying = true
            } else {
                displayAlert(
                    messageTitle: "Error",
                    messageDescription: "Audio file is missing",
                    actionTitle: "OK"
                )
            }
        }
    }

    func audioPlayerDidFinishPlaying(
        _ player: AVAudioPlayer,
        successfully flag: Bool
    ) {
        recordButton.isEnabled = true
        isPlaying = false
    }

    // MARK: - Alert

    func displayAlert(
        messageTitle: String,
        messageDescription: String,
        actionTitle: String
    ) {
        let alertController = UIAlertController(
            title: messageTitle,
            message: messageDescription,
            preferredStyle: .alert
        )
        alertController.addAction(UIAlertAction(
            title: actionTitle,
            style: .default
        ) { (result : UIAlertAction) -> Void in
            _ = self.navigationController?.popViewController(animated: true)
        })
        present(
            alertController,
            animated: true
        )
    }
}
