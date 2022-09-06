//
//  MPAudioPlayer.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVFoundation
import UIKit

struct MPTrackModel {
    let title: String
    let artist: String
    let artwork: UIImage
}

struct Progress {
    let duration: CMTime
    let currentTime: CMTime
}

protocol MPAudioPlayerProtocol {
    var tracks: [MPTrackModel] { get }
    
    var trackDidChange: ((MPTrackModel) -> ())? { get set }
    var progressDidChange: ((Progress) -> ())? { get set }

    func setupPlayer(tracksURLs: [URL])
    func play()
    func pause()
    func goForward()
    func goBack()
    func goToTrack(index: Int)
}

class MPAudioPlayer: MPAudioPlayerProtocol {
    var trackDidChange: ((MPTrackModel) -> ())?
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
            // create new player and update subscribers
            audioPlayer.replaceCurrentItem(with: currentItem)
            trackDidChange?(tracks[currentItemIndex])
        }
    }
    private var currentItemIndex: Int? {
        get {
            guard let currentItem = currentItem,
                  let index = playerItems.firstIndex(of: currentItem) else { return nil }
            return index
        }
    }
    
    var tracks: [MPTrackModel] {
        get {
            playerItems.map { getSongModelFrom($0) }
        }
    }
    
    /// Initilaze MPAudioPlayer instance with emply tracks queue.
    ///
    /// To setup player with tracks call:
    /// ```
    /// func setupPlayer(tracksURLs: [URL])
    /// ```
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        audioPlayer = AVPlayer(playerItem: nil)
        startProgressObserving()
    }
    
    /// Setup progress bar updating with timer.
    private func startProgressObserving() {
        audioPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 60), queue: .main) { [weak self] time in
            guard let self = self, let currentItem = self.audioPlayer.currentItem else { return }
            let progress = Progress(duration: currentItem.asset.duration,
                                    currentTime: time)
            self.progressDidChange?(progress)
        }
    }
    
    func setupPlayer(tracksURLs: [URL]) {
        for url in tracksURLs {
            playerItems.append(AVPlayerItem(url: url))
        }
        guard let firstItem = playerItems.first else { return print("There is no tracks") }
        currentItem = firstItem
        // play and pause is used bucause of AVPlayerItem.duration
        // is available only after starting of playing
        play()
        pause()
    }

    func play() {
        audioPlayer.play()
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    /// Will play next track. If track is last in queue, will play first.
    func goForward() {
        guard let currentItemIndex = currentItemIndex else { return }
        let isPlaying = audioPlayer.isPlaying
        if currentItemIndex < playerItems.count - 1 {
            currentItem = playerItems[currentItemIndex + 1]
        } else if currentItemIndex == (playerItems.count - 1) {
            currentItem = playerItems.first!
        }
        // cuntinue playing when previous track was played
        if isPlaying { play() }

    }
    
    /// Will play previous track. Is track is first in queue, will play last.
    func goBack() {
        guard let currentItemIndex = currentItemIndex else { return }
        let isPlaying = audioPlayer.isPlaying
        if currentItemIndex > 0 {
            currentItem = playerItems[currentItemIndex - 1]
        } else if currentItemIndex == 0 {
            currentItem = playerItems.last!
        }
        // cuntinue playing when previous track was played
        if isPlaying { play() }
        
    }
    
    func goToTrack(index: Int) {
        guard (0...playerItems.count - 1).contains(index) else { return }
        currentItem = playerItems[index]
    }
    
    /// Parse AVPlayerItem to MPSongModel with asset keys.
    private func getSongModelFrom(_ playerItem: AVPlayerItem) -> MPTrackModel {
        
        let title = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyTitle, keySpace: AVMetadataKeySpace.common).first?.value as? String
        let artist = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtist, keySpace: AVMetadataKeySpace.common).first?.value as? String
        let artworkData = AVMetadataItem.metadataItems(from: playerItem.asset.commonMetadata, withKey: AVMetadataKey.commonKeyArtwork, keySpace: AVMetadataKeySpace.common).first?.value as? Data
        
        // parse artwork image from metadata's data
        var artwork: UIImage
        if let artworkData = artworkData, let image = UIImage(data: artworkData) {
            artwork = image
        } else {
            // default artwork image
            artwork = UIImage(systemName: "music.note.list")!
        }
        
        // setup new track model
        let trackModel = MPTrackModel(title: title ?? "unknown",
                    artist: artist ?? "unknown",
                    artwork: artwork)
        return trackModel
    }
}

extension AVPlayer {
    var isPlaying: Bool {
        rate != 0 && error == nil
    }
}

