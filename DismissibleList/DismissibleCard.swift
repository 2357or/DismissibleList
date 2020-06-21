import SwiftUI

enum DismissibleMode {
    case delete
    case none
    case keep
}

struct DismissibleCard: View {
    @State var CenterPos: CGFloat
    
    var width: CGFloat
    var height: CGFloat
    
    var ltrAction: ()->Void
    var rtlAction: ()->Void
    
    var ltrMode: DismissibleMode
    var rtlMode: DismissibleMode
    
    @State var rtl: Bool = false
    @State var ltr: Bool = false
    
    @State var delete: Bool = false
    
    var body: some View {
        ZStack {
            // 色の部分
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.green)
                Rectangle()
                    .fill(Color.blue)
                Rectangle()
                    .fill(Color.red)
            }
            .frame(width: width*3, height: delete ? 0 : height )
            .position(x: CenterPos, y: height/2)
            .gesture(self.drag)
            .animation(.default)

            
            // アイコン
            HStack {
                Image(systemName: CenterPos > width/2 + height/2 && !delete ? "paperplane" : "")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(ltr ? 1 : 0.5)
                    .padding(.leading, ltr ? height/3 : 1)
                Spacer()
                Image(systemName: CenterPos < width/2 - height/2 && !delete ? "trash" : "")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(rtl ? 1 : 0.5)
                    .padding(.trailing, rtl ? height/3 : 1)
            }
            .frame(width: width, height: height/1.8)
            .position(x: width/2, y: height/2)
        }
    }
    
    // Cardの移動処理
    var drag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.CenterPos = self.width/2 + value.translation.width
                self.ltr = self.CenterPos > self.width/2 + self.height
                self.rtl = self.CenterPos < self.width/2 - self.height
        }
        .onEnded { value in
            self.CenterPos = self.judge()
        }
    }
    
    // 左右への移動具合から、Cardの最終位置を決定して返す
    func judge() -> CGFloat {
        if !(ltr || rtl){
            return width/2
        }else if ltr{
            Action(mode: ltrMode) { ltrAction() }
            return ltrMode == DismissibleMode.none ? width/2 : 3 * width/2
        }
        Action(mode: rtlMode) { rtlAction() }
        return rtlMode == DismissibleMode.none ? width/2 : width/2 * -1
    }
   
    // 遅延処理
    func Action(mode: DismissibleMode, action: ()-> Void) {
        action()
        if mode == DismissibleMode.delete{
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.delete = true
            }
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ geometry in
            DismissibleCard(CenterPos: geometry.size.width/2,
                 width: geometry.size.width,
                 height: geometry.size.height/10,
                 ltrAction: {print("ltr")},
                 rtlAction: {print("rtl")},
                 ltrMode: .none,
                 rtlMode: .delete
            ).padding(.top)
        }
    }
}
