import Testing
import SwiftUIMediaDetails

@Test func detailKeepsPlayAndEpisodes() {
    let detail = MediaDetail(
        id: "1",
        title: "Film",
        badge: "4K",
        episodes: [.init(id: "e1", title: "Pilot", synopsis: "Start")]
    )
    #expect(detail.badge == "4K")
    #expect(detail.episodes.count == 1)
    #expect(MediaDetailAction.playEpisode("e1") == .playEpisode("e1"))
}
