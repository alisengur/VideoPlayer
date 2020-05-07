//
//  Video.swift
//  customVideoPlayer
//
//  Created by Ali Şengür on 7.05.2020.
//  Copyright © 2020 Ali Şengür. All rights reserved.
//

import Foundation

struct Video {
    
    var videos: [String]
    var videosDesc: [String]
    var imageURLS: [String]
    
    init() {
        self.videos = ["mask", "stayathome", "hand-washing"]
        self.videosDesc = ["How to use mask?", "Stay at home!", "How to wash hands?"]
        self.imageURLS = ["https://cdn.pixabay.com/photo/2020/03/03/12/15/virus-4898571_960_720.jpg",
        "https://cdn.pixabay.com/photo/2020/04/22/10/29/call-5077271_960_720.jpg",
        "https://cdn.pixabay.com/photo/2020/04/22/10/29/call-5077271_960_720.jpg"]
    }
    
}
