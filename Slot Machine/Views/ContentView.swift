//
//  ContentView.swift
//  Slot Machine
//
//  Created by Abduqodir's MacPro on 2022/07/19.
//

import SwiftUI

struct ContentView: View {
  //MARK: - Properties
  
  let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
  let haptics = UINotificationFeedbackGenerator()
  
  @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
  @State private var coins: Int = 100
  @State private var betAmount: Int = 10
  @State private var showingInfoView: Bool = false
  @State private var reels: Array = [0, 1, 2]
  @State private var isActiveBet10: Bool = true
  @State private var isActiveBet20: Bool = false
  @State private var showingModal: Bool = false
  @State private var animatingSymbol: Bool = false
  @State private var animatingModal: Bool = false
  
  //MARK: - Functions
  
  // Spin the reels
  func spinReels() {
//    reels[0] = Int.random(in: 0...symbols.count - 1)
//    reels[1] = Int.random(in: 0...symbols.count - 1)
//    reels[2] = Int.random(in: 0...symbols.count - 1)
    reels = reels.map({_ in
      Int.random(in: 0...symbols.count - 1)
    })
    playSound(sound: "spin", type: "mp3")
    haptics.notificationOccurred(.success)
  }

  // Check the winning
  func checkWinning() {
    if reels[0] == reels[1] && reels[1] == reels[2] {
      // Player Wins
      playerWins()
      // New Highscore
      if coins > highScore {
        newHighScore()
      } else {
        playSound(sound: "win", type: "mp3")
      }
    } else {
      // Player loses
      playerLoses()
    }
  }
  
  func playerWins() {
    coins += betAmount * 10
  }
  
  func newHighScore() {
    highScore = coins
    UserDefaults.standard.set(highScore, forKey: "HighScore")
    playSound(sound: "high-score", type: "mp3")
  }
  
  func playerLoses() {
    coins -= betAmount
  }
  
  func activateBet20() {
    betAmount = 20
    isActiveBet20 = true
    isActiveBet10 = false
    playSound(sound: "casino-chips", type: "mp3")
    haptics.notificationOccurred(.success)
  }
  
  func activateBet10() {
    betAmount = 10
    isActiveBet10 = true
    isActiveBet20 = false
    playSound(sound: "casino-chips", type: "mp3")
    haptics.notificationOccurred(.success)
  }
  
  // Game is over
  func isGameOver() {
    if coins <= 0 {
      showingModal = true
      playSound(sound: "game-over", type: "mp3")
    }
  }
  
  func resetGame() {
    UserDefaults.standard.set(0, forKey: "HighScore")
    highScore = 0
    coins = 100
    activateBet10()
    playSound(sound: "chimeup", type: "mp3")
  }
  
