import SwiftUI
import SwiftUIMediaLists

/// Full-window title page. The host owns data and playback; this view only draws and reports actions.
public struct MediaDetailView: View {
    var detail: MediaDetail
    var isPlaying: Bool
    var onAction: (MediaDetailAction) -> Void

    public init(detail: MediaDetail, isPlaying: Bool = false, onAction: @escaping (MediaDetailAction) -> Void) {
        self.detail = detail
        self.isPlaying = isPlaying
        self.onAction = onAction
    }

    public var body: some View {
        GeometryReader { viewport in
            ScrollView {
                VStack(alignment: .leading, spacing: 36) {
                    DetailStage(detail: detail, isPlaying: isPlaying, height: viewport.size.height * 0.68, onAction: onAction)
                    if !detail.episodes.isEmpty {
                        MediaShelf(
                            feed: MediaFeed(id: "episodes", title: "Episodes", kind: .landscape, items: detail.episodes.map(Self.item)),
                            overlay: { _ in EmptyView() },
                            onAction: { item, action in if action == .select || action == .play { onAction(.playEpisode(item.id)) } }
                        )
                    }
                }
                .padding(.bottom, 48)
            }
        }
        .background(DetailColor.background)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private static func item(_ episode: MediaDetail.Episode) -> SwiftUIMediaLists.MediaItem {
        .init(id: episode.id, title: episode.title, subtitle: episode.subtitle, synopsis: episode.synopsis, artworkURL: episode.artworkURL, artworkAspectRatio: 16.0 / 9.0)
    }
}

private enum DetailColor {
    static let background = Color(red: 0.09, green: 0.09, blue: 0.09)
}

private struct DetailStage: View {
    var detail: MediaDetail
    var isPlaying: Bool
    var height: CGFloat
    var onAction: (MediaDetailAction) -> Void

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            DetailArtwork(url: detail.backdropURL ?? detail.artworkURL)
            LinearGradient(colors: [.clear, .clear, DetailColor.background], startPoint: .top, endPoint: .bottom)
            HStack(alignment: .bottom, spacing: 28) {
                DetailArtwork(url: detail.artworkURL)
                    .frame(width: 200, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                DetailCopy(detail: detail, isPlaying: isPlaying, onAction: onAction)
            }
            .padding(40)
        }
        .frame(maxWidth: .infinity)
        .frame(height: max(height, 420))
        .clipped()
    }
}

private struct DetailCopy: View {
    var detail: MediaDetail
    var isPlaying: Bool
    var onAction: (MediaDetailAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if let badge = detail.badge {
                Text(badge).font(.caption.weight(.semibold)).foregroundStyle(.white.opacity(0.8))
            }
            Text(detail.title)
                .font(.system(size: 52, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
            if let subtitle = detail.subtitle, !subtitle.isEmpty {
                Text(subtitle).font(.title3).foregroundStyle(.white.opacity(0.7))
            }
            if let synopsis = detail.synopsis, !synopsis.isEmpty {
                Text(synopsis)
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.88))
                    .lineLimit(4)
                    .frame(maxWidth: 720, alignment: .leading)
            }
            if let progress = detail.progress {
                ProgressView(value: progress).tint(.white).frame(maxWidth: 280)
            }
            Button { onAction(.play) } label: {
                if isPlaying {
                    ProgressView().controlSize(.regular).tint(.black)
                } else {
                    Label(detail.progress == nil ? "Play" : "Resume", systemImage: "play.fill")
                        .font(.title3.weight(.semibold))
                        .padding(.horizontal, 8)
                }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .tint(.white)
            .foregroundStyle(.black)
        }
    }
}

private struct DetailArtwork: View {
    var url: URL?
    var body: some View {
        AsyncImage(url: url) { phase in
            if let image = phase.image {
                image.resizable().scaledToFill()
            } else {
                Color.white.opacity(0.08)
            }
        }
    }
}
