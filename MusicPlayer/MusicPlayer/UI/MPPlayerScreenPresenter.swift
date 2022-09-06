//
//  MPPlayerScreenPresenter.swift
//  MusicPlayer
//
//  Created by Kirill on 4.09.22.
//

import Foundation
import AVKit


protocol MPPlayerScreenPresenterProtocol: AnyObject {
    var tracksCount: Int { get }
    var tracksImages: [UIImage] { get }

    var trackDidChange: ((String, String, Int) -> ())? { get set }
    var progressDidChange: ((Progress) -> ())? { get set }

    func bind()
    func playButtonDidTap()
    func pauseButtonDidTap()
    func backwardButtonDidTap()
    func forwardButtonDidTap()
    func goToSong(inex: Int)
}

class MPPlayerScreenPresenter: MPPlayerScreenPresenterProtocol {
    
    private var resourсeService: MPResourсeServiceProtocol
    private var audioPlayer: MPAudioPlayerProtocol
   
    var tracksCount: Int {
        get {
            audioPlayer.tracks.count
        }
    }
    
    var tracksImages: [UIImage] {
        get {
            audioPlayer.tracks.map { $0.artwork }
        }
    }

    var trackDidChange: ((String, String, Int) -> ())?
    var progressDidChange: ((Progress) -> ())?

    init(resourceService: MPResourсeServiceProtocol, audioPlayer: MPAudioPlayerProtocol) {
        self.resourсeService = resourceService
        self.audioPlayer = audioPlayer
        
        // setup binding closures
        self.audioPlayer.trackDidChange = { [weak self] trackModel, index in
            guard let self = self else { return }
            self.trackDidChange?(trackModel.title, trackModel.artist, index)
        }
        self.audioPlayer.progressDidChange = { [weak self] progress in
            guard let self = self else { return }
            self.progressDidChange?(progress)
        }
    }
    
    func bind() {
        guard let tracksURLs = resourсeService.fetchTracksURL() else { return }
        audioPlayer.setupPlayer(tracksURLs: tracksURLs)
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
    
    func goToSong(inex: Int) {
        audioPlayer.goToSong(inex: inex)
    }
}
