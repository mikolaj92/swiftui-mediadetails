import Foundation

/// Title metadata supplied by the host. The library does not load or play media.
public struct MediaDetail: Identifiable, Sendable, Hashable {
    public let id: String
    public var title: String
    public var subtitle: String?
    public var synopsis: String?
    public var badge: String?
    public var artworkURL: URL?
    public var backdropURL: URL?
    public var progress: Double?
    public var episodes: [Episode]

    public struct Episode: Identifiable, Sendable, Hashable {
        public let id: String
        public var title: String
        public var subtitle: String?
        public var synopsis: String?
        public var artworkURL: URL?
        public init(id: String, title: String, subtitle: String? = nil, synopsis: String? = nil, artworkURL: URL? = nil) {
            self.id = id
            self.title = title
            self.subtitle = subtitle
            self.synopsis = synopsis
            self.artworkURL = artworkURL
        }
    }

    public init(
        id: String,
        title: String,
        subtitle: String? = nil,
        synopsis: String? = nil,
        badge: String? = nil,
        artworkURL: URL? = nil,
        backdropURL: URL? = nil,
        progress: Double? = nil,
        episodes: [Episode] = []
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.synopsis = synopsis
        self.badge = badge
        self.artworkURL = artworkURL
        self.backdropURL = backdropURL
        self.progress = progress
        self.episodes = episodes
    }
}

public enum MediaDetailAction: Sendable, Hashable {
    case play
    case playEpisode(String)
}
