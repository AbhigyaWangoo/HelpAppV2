//
//  SignInPage.swift
//  HelpAppV2
//
//  Created by Abhigya Wangoo on 8/13/20.
//  Copyright © 2020 Abhigya Wangoo. All rights reserved.
//

import SwiftUI
import Firebase

struct SignInPage: View {
    @State var isActive = false
    @State var username: String = ""
    @State var password: String = ""
    var body:some View{
        NavigationView{
            ZStack{
                Image("Back.jpg").resizable().scaledToFill()
                VStack{
                    Image(systemName: "person.crop.circle.fill").resizable().frame(width: 100, height: 100).padding()
                    
                    TextField("Username", text: $username).padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.red, lineWidth: 3)
                        )
                    
                    TextField("Password", text: $password).padding()
                        .frame(width: 300, height: 50, alignment: .center)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.red, lineWidth: 3)
                        )
                // need to add password verification
                    if VerifyUser(username, password) {
                        NavigationLink(
                            destination: MsgPage(msgContent: "", user: username),
                            isActive: $isActive,
                            label: { Button(action: {
                                self.isActive = true
                            }, label: { Text("sign in") }) })
                        }
                }.navigationBarTitle("Welcome Back,")
            }
        }
    }
    
    func VerifyUser(_ userName: String,_ password: String) -> Bool{
        let db = Firestore.firestore()
        let docRef = db.collection("users").document("\(userName)")
        var dataDescription = ""
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                dataDescription = document.data().map(String.init(describing:)) ?? "nil"
            } else {
                print("Incorrect username or password")
            }
        }
        return dataDescription == password
    }

}
