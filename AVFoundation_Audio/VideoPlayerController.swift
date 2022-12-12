//
//  VideoPlayerController.swift
//  AVFoundation_Audio
//
//  Created by Konstantin Bolgar-Danchenko on 14.10.2022.
//

import Foundation
import UIKit
import YouTubePlayerKit

class VideoPlayerController: UITableViewController {

    var videos: [String: String] = ["WWDC 2019" : "psL_5RIBqnY", "September Event 2019" : "-rAeqN-Q7x4", "WWDC 2014" : "w87fOAG8fjk"]

    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return videos.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        
        cell.textLabel?.text = Array(videos)[indexPath.row].key
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)
        
        let videoID = Array(videos)[indexPath.row].value
        
        DispatchQueue.main.async {
            let player = YouTubePlayer(source: .video(id: videoID), configuration: .init(autoPlay: true))
            let youTubePlayerController = YouTubePlayerViewController(player: player)
            self.present(youTubePlayerController, animated: true)
        }
    }
}
