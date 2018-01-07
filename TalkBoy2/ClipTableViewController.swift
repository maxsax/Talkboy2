//
//  ClipTableViewController.swift
//  TalkBoy2
//
//  Created by Michael on 2018-01-06.
//  Copyright © 2018 Differential Consulting. All rights reserved.
//

import UIKit
import AVFoundation


class ClipTableViewController: UITableViewController {

    
    var clips: [Clip] = []
    var audioPlayer: AVAudioPlayer? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        getClips()
    }
    
    
    
    func getClips() {
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            if let coreDataStuff = try? context.fetch(Clip.fetchRequest()) as? [Clip] {
                if let coreDataClips = coreDataStuff {
                    clips = coreDataClips
                    tableView.reloadData()
                }
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return clips.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let clip = clips[indexPath.row]

        cell.textLabel?.text = clip.name
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
 
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let clip = clips[indexPath.row]
        
        if let audioData = clip.audioData {
            audioPlayer = try? AVAudioPlayer(data: audioData)
            audioPlayer?.play()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let clip = clips[indexPath.row]
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                context.delete(clip)
                try? context.save()
                getClips()
            }
        }
    }
    
}
