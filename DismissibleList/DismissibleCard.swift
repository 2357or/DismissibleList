import SwiftUI

enum DismissibleMode {
    case delete
    case none
    case keep
}

struct DismissibleCard: View {
    let width: CGFloat = UIScreen.main.bounds.size.width
    let height: CGFloat
    let ltrAction: ()->Void
    let rtlAction: ()->Void
    
    let ltrMode: DismissibleMode
    let rtlMode: DismissibleMode
    
    @State var CenterPos: CGFloat = UIScreen.main.bounds.size.width/2
    @State var offset: CGFloat = 0
    
    @State var delete: Bool = false

    @State var color: Color = Color(red: 1, green: 1, blue: 1, opacity: 0)
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(color)
                .frame(width: width, height: height)
                .position(x: width/2, y: height/2)
                .animation(.easeOut)

            HStack {
                Image(systemName: CenterPos > width/2 + height/2 && !delete ? "paperplane" : "")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(offset > 100 ? 1 : 0.8)
                    .padding(.leading, offset > 100 ? height/3 : 1)
                Spacer()
                Image(systemName: CenterPos < width/2 - height/2 && !delete ? "trash" : "")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(offset < -100 ? 1 : 0.8)
                    .padding(.trailing, offset < -100 ? height/3 : 1)
            }
            .frame(width: width, height: height/2)
            .position(x: width/2, y: height/2)
            
            Rectangle()
                .fill(Color.blue)
                .shadow(color: .gray, radius: 0, x: 0, y: offset==0 ? 5 : 3)
                .frame(width: width-10, height: delete ? 0 : height )
                .position(x: CenterPos, y: height/2)
                .gesture(self.drag)
                .animation(.default)
        }
    }
    
    func changeColor() {
        if self.offset < 0 {
            self.color = .red
        }else {
            self.color = .green
        }
    }
    func resetColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.color = Color(red: 1, green: 1, blue: 1, opacity: 0)
        }
    }
    
    // Cardの移動処理
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.changeColor()
                self.offset = value.translation.width
                self.CenterPos = self.width/2 + value.translation.width
        }
        .onEnded { value in
            self.resetColor()
            self.CenterPos = self.judge()
        }
    }
    
    // 左右への移動具合から、Cardの最終位置を決定して返す
    func judge() -> CGFloat {
        if offset < -100 {
            Action(mode: rtlMode) { rtlAction() }
            return width/2 * -1
        }
        if offset > 100 {
            Action(mode: ltrMode) { ltrAction() }
            return 3 * width/2
        }
        return width/2
    }
    
    // 遅延処理
    func Action(mode: DismissibleMode, action: ()-> Void) {
        action()
        if mode == DismissibleMode.delete{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.delete = true
            }
        }
        if mode == DismissibleMode.none{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.CenterPos = self.width/2
            }
        }
        
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            DismissibleCard(
                height: 60,
                ltrAction: {print("ltr")},
                rtlAction: {print("rtl")},
                ltrMode: .none,
                rtlMode: .none
            ).padding(.top)
        }
    }
}
