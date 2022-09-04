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

    func play()
    func pause()
    func goForward()
    func goBack()
}

class MPAudioPlayer: MPAudioPlayerProtocol {
    
    private var audioPlayer: AVQueuePlayer?
    private var playerItems: [AVPlayerItem] = [
        AVPlayerItem(url: URL(string: Bundle.main.path(forResource: "song1", ofType: "mp3")!)!),
        AVPlayerItem(url: URL(string: Bundle.main.path(forResource: "song2", ofType: "mp3")!)!),
        AVPlayerItem(url: URL(string: Bundle.main.path(forResource: "song3", ofType: "mp3")!)!)
    ]
    
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

    private func setupAudioPlayer() {
        
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        
        audioPlayer = AVQueuePlayer(items: playerItems)
    }
    
    func play() {
        audioPlayer?.play()

    }
    
    func pause() {
        audioPlayer?.pause()
    }
    
    func goForward() {
        audioPlayer?.advanceToNextItem()
    }
    
    func goBack() {
        guard let currentItem = audioPlayer?.currentItem, let currentItemIndex = playerItems.firstIndex(of: currentItem) else { return }
        audioPlayer?.advanceToPreviousItem(for: currentItemIndex, with: playerItems)
    }
    
}

extension AVQueuePlayer {
    func advanceToPreviousItem(for currentItem: Int, with initialItems: [AVPlayerItem]) {
        self.removeAllItems()
        for i in currentItem..<initialItems.count {
            let obj: AVPlayerItem? = initialItems[i]
            if self.canInsert(obj!, after: nil) {
                obj?.seek(to: CMTime.zero, completionHandler: nil)
                self.insert(obj!, after: nil)
            }
        }
    }
}


