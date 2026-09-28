import SwiftUI
import SwiftUIMediaLists

/// Title page shaped like the Apple TV app: full-bleed backdrop, bottom-leading copy, shelves underneath.
/// The host owns data and playback. This view draws and reports actions.
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
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                DetailStage(detail: detail, isPlaying: isPlaying, onAction: onAction)
                    .containerRelativeFrame(.horizontal) { length, _ in length * 9 / 16 }
                if !detail.episodes.isEmpty {
                    MediaShelf(
                        feed: MediaFeed(id: "episodes", title: "Episodes", kind: .landscape, items: detail.episodes.map(Self.item)),
                        overlay: { _ in EmptyView() },
                        onAction: { item, action in if action == .select || action == .play { onAction(.playEpisode(item.id)) } }
                    )
                }
            }
            .padding(.bottom)
        }
        .contentMargins(.top, 0, for: .scrollContent)
        .ignoresSafeArea(edges: .top)
        .background(Color(red: 0.10, green: 0.10, blue: 0.10))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private static func item(_ episode: MediaDetail.Episode) -> SwiftUIMediaLists.MediaItem {
        .init(id: episode.id, title: episode.title, subtitle: episode.subtitle, synopsis: episode.synopsis, artworkURL: episode.artworkURL, artworkAspectRatio: 16.0 / 9.0)
    }
}

private struct DetailStage: View {
    var detail: MediaDetail
    var isPlaying: Bool
    var onAction: (MediaDetailAction) -> Void
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            DetailArtwork(url: detail.backdropURL ?? detail.artworkURL)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .allowsHitTesting(false)
            LinearGradient(
                colors: [.clear, .clear, Color(red: 0.10, green: 0.10, blue: 0.10)],
                startPoint: .top,
                endPoint: .bottom
            )
            DetailCopy(detail: detail, isPlaying: isPlaying, compact: horizontalSizeClass == .compact, onAction: onAction)
                .padding(.leading, horizontalSizeClass == .compact ? 24 : 52)
                .padding(.trailing, 52)
                .padding(.bottom, horizontalSizeClass == .compact ? 48 : 64)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .clipped()
    }
}

private struct DetailCopy: View {
    var detail: MediaDetail
    var isPlaying: Bool
    var compact: Bool
    var onAction: (MediaDetailAction) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let badge = detail.badge {
                Text(badge)
                    .font(.caption.bold())
                    .padding(7)
                    .background(.white.opacity(0.2), in: Capsule())
            }
            Text(detail.title)
                .font((compact ? Font.title : .largeTitle).bold())
                .foregroundStyle(.white)
                .lineLimit(2)
            if let subtitle = detail.subtitle, !subtitle.isEmpty {
                Text(subtitle)
                    .font(compact ? .subheadline : .body)
                    .foregroundStyle(.white.opacity(0.75))
            }
            if let synopsis = detail.synopsis, !synopsis.isEmpty {
                Text(synopsis)
                    .font(compact ? .subheadline : .body)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(3)
                    .frame(maxWidth: 640, alignment: .leading)
            }
            if let progress = detail.progress {
                ProgressView(value: progress).tint(.white).frame(maxWidth: 240)
            }
            Button { onAction(.play) } label: {
                if isPlaying {
                    ProgressView().controlSize(.regular).tint(.black)
                } else {
                    Label(detail.progress == nil ? "Play" : "Resume", systemImage: "play.fill")
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
