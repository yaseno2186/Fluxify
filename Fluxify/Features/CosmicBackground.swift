import SwiftUI

struct CosmicBackgroundView: View {
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.02, green: 0.01, blue: 0.1),   // sehr dunkles Blau/Violett
                Color(red: 0.1, green: 0.05, blue: 0.2),    // dunkler Violettton
                Color(red: 0.3, green: 0.0, blue: 0.5),     // intensives Cosmic-Purple
                Color(red: 0.05, green: 0.0, blue: 0.15)    // sehr dunkles Blau
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )// füllt den gesamten Bildschirm
    }
}

struct CosmicBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        CosmicBackgroundView()
    }
}
