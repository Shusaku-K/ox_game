//
//  ContentView.swift
//  marubatu_game
//
//  Created by 金城秀作 on 2021/02/23.
//
//  まるばつゲーム
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        NavigationView {
        Home()
            .navigationTitle("まるばつゲーム")
            .preferredColorScheme(.dark)
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    // Moves...
    @State var moves : [String] = Array(repeating: "", count: 9)
    //現在のプレイヤーを識別する
    @State var isPlaying = true
    @State var gameOver = false
    @State var msg = ""
    
    var body: some View {
        
        VStack {
            
            // グリッドビュー（枠）
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3),spacing: 15) {
                
                ForEach(0..<9, id: \.self){index in
                    
                    ZStack{
                        
                        //アニメーション
                        
                        Color.blue
                        Color.white
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .opacity(moves[index] != "" ? 1 : 0)

                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                        
                        )
                    
                    // タップしたときの動きを追加
                    .onTapGesture(perform: {
                        withAnimation(Animation.easeIn(duration: 0.5)){
                            
                            if moves[index] == ""{
                                moves[index] = isPlaying ? "x" : "0"
                                
                                isPlaying.toggle()
                            }
                        }
                    })

                }
                
            }
            .padding(15)
        }
        // 手が更新されるたびに、勝者をチェックする
        .onChange(of: moves, perform: { value in
            
            checkWinner()
        })
        
        .alert(isPresented: $gameOver, content: {
            
            Alert(title: Text("結果"), message: Text(msg), dismissButton: .destructive(Text("もう一度あそぶ"), action: {
                
                //結果をリセットする
                withAnimation(Animation.easeIn(duration: 0.5)){
                    
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        })
    }
    
    // 横幅計算
    
    func getWidth()->CGFloat{
        
        
        // 水平方向のpadding = 30
        // 間隔 = 30
        let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }
    
    // 勝者のチェック
    
    func checkWinner(){
        
        if checkMoves(player: "x"){
            
            // アラートの表示（文字の変更はこちら）
            
            msg = "Xの勝ち !!!!"
            gameOver.toggle()
        }
        
        else if checkMoves(player: "0"){
            
            msg = "○の勝ち !!!!"
            gameOver.toggle()
            
        }
        else {
           
            
            let status = moves.contains { (value) -> Bool in
                
                return value == ""
            }
            
            if !status{
                
                msg = "引き分け !!!"
                gameOver.toggle()
            }
            
        }
        
    }
    
    func checkMoves(player: String)->Bool{
        
        // 水平方向の動き
        
        for i in stride(from: 0, to: 9, by: 3){
            
            if moves[i] == player && moves[i + 1] == player && moves[i + 2] == player{
                
                return true
            }
        }
        
        // 縦方向の動き
        
        for i in 0...2 {
            
            if moves[i] == player && moves[i + 3] == player && moves[i + 6] == player{
                
                return true
            }
        }
        
        
        if moves[0] == player && moves[4] == player && moves[8] == player{
            
            return true
        }
        
        if moves[2] == player && moves[4] == player && moves[6] == player{
            
            return true
        }

        
        return false
    }
    
}
