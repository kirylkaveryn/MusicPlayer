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
    
    private var audioPlayer: AVPlayer
    private var playerItems: [AVPlayerItem] = [
        AVPlayerItem(url: Bundle.main.url(forResource: "song1", withExtension: "mp3")!),
        AVPlayerItem(url: Bundle.main.url(forResource: "song2", withExtension: "mp3")!),
        AVPlayerItem(url: Bundle.main.url(forResource: "song3", withExtension: "mp3")!)
    ]
    private var currentItem: AVPlayerItem {
        didSet {
            audioPlayer.replaceCurrentItem(with: currentItem)
            currentItem.seek(to: .zero) { [weak self] _ in
                guard let self = self else { return }
                self.audioPlayer.play()
            }
            
        }
    }
    private var currentItemIndex: Int {
        get {
            guard let index = playerItems.firstIndex(of: currentItem) else { return 0 }
            return index
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
    
    init() {
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        currentItem = playerItems.first!
        audioPlayer = AVPlayer(playerItem: currentItem)
    }

    func play() {
        audioPlayer.play()

    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    func goForward() {
        if currentItemIndex < playerItems.count - 1 {
            currentItem = playerItems[currentItemIndex + 1]
        } else if currentItemIndex == (playerItems.count - 1) {
            currentItem = playerItems.first!
        }
    }
    
    func goBack() {
        if currentItemIndex > 0 {
            currentItem = playerItems[currentItemIndex - 1]
        } else if currentItemIndex == 0 {
            currentItem = playerItems.last!
        }
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


