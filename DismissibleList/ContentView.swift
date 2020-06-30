import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ geometry in
            DismissibleCard(
                 height: geometry.size.height/10,
                 ltrAction: {print("left to right")},
                 rtlAction: {print("right to left")},
                 onTap: {print("tapped")},
                 ltrMode: .none,
                 rtlMode: .delete
            ).padding(.top)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
