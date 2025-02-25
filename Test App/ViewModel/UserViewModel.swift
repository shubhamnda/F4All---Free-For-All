import SwiftUI

class MovieViewModel: ObservableObject {
    @Published var movies: [Movie] = []
    
    private let apiKey = Constants.shared.apiKey
    
    func fetchMovies(query: String) {
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(query)"
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                
                await MainActor.run {
                    self.movies = decodedResponse.results
                }
            } catch {
                print("Error fetching movies: \(error)")
            }
        }
    }
}
