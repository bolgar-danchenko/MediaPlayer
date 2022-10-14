//
//  VideoPlayerController.swift
//  AVFoundation_Audio
//
//  Created by Konstantin Bolgar-Danchenko on 14.10.2022.
//

import UIKit
import YouTubePlayerKit

class VideoPlayerController: UITableViewController {

    var videos: [String] = ["psL_5RIBqnY", "-rAeqN-Q7x4", "w87fOAG8fjk"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        return videos.count
    }

    override func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "Cell",
            for: indexPath
        )

        cell.textLabel?.text = videos[indexPath.row]


        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        let player = YouTubePlayer(source: .video(id: self.videos[indexPath.row]), configuration: .init(autoPlay: true))
        let youTubePlayerController = YouTubePlayerViewController(player: player)
        self.present(youTubePlayerController, animated: true)
    }
}
