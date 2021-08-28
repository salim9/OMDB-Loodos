
import Foundation
import FirebaseAnalytics

extension DetailVC {
    func postAnalyticsLogs(detailOfMovie: MovieDetail) {
        Analytics.logEvent("MovieDetail", parameters: [
            "title" : detailOfMovie.title ?? "nil",
            "year" : detailOfMovie.year ?? "nil",
            "director" : detailOfMovie.director ?? "nil",
            "writer" : detailOfMovie.writer ?? "nil",
            "actors" : detailOfMovie.actors ?? "nil",
            "imdbId" : detailOfMovie.imdbId ?? "nil",
            "type" : detailOfMovie.type ?? "nil",
            "response" : detailOfMovie.response ?? "nil",
            "genre" : detailOfMovie.genre ?? "nil",
            "language" : detailOfMovie.language ?? "nil",
            ])
    }
}
