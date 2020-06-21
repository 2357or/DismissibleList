import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader{ geometry in
            DismissibleCard(CenterPos: geometry.size.width/2,
                 width: geometry.size.width,
                 height: geometry.size.height/10,
                 ltrAction: {print("left to right")},
                 rtlAction: {print("right to left")},
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
