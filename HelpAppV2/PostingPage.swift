//
//  PostingPage.swift
//  firebasecrashcourse
//
//  Created by Ansh Verma on 7/26/20.
//  Copyright © 2020 Ansh Verma. All rights reserved.
//


import SwiftUI
import FirebaseFirestore


struct Message {
    var content: String
    var user: String
    var avatar: String
}

struct ButtonModify: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.red)
            .cornerRadius(9)
    }
}

extension View {
    func ButtonRender() -> some View {
        self.modifier(ButtonModify())
    }
}
struct SignUpPage: View {
    var body: some View {
        Text("hi There!")
    }
}

struct OpenningPage: View {
    var body: some View {
        Text("hi There!")
    }
}
struct PostingPage: View {
    @State var msgContent = ""
    var user = ""
    var avatar = ""
    @State private var isImportant = true
    @State private var image:Image? = nil
    var body: some View {
        NavigationView {
            VStack {
            Text("Please report your emergency here! You can write an explanation, provide pictures, and provide videos to detail the nature of your emergency. ")
                
            TextPage()
                .frame(width: 300, height: 300, alignment: .topLeading)
                
            Spacer()
            HStack(spacing: 25) {
            NavigationLink(destination: ImagePage()) {
                           Text("Upload Image")
                                .foregroundColor(.white)
                               .padding(9)
                       }
                        .ButtonRender()
                // allow option to select video/image, or record/take picture of it
        
            
                NavigationLink(destination: Text("Hey there")) {
                               Text("Upload Video")
                                    .foregroundColor(.white)
                                   .padding(9)
                           }
                            .ButtonRender()
            
            Button(action: {
                print(TextPage.msgContent)
                self.addPosting(TextPage.msgContent) // not uploading message - look into this and watch youtube video to fix
            }){
            Image(systemName: "paperplane")
                .frame(width: 32.0, height: 32.0 )
            }.background(Color.red.opacity(50))
            }
            }.padding(.bottom, 20)
            .navigationBarTitle("Help App")
            }
        
    }
        func addPosting(_ msgContent: String){
                let db = Firestore.firestore()
        let user = db.collection("Emergency Messages").document("Ansh")
                          user.setData(["Emergency message": "\(msgContent)"]) {
                              (err) in
                              
                              if err != nil {
                                  print((err?.localizedDescription)!)
                                  return
                              }
                              print("success")
                          }
                  }
        }


struct TextView: UIViewRepresentable {
    // multiline comment/posting
    typealias UIViewType = UITextView
    
    var placeholderText: String = "      Write Your Emergency Here"
    //"Please report your emergency here! You can write an explanation, provide pictures, and provide videos to detail the nature of your emergency."
    @Binding var text: String
    func makeUIView(context: UIViewRepresentableContext<TextView>) -> UITextView {
        let textView = UITextView()
        
      
        textView.textContainerInset = .zero
        textView.font = UIFont.systemFont(ofSize: 17)
        
        textView.text = placeholderText
        
        textView.textColor = .placeholderText

        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: UIViewRepresentableContext<TextView>) {
        
        
        
    
        
        uiView.delegate = context.coordinator
    }
    
    func frame(numLines: CGFloat) -> some View {
        let height = UIFont.systemFont(ofSize: 17).lineHeight * numLines
        return self.frame(height: height)
    }
    func makeCoordinator() -> TextView.Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: TextView
        
        init(_ parent: TextView) {
            self.parent = parent
        }
/*
        static func return_text() -> String {
            return self.textView.text
        }
       */
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.textColor == .placeholderText {
                textView.text = ""
                textView.textColor = .label
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == "" {
                textView.text = parent.placeholderText
                textView.textColor = .placeholderText
            }
        }
    }
}

struct ImagePage: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)
                    if image != nil {
                        // not all conditions work in swiftUI
                        image?
                            .resizable()
                            .scaledToFit()
                    } else {
                        Text("Tap to select image to upload")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }.onTapGesture {
                    self.showingImagePicker = true
                    
                }
                
                Button("Upload") {
                    //code to upload image to firebase
                }
            }
        }
        .padding([.horizontal, .bottom])
        .navigationBarTitle("Help App")
        .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
            ImagePicker(image: self.$inputImage)
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
}

struct TextPage: View {
    @State static var msgContent = ""
    static var textview: UITextView?
    var body: some View {
        NavigationView {
            ZStack {
                TextView(text: TextPage.$msgContent).frame(numLines: 6)
        /*
                if let textview != nil {
                   textview = TextView(text: TextPage.$msgContent).frame(numLines: 6)
                    }
 */
        }
    }
    }
}
