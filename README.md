# SwiftUIMediaDetails

Reusable SwiftUI title page for iOS, tvOS, and macOS 26+. Swift tools 6.4, language mode Swift 6.

The view is a full-window detail page in the shape of Apple TV and Apple Music: backdrop, poster, title, synopsis, play, then an episode list. The host owns the data and playback.

```swift
MediaDetailView(detail: detail) { action in
    switch action {
    case .play: play(detail.id)
    case .playEpisode(let id): play(id)
    }
}
```
