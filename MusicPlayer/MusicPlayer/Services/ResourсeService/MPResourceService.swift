//
//  MPResourсeService.swift
//  MusicPlayer
//
//  Created by Kirill on 6.09.22.
//

import Foundation

protocol MPResourсeServiceProtocol {
    func fetchTracksURL() -> [URL]?
}

class MPResourсeService: MPResourсeServiceProtocol {
    
    func fetchTracksURL() -> [URL]? {
        // stubbed tracks
        let tracksURLs: [URL] = [
            Bundle.main.url(forResource: "song1", withExtension: "mp3")!,
            Bundle.main.url(forResource: "song2", withExtension: "mp3")!,
            Bundle.main.url(forResource: "song3", withExtension: "mp3")!
        ]
        return tracksURLs
    }
}
