//
//  MPAudioPlayer.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVFoundation
import UIKit

struct MPSongModel {
    let title: String
    let artist: String
    let artwork: UIImage
}

struct Progress {
    let duration: CMTime
    let currentTime: CMTime
}

protocol MPAudioPlayerProtocol {
    var songs: [MPSongModel] { get }
    var songDidChange: ((MPSongModel) -> ())? { get set }
    var progressDidChange: ((Progress) -> ())? { get set }

    func setupPlayer(songURLs: [URL])
    func play()
    func pause()
    func goForward()
    func goBack()
}

class MPAudioPlayer: MPAudioPlayerProtocol {
    var songDidChange: ((MPSongModel) -> ())?
    var progressDidChange: ((Progress) -> ())?

    private var audioPlayer: AVPlayer
    private var playerItems: [AVPlayerItem] = []
    private var currentItem: AVPlayerItem? {
        willSet {
            // roll back item playing progress
            currentItem?.seek(to: .zero) { _ in }
        }
        didSet {
            guard let currentItem = currentItem,
                  let currentItemIndex = currentItemIndex else { return }
            // create new player and start playing
            audioPlayer.replaceCurrentItem(with: currentItem)
            songDidChange?(self.songs[currentItemIndex])
        }
    }
    private var currentItemIndex: Int? {
        get {
            if let currentItem = currentItem, let index = playerItems.firstIndex(of: currentItem) { return index }
            return nil
        }
    }
    
    var songs: [MPSongModel] {
        get {
            playerItems.map { getSongModelFrom($0) }
        }
    }
    
    
    /// Initilaze MPAudioPlayer instance with emply songs queue.
    ///
    /// To setup player with songs call:
    /// ```
    /// func setupPlayer(songURLs: [URL])
    /// ```
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        audioPlayer = AVPlayer(playerItem: nil)
        
        // sutup progress bar updating with timer
        audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 60), queue: .main) { [weak self] time in
            guard let self = self, let currentItem = self.audioPlayer.currentItem else { return }
            print(currentItem.asset.duration)
            let progress = Progress(duration: currentItem.asset.duration,
                                    currentTime: time)
            self.progressDidChange?(progress)
        }
    }
    
    func setupPlayer(songURLs: [URL]) {
        for url in songURLs {
            playerItems.append(AVPlayerItem(url: url))
        }
        guard let firstItem = playerItems.first else { return print("There is no songs") }
        currentItem = firstItem
        // play and pause is used bucause of AVPlayerItem.duration is available
        // only after starting of playing
        play()
        pause()
    }

    func play() {
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    /// Will play next song. If song is last in queue, will play first.
    func goForward() {
        guard let currentItemIndex = currentItemIndex else { return }
        
        if currentItemIndex < playerItems.count - 1 {
            currentItem = playerItems[currentItemIndex + 1]
        } else if currentItemIndex == (playerItems.count - 1) {
            currentItem = playerItems.first!
        }
        play()
    }
    
    /// Will play previous song. Is song is first in queue, will play last.
    func goBack() {
        guard let currentItemIndex = currentItemIndex else { return }

        if currentItemIndex > 0 {
            currentItem = playerItems[currentItemIndex - 1]
        } else if currentItemIndex == 0 {
            currentItem = playerItems.last!
        }
        play()
    }
    
    /// Parse AVPlayerItem to MPSongModel with asset keys.
    private func getSongModelFrom(_ playerItem: AVPlayerItem) -> MPSongModel {
        
        let title = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyTitle, keySpace: AVMetadataKeySpace.common).first?.value as? String
        let artist = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtist, keySpace: AVMetadataKeySpace.common).first?.value as? String
        let artworkData = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtwork, keySpace: AVMetadataKeySpace.common).first?.value as? Data
        
        var artwork: UIImage
        if let artworkData = artworkData {
            artwork = UIImage(data: artworkData) ?? UIImage(systemName: "person")!
        } else {
            artwork = UIImage(systemName: "person")!
        }

        let songModel = MPSongModel(title: title ?? "unknown",
                    artist: artist ?? "unknown",
                    artwork: artwork)
        return songModel
    }
}

