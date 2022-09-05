//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit


protocol MPPlayerScreenPresenterProtocol: AnyObject {
    var songs: [MPSongModel] { get }
    var songDidChange: ((String, String) -> ())? { get set }
    
    func bind()
    func playButtonDidTap()
    func pauseButtonDidTap()
    func backwardButtonDidTap()
    func forwardButtonDidTap()
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProtocol {
    
    private var audioPlayer: MPAudioPlayerProtocol
   
    var songs: [MPSongModel] {
        get {
            audioPlayer.songs
        }
    }

    var songDidChange: ((String, String) -> ())?
    
    init(audioPlayer: MPAudioPlayerProtocol) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.songDidChange = { [weak self] songModel in
            guard let self = self else { return }
            self.songDidChange?(songModel.title, songModel.artist)
        }
    }
    
    func bind() {
        
        // stubbed song data
        let songURLs: [URL] = [
            Bundle.main.url(forResource: "song1", withExtension: "mp3")!,
            Bundle.main.url(forResource: "song2", withExtension: "mp3")!,
            Bundle.main.url(forResource: "song3", withExtension: "mp3")!
        ]
        
        audioPlayer.setupPlayer(songURLs: songURLs)
    }
    
    func playButtonDidTap() {
        audioPlayer.play()
    }
    
    func pauseButtonDidTap() {
        audioPlayer.pause()
    }
    
    func backwardButtonDidTap() {
        audioPlayer.goBack()
    }
    
    func forwardButtonDidTap() {
        audioPlayer.goForward()
    }
}