  //MARK: - Body
  var body: some View {
    ZStack {
      // Background
      LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom)
        .edgesIgnoringSafeArea(.all)
      
      //MARK: - Interface
      VStack(alignment: .center, spacing: 5) {
        //MARK: - Header
        LogoView()
        
        Spacer()
        
        //MARK: - Score
        HStack {
          HStack {
            Text("Your\nCoins".uppercased())
              .scoreLabelStyle()
              .multilineTextAlignment(.trailing)
            
            Text("\(coins)")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
          } //: HStack
          .modifier(ScoreContainerModifier())
          
          Spacer()
          
          HStack {
            Text("\(highScore)")
              .scoreNumberStyle()
              .modifier(ScoreNumberModifier())
            
            Text("High\nScore".uppercased())
              .scoreLabelStyle()
              .multilineTextAlignment(.leading)
            
          } //: HStack
          .modifier(ScoreContainerModifier())
        } //: HStack
        .padding(.horizontal, 5)
        
        //MARK: - Slot Machine
        VStack(alignment: .center, spacing: 0) {
          // Reel #1
          ZStack {
            ReelView()
            Image(symbols[reels[0]])
              .resizable()
              .modifier(ImageModifier())
              .opacity(animatingSymbol ? 1 : 0)
              .offset(y: animatingSymbol ? 0 : -50)
              .animation(.easeOut(duration: Double.random(in: 0.5...0.7)), value: animatingSymbol)
              .onAppear {
                animatingSymbol.toggle()
                playSound(sound: "riseup", type: "mp3")
              }
          }
          
          HStack(alignment: .center, spacing: 0) {
            // Reel #2
            ZStack {
              ReelView()
              Image(symbols[reels[1]])
                .resizable()
                .modifier(ImageModifier())
                .opacity(animatingSymbol ? 1 : 0)
                .offset(y: animatingSymbol ? 0 : -50)
                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)), value: animatingSymbol)
                .onAppear {
                  animatingSymbol.toggle()
                }
            }
            
            Spacer()
            
            // Reel #3
            ZStack {
              ReelView()
              Image(symbols[reels[2]])
                .resizable()
                .modifier(ImageModifier())
                .opacity(animatingSymbol ? 1 : 0)
                .offset(y: animatingSymbol ? 0 : -50)
                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)), value: animatingSymbol)
                .onAppear {
                  animatingSymbol.toggle()
                }
            }
            
          } //: HStack
          .frame(maxWidth: 500)
          
          //MARK: - Spin Button
          Button {
            // 1. Set the default state: no animation
            withAnimation {
              animatingSymbol = false
            }
            
            // 2. Spin the reels with changing the symbols
            spinReels()
            
            // 3. Trigger the animation after changing the symbols
            withAnimation {
              animatingSymbol = true
            }
            
            // 4. Check winning
            checkWinning()
            
            // 5. Game is over
            isGameOver()
          } label: {
            Image("gfx-spin")
              .renderingMode(.original)
              .resizable()
              .modifier(ImageModifier())
          }

          
        } //: Slot Machine
        .layoutPriority(2)
        
        //MARK: - Footer
        Spacer()
        
        HStack {
          // Bet 20
          HStack(alignment: .center, spacing: 10) {
            Button {
              activateBet20()
            } label: {
              Text("20")
                .fontWeight(.heavy)
                .foregroundColor(isActiveBet20 ? Color("ColorYellow") : .white)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
            
            Image("gfx-casino-chips")
              .resizable()
              .offset(x: isActiveBet20 ? 0 : 20)
              .opacity(isActiveBet20 ? 1 : 0)
              .modifier(CasinoChipsModifier())
          } //: HStack
          .padding(.horizontal, 5)
          
          Spacer()
          
          // Bet 10
          HStack(alignment: .center, spacing: 10) {
            Image("gfx-casino-chips")
              .resizable()
              .offset(x: isActiveBet10 ? 0 : -20)
              .opacity(isActiveBet10 ? 1 : 0)
              .modifier(CasinoChipsModifier())
            
            Button {
              activateBet10()
            } label: {
              Text("10")
                .fontWeight(.heavy)
                .foregroundColor(isActiveBet10 ? Color("ColorYellow") : .white)
                .modifier(BetNumberModifier())
            }
            .modifier(BetCapsuleModifier())
          } //: HStack
          .padding(.horizontal, 5)

        } //: HStack
      } //: VStack
      
      //MARK: - Buttons
      
      .overlay(alignment: .topLeading, content: {
        // Reset
        Button(action: {
          resetGame()
        }, label: {
          Image(systemName: "arrow.2.circlepath.circle")
            .shadow(radius: 10)
        })
        .modifier(ButtonModifier())
        .padding(.vertical, -10)
        .padding(.horizontal, 5)
      })
      
      .overlay(alignment: .topTrailing, content: {
        // Info
        Button(action: {
          showingInfoView = true
        }, label: {
          Image(systemName: "info.circle")
            .shadow(radius: 10)
        })
        .modifier(ButtonModifier())
        .padding(.vertical, -10)
        .padding(.horizontal, 5)
      })
      
      .padding()
      .frame(maxWidth: 720)
      .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
      
      //MARK: - Pop-up
      if $showingModal.wrappedValue {
        ZStack {
          Color("ColorTransparentBlack")
            .edgesIgnoringSafeArea(.all)
          
          // Modal
          VStack(spacing: 0) {
            Text("GAME OVER")
              .font(.system(.title, design: .rounded))
              .fontWeight(.heavy)
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity)
              .background(Color("ColorPink"))
              .foregroundColor(.white)
            
            Spacer()
            
            //Message
            VStack(alignment: .center, spacing: 16) {
              Image("gfx-seven-reel")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 72)
              
              Text("Oops! You lost all the coins. \nLet's play again!")
                .font(.system(.body, design: .rounded))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .layoutPriority(1)
              
              Button {
                showingModal = false
                animatingModal = false
                activateBet10()
                coins = 100
              } label: {
                Text("New Game".uppercased())
                  .font(.system(.body, design: .rounded))
                  .fontWeight(.semibold)
                  .tint(Color("ColorPink"))
                  .padding(.horizontal, 12)
                  .padding(.vertical, 8)
                  .frame(minWidth: 128)
                  .background(
                    Capsule()
                      .strokeBorder(lineWidth: 2)
                      .foregroundColor(Color("ColorPink"))
                  )
              }

            } //: VStack
            
            Spacer()
            
          } //: VStack
          .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
          .background(.white)
          .cornerRadius(20)
          .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
          .opacity($animatingModal.wrappedValue ? 1 : 0)
          .offset(y: $animatingModal.wrappedValue ? 0 : -100)
          .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0), value: animatingModal)
          .onAppear {
            animatingModal = true
          }
        } //: ZStack
      }
      
      
    } //: ZStack
    .sheet(isPresented: $showingInfoView) {
      InfoView()
    }
  }
}

//MARK: - Preview
struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
