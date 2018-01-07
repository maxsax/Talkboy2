//
//  AddClipViewController.swift
//  TalkBoy2
//
//  Created by Michael on 2018-01-06.
//  Copyright © 2018 Differential Consulting. All rights reserved.
//

import UIKit
import AVFoundation

class AddClipViewController: UIViewController {

    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    var audioRecorder: AVAudioRecorder?
    var audiopPlayer: AVAudioPlayer?
    var audioURL: URL?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the audio recorder
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try? session.overrideOutputAudioPort(.speaker)
        try? session.setActive(true)
        
        // URL to save audion to sandbox
        if let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
            let pathComponents = [basePath, "audio.m4a"] // path compnenetrs needs to be an array
            
            if let audioURL = NSURL.fileURL(withPathComponents: pathComponents) {
                // Create settings
                
                self.audioURL = audioURL
                var settings : [String:Any] = [:]
                settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC)
                settings[AVSampleRateKey] = 44100.0
                settings[AVNumberOfChannelsKey] = 2
                
                // Create audio recorder
                audioRecorder = try? AVAudioRecorder(url: audioURL, settings: settings)
                audioRecorder?.prepareToRecord()
            }
        }
        
        // Setup UI state
        recordButton.isEnabled = true
        playButton.isEnabled = false
        addButton.isEnabled = false
    }
    
    
    
    @IBAction func recordTapped(_ sender: Any) {
        if let audioRecorder = self.audioRecorder {
            
            if audioRecorder.isRecording {
                audioRecorder.stop()
                recordButton.setTitle("Record", for: .normal)
                recordButton.isEnabled = true
                playButton.isEnabled = true
                addButton.isEnabled = true
                
            } else {
                audioRecorder.record()
                recordButton.setTitle("Stop", for: .normal)
                recordButton.isEnabled = true
                playButton.isEnabled = false
                addButton.isEnabled = false
            }
        }
    }
    
    
    
    @IBAction func playTapped(_ sender: Any) {
        if let audioURL = self.audioURL {
            try? audiopPlayer = AVAudioPlayer(contentsOf: audioURL)
            audiopPlayer?.play()
        }
    }
    
    
    
    @IBAction func addTapped(_ sender: Any) {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let clip = Clip(entity: Clip.entity(), insertInto: context)
            clip.name = nameTextField.text
            
            if let audioURL = self.audioURL {
                clip.audioData = try? Data(contentsOf: audioURL)
                try? context.save()
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
}
