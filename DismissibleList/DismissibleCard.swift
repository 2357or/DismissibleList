import SwiftUI

enum DismissibleMode {
    case delete
    case none
    case keep
}

struct DismissibleCard: View {
    let width: CGFloat = UIScreen.main.bounds.size.width
    let sensitivity: CGFloat = 80
  
    @State var height: CGFloat
    
    var ltrAction, rtlAction, onTap: ()->Void
    
    let ltrMode: DismissibleMode
    let rtlMode: DismissibleMode
    
    let text: String
    
    @State var CenterPos: CGFloat = UIScreen.main.bounds.size.width/2
    @State var offset: CGFloat = 0
    @State var backColor: Color = Color(red: 1, green: 1, blue: 1, opacity: 0)

    var body: some View {
        ZStack {
            // 背景
            Group {
                // 背景色
                Rectangle()
                    .fill(backColor)
                    .animation(.easeOut)
                    
                // 左右のアイテムイメージ
                HStack {
                    Image(systemName: (CenterPos > width/2 + height/2) ? "paperplane" : "")
                        .resizable()
                        .scaledToFit()
                        .frame(height: height/2)
                        .scaleEffect(offset > sensitivity ? 1 : 0.6)
                        .padding(.leading, 20)
                    Spacer()
                    Image(systemName:(CenterPos < width/2 - height/2) ? "trash" : "")
                        .resizable()
                        .scaledToFit()
                        .frame(height: height/2)
                        .scaleEffect(offset < -1*sensitivity ? 1 : 0.6)
                        .padding(.trailing, 20)
                }
            }.position(x: width/2, y: height)
            
            // カード
            ZStack {
                // カードの影
                Rectangle()
                    .fill(Color(red: 1, green: 1, blue: 1, opacity: 1))
                    .cornerRadius(offset==0 ? 0 : 15)
                    .shadow(color: .gray, radius: 0, x: 0, y: offset==0 ? 2 : 5)
                
                // カードフィールド
                Rectangle()
                    .fill(Color.blue)
                    .cornerRadius(offset==0 ? 0 : 15)
                    .frame(width: width)
                    .border(Color.black, width: offset==0 ? 2 : 0)
                    .onTapGesture {self.onTap()}
                
                // テキスト
                Text(text).font(.system(size: height/3))
            }
            .position(x: CenterPos, y: height)
            .gesture(self.drag)
            .animation(.easeOut)
        }
        .position(x: width/2, y: 0)
        .frame(width: width, height: height)
    }
    
    // 背景色の変更
    func changeColor() {
        if self.offset < 0 {
            backColor = .red
        }else {
            backColor = .green
        }
    }
    // 背景色のリセット(透明化)
    func resetColor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.backColor = Color(red: 1, green: 1, blue: 1, opacity: 0)
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
            self.judge()
        }
    }
    
    // 左右への移動具合から、Cardの最終位置を決定して返す
    func judge(){
        if offset < -1*sensitivity {
            LazyAction(mode: rtlMode) { rtlAction() }
            CenterPos = width/2 * -1
        }
        else if offset > sensitivity {
            LazyAction(mode: ltrMode) { ltrAction() }
            CenterPos = 3 * width/2
        }
        else {
            offset = 0
            CenterPos = width/2
        }
    }
    
    // 遅延処理
    func LazyAction(mode: DismissibleMode, action: ()-> Void) {
        action()
        
        switch mode {
        case .delete:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.resetColor()
                self.offset = 0
                self.onDelete()
            }
        case .none:
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.resetColor()
                self.offset = 0
                self.CenterPos = self.width/2
            }
        case .keep:
            return
        }
    }
    
    // 削除処理
    func onDelete() {
        height = 0
    }
}


struct DismissibleCard_Previews: PreviewProvider {
    static var previews: some View {
        DismissibleCard(
            height: 80,
            ltrAction: {print("ltr")},
            rtlAction: {print("rtl")},
            onTap: {print("taped")},
            ltrMode: .none,
            rtlMode: .keep,
            text: "Test Data"
        )
    }
}
