import SwiftUI

struct ContentView: View {
    var body: some View {
        ScrollView{
            ForEach(0..<10){ num in
                DismissibleCard(
                    height: 80,
                    ltrAction: {print("left to right")},
                    rtlAction: {print("right to left")},
                    onTap: {print("tapped")},
                    ltrMode: .none,
                    rtlMode: .delete,
                    text: "Test Data \(num)"
                ).padding(-5)
            }
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
