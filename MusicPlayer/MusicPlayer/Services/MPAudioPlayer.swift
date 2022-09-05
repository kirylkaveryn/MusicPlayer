//
//  MPAudioPlayer.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVFoundation

struct MPSongModel {
    let title: String
    let artist: String
    let duration: TimeInterval
}


protocol MPAudioPlayerProtocol {
    var songs: [MPSongModel] { get }
    var songDidChange: ((MPSongModel) -> ())? { get set }

    func setupPlayer(songURLs: [URL])
    func play()
    func pause()
    func goForward()
    func goBack()
}

class MPAudioPlayer: MPAudioPlayerProtocol {
    var songDidChange: ((MPSongModel) -> ())?
    
    private var audioPlayer: AVPlayer
    private var playerItems: [AVPlayerItem] = []
    private var currentItem: AVPlayerItem? {
        didSet {
            guard let currentItem = currentItem,
                  let currentItemIndex = currentItemIndex else { return }
            // create new player and roll back playing progress
            audioPlayer.replaceCurrentItem(with: currentItem)
            currentItem.seek(to: .zero) { [weak self] _ in
                guard let self = self else { return }
                // start playing and update subscribers
                self.audioPlayer.play()
                self.songDidChange?(self.songs[currentItemIndex])
            }
        }
    }
    private var currentItemIndex: Int? {
        get {
            if let currentItem = currentItem, let index = playerItems.firstIndex(of: currentItem) { return index }
            return nil
        }
    }
    
    var songs: [MPSongModel] {
        // FIXME: - parser from AVPlayerItem to MPSongModel
        get {
            [
                MPSongModel(title: "title1",
                            artist: "artist1",
                            duration: 1),
                MPSongModel(title: "title2",
                            artist: "artist2",
                            duration: 1),
                MPSongModel(title: "title3",
                            artist: "artist3",
                            duration: 1)
            ]
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
    }
    
    func setupPlayer(songURLs: [URL]) {
        for url in songURLs {
            playerItems.append(AVPlayerItem(url: url))
        }
        guard let firstItem = playerItems.first else { return print("There is no songs") }
        currentItem = firstItem
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
    }
    
    /// Will play previous song. Is song is first in queue, will play last.
    func goBack() {
        guard let currentItemIndex = currentItemIndex else { return }

        if currentItemIndex > 0 {
            currentItem = playerItems[currentItemIndex - 1]
        } else if currentItemIndex == 0 {
            currentItem = playerItems.last!
        }
    }
    
}

