//
//  UserFirstSelectView.swift
//  Balance-Catch-iOS
//
//  Created by 민지은 on 2023/03/23.
//

import SwiftUI
import Foundation

struct UserFirstSelectView: View {
    @Environment(\.dismiss) private var dismiss
    // MARK: - Player 데이터 가져오기
    @EnvironmentObject var playerList: PlayerList
    let selectedQuestion: Question
    @Binding var path: [Route]
    
    @State private var isActivated1: Bool = false
    @State private var isActivated2: Bool = false
    @State var showingSubview = false
    
    init(selectedQuestion: Question, path: Binding<[Route]>) {
        
        self.selectedQuestion = selectedQuestion
        questionArray = selectedQuestion.text.components(separatedBy: " vs ")
        _path = path
    }
    
    var questionArray: [String]
    
    mutating func onAppear() {
        questionArray = selectedQuestion.text.components(separatedBy: " vs ")
    }
    
    var first: String {
        questionArray.first ?? ""
    }
    var second: String {
        questionArray.last ?? ""
    }
    @State var index = 0
    var body: some View {
        VStack{
            Text("1차 선택")
                .font(.system(size:24))
                .fontWeight(.bold)
                .shadow(color:.gray,radius:2,x:3,y:3)
                .padding(.bottom, 51)
            
            // MARK: - Player 데이터 가져오기
            
            HStack{
                //Text("Player \(index + 1) \(playerList.players[index].select)") 확인용
                Text("Player \(index + 1)")
                    .font(.system(size:24))
                    .fontWeight(.bold)
                    .shadow(color:.gray,radius:2,x:3,y:3)
                
                Text(playerList.players[index].name)
                    .font(.system(size:20))
                    .fontWeight(.bold)
                    .frame(width: 150, height: 56)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color:.gray,radius:2,x:3,y:3)
                    .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color("BalanceCatchBlue").opacity(1),lineWidth: 4))
                    .padding(.leading, 24)
                
            }.padding(.bottom, 40) //HStack
            
            ZStack{
                
                VStack{
                    Button(action: {
                        if isActivated2 {
                            self.isActivated2 = false
                        }
                        self.isActivated1.toggle()
                        playerList.players[index].select = 0
                    })
                    {
                        Text("\(first)")
                            .font(.system(size: 27, weight: .bold))
                            .minimumScaleFactor(0.5)
                            .padding(.leading, 35)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                            .frame(width:250,height:150)
                    }
                    .offset(x: showingSubview ? 0 : -150, y: 0)
                    .buttonStyle(SelectButton(isActivated: $isActivated1))
                    .zIndex(0)
                    .offset(x:-90)
                    .padding(.bottom, 23)
                    
                    
                    
                    
                    Button(action: {
                        if isActivated1 {
                            self.isActivated1 = false
                        }
                        self.isActivated2.toggle()
                        playerList.players[index].select = 1
                    }) {
                        Text("\(second)")
                            .font(.system(size: 27, weight: .bold))
                            .minimumScaleFactor(0.5)
                            .padding(.trailing, 35)
                            .padding(.bottom, 10)
                            .padding(.top, 10)
                        
                            .frame(width:250,height:150)
                        
                    }
                    .buttonStyle(SelectButton(isActivated: $isActivated2))
                    .padding(.bottom, 23)
                    .zIndex(0)
                    .offset(x: 90)
                    .offset(x: showingSubview ? 0 : 150, y: 0)
                    
                    
                }
                
                StrokeText(text: "VS",width: 2, color: Color("BalanceCatchBlue"))
                    .foregroundColor(.black)
                    .font(.system(size: 64, weight: .black))
                    .shadow(color:.gray,radius:2, x: 1, y:1)
                    .padding(.bottom, 25)
                
                
            }
            .task {
                withAnimation(.easeInOut(duration: 1)) {
                    showingSubview = true
                }
            }
            
            if index < playerList.players.count - 1 {
                Button("Next") {
                    self.index += 1
                    isActivated1 = false
                    isActivated2 = false
                }
                .buttonStyle(RoundedBlueButton())
                .disabled(!isActivated1 && !isActivated2)
            } else {
                NavigationLink("Next", value: Route.timerView)
                    .buttonStyle(RoundedBlueButton())
                    .disabled(!isActivated1 && !isActivated2)
            }
            
            
        }
        
        .padding(.top,100)
        .padding(.bottom,100) //임시값
        .balanceCatchBackButton {
            dismiss()
        }
    }
}



struct UserFirstSelect_Previews: PreviewProvider {
    static var previews: some View {
        UserFirstSelectView(selectedQuestion: .init(text: "test"), path: Binding.constant([]))
    }
}
