import SwiftUI
import WebKit

struct VideoPlayerView: View {
    let movieId: Int
    let movieTitle: String
    let posterURL: String
    let releaseDate : String
    let overview : String
    let voteAverage : String
    @State private var isPlaying = false
    @State private var showInfo = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Custom navigation bar
                   
                    // Video player
                    ZStack {
                        WebView(url: "\(Constants.shared.playerurl)\(movieId)")
                            .frame(height: geometry.size.height * 0.4)
                        
                        if !isPlaying {
                            ZStack {
                                AsyncImage(url: URL(string: posterURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(height: geometry.size.height * 0.4)
                                .clipped()
                                
                                Color.black.opacity(0.5)
                                
                                Button(action: {
                                    isPlaying = true
                                }) {
                                    Image(systemName: "play.circle.fill")
                                        .resizable()
                                        .frame(width: 80, height: 80)
                                        .foregroundColor(.white)
                                        .shadow(radius: 10)
                                }
                            }
                        }
                    }
                    
                    // Movie information
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Movie Information")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                           
                            InfoRow(icon: "calendar", title: "Release Date", value: releaseDate)
                          InfoRow(icon: "star.fill", title: "Rating", value: "\(voteAverage)/10")
                            
                            Text("Synopsis")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            Text(overview)
                                .foregroundColor(.gray)
                                .padding(.bottom)
                            

                        }
                        .padding()
                        .background(Color(UIColor.systemGray6).opacity(0.2))
                        .cornerRadius(20)
                        .padding()
                    }
                    .opacity(showInfo ? 1 : 0)
                    .frame(height: showInfo ? nil : 0)
                }
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text(movieTitle)
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        withAnimation {
                            showInfo.toggle()
                        }
                    }) {
                        Image(systemName: showInfo ? "info.circle.fill" : "info.circle")
                            .foregroundColor(.white)
                            .imageScale(.large)
                    }
                }

            

            }
        }
   
        .statusBar(hidden: true)
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 30)
            Text(title)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .foregroundColor(.white)
        }
    }
}

// WebView Wrapper for WKWebView
struct WebView: UIViewRepresentable {
    let url: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.configuration.allowsInlineMediaPlayback = true
        webView.configuration.mediaTypesRequiringUserActionForPlayback = []
        webView.backgroundColor = .black
        webView.isOpaque = false
        if let requestURL = URL(string: url) {
            webView.load(URLRequest(url: requestURL))
        }
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {}
}

