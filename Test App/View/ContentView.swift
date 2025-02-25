import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MovieViewModel()
    @State private var searchText = ""
    @State private var isSearching = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    // Search Bar
                    SearchBar(text: $searchText, isSearching: $isSearching, onSearch: {
                        viewModel.fetchMovies(query: searchText)
                    })
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Movie List
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: VideoPlayerView(movieId: movie.id,movieTitle:movie.title,posterURL:"https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")",releaseDate: movie.releaseDate,overview :movie.overview,voteAverage : String(movie.voteAverage))) {
                                    MovieRow(movie: movie)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }.refreshable {
                        viewModel.fetchMovies(query: "Avengers")
                    }
                    
                }}
            .navigationTitle("Movie Search")
            .background(Color(.systemBackground))
        }.accentColor(.white)
        .onAppear {
            viewModel.fetchMovies(query: "Avengers") // Default query on launch
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    var onSearch: () -> Void

    var body: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)

                TextField("Search movies...", text: $text, onCommit: {
                    onSearch()
                })
                .foregroundColor(.primary)

                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            if isSearching {
                Button("Cancel") {
                    isSearching = false
                    text = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
                .foregroundColor(.blue)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

struct MovieRow: View {
    let movie: Movie

    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 100, height: 150)
            .cornerRadius(8)
            .shadow(radius: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(movie.voteAverage, specifier: "%.1f")")
                        .fontWeight(.semibold)
                    Text("(\(movie.voteCount) votes)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(movie.overview)
                    .font(.footnote)
                    .lineLimit(3)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(.linearGradient(.init(colors: [Color.red.opacity(0.6), Color.gray.opacity(0.1)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    ContentView()
}
