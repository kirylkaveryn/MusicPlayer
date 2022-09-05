//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit


protocol MPPlayerScreenPresenterProtocol: AnyObject {
    var songsCount: Int { get }
    var songsImages: [UIImage] { get }

    var songDidChange: ((String, String) -> ())? { get set }
    var progressDidChange: ((Progress) -> ())? { get set }

    func bind()
    func playButtonDidTap()
    func pauseButtonDidTap()
    func backwardButtonDidTap()
    func forwardButtonDidTap()
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProtocol {
    
    private var audioPlayer: MPAudioPlayerProtocol
   
    var songsCount: Int {
        get {
            audioPlayer.songs.count
        }
    }
    
    var songsImages: [UIImage] {
        get {
            audioPlayer.songs.map { $0.artwork }
        }
    }

    var songDidChange: ((String, String) -> ())?
    var progressDidChange: ((Progress) -> ())?

    init(audioPlayer: MPAudioPlayerProtocol) {
        self.audioPlayer = audioPlayer
        self.audioPlayer.songDidChange = { [weak self] songModel in
            guard let self = self else { return }
            self.songDidChange?(songModel.title, songModel.artist)
        }
        self.audioPlayer.progressDidChange = { [weak self] progress in
            guard let self = self else { return }
            self.progressDidChange?(progress)
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
