//
//  SDWebImageDEMO.swift
//  SPMAndSDK
//
//  Created by Rahul Rai on 10/10/24.
//

import SwiftUI
import SDWebImageSwiftUI


struct ImageLoader: View {
    let url: String
    var contentMode: ContentMode = .fill
    var body: some View {
        Rectangle()
            .opacity(0)
            .overlay(
            SDWebImageLoader(url: url, contentMode: contentMode)
                .allowsHitTesting(false)    // By this if we have an on tap gesture, then the user is clicking on the Rectangle not the image
        )
        .clipped()
    }
}

fileprivate struct SDWebImageLoader: View {
    let url: String
    var contentMode: ContentMode = .fill
    
    var body: some View {
        WebImage(url: URL(string: url)) { image in
            image.resizable()
        } placeholder: {
                Rectangle().foregroundColor(.gray)
        }
        
        .onSuccess { image, data, cacheType in

        }
        .indicator(.activity)
        .transition(.fade(duration: 0.5)) // Fade Transition with duration
        .aspectRatio(contentMode: contentMode)
        
    }
}


final class ImagePrefetcher {
    static let instance = ImagePrefetcher()
    private let prefetcher = SDWebImagePrefetcher()
    
    
    private init(){}
    
    func startPrefetching(urls: [URL]){
        prefetcher.prefetchURLs(urls)
    }
    
    func stopPrefetching(){
        prefetcher.cancelPrefetching()
    }
}


// 1. Image catching is there
struct SDWebImageDemo: View {
    var body: some View {
        // Use like this....
        ImageLoader(url: "https://picsum.photos/id/237/200/300", contentMode: .fit)
            .frame(width: 200, height: 200, alignment: .center)
            .onAppear{
                ImagePrefetcher.instance.startPrefetching(urls: [])
            }
    }
}

#Preview {
    SDWebImageDemo()
}
