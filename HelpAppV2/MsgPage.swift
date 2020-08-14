//
//  MsgPage.swift
//  ChatBox
//
//  Created by Abhigya Wangoo on 6/19/20.
//  Copyright © 2020 Abhigya Wangoo. All rights reserved.
//
import SwiftUI
import Firebase
import FirebaseFirestore



struct MsgPage: View{
    @State var msgContent = ""
    var user = ""
    var avatar = ""
    @State private var isImportant = true;
    @State private var data = ""
    var body: some View {
        VStack{
            //insert the list of messages here
            
            
            
            
            
            HStack{
                TextField("CREATE A MESSAGE", text: $msgContent).cornerRadius(20)
                Button(action: {
                    self.data = self.getDocument(self.addMessage(Message(content: self.msgContent, user: self.user, avatar: self.avatar), self.isImportant)) //adding the message on the buttonclick, as well as assigning the returnvalue to var data
                }){
                    Image(systemName: "paperplane")
                }.background(Color.red.opacity(50))
            }
        }
    }
    
    
    
    func addMessage(_ message: Message,_ isUrgent: Bool) -> String{
        let db = Firestore.firestore()
        var ref: DocumentReference? = nil
        ref = db.collection("Messages").addDocument(data: [
            "isUrgent": true,
            "Content": "\(message.content)",
            "User": "\(message.avatar)"
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        
        return ref?.documentID ?? "Couldn't find the document"
    }
    
    private func getDocument(_ docID:String) -> String{ //function gets the document's data as a string according to the docid argument
        // [START get_document]
        let db = Firestore.firestore()
        var documentData = ""
        let docRef = db.collection("Messages").document("\(docID)")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                documentData = document.data().map(String.init(describing:)) ?? "nil"
            } else {
                print("Document does not exist")
            }
        }
        return documentData
    }

}



/*struct MsgPage_Previews: PreviewProvider {
    static var previews: some View {
        MsgPage(contentMessage: "This is just the sample view ")
    }
}
*/

struct MsgPage_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
