//
//  PostingPage.swift
//  TemporaryHelpApp
//
//  Created by Ansh Verma on 7/28/20.
//  Copyright © 2020 Ansh Verma. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
        .padding()
        .frame(width: 300, height: 45, alignment: .center)
        .overlay(
            RoundedRectangle(cornerRadius: 100)
                .stroke(Color.red, lineWidth: 3)
        )
    }
}

extension View {
    func TextFieldRender() -> some View {
        self.modifier(TextFieldModifier())
    }
}


struct PageWithPosts: View {
    var body: some View {
        Text("hi!")
    }
}

// best way to completely change screens
class ScreenSwitchBools: ObservableObject {
    @Published var switchViews: Bool = true
}
struct Main: View {
    @EnvironmentObject var switchBool: ScreenSwitchBools
    var body: some View {
        print("yo")
        return Group { // figure out what this is
            if(switchBool.switchViews){
               // RealContentView()
               SignUpPage()

            }
            else{
                PageWithPosts()// need to do that environmental variable so all structs can use
        }
        
    }
}
struct SignUpPage: View {
  
    @State var isActive = false
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmpassword: String = ""
    @State var firstname: String = ""
    @State var lastname: String = ""
    @State var email: String = ""
    @State var saveBool: Bool = false
    @State private var Verification: Bool = false
    @State private var ToggleVar: String = ""
    var body: some View {
        NavigationView{
                VStack{
                    //print("yo")
                    Group {
                    Text("Page One")
                        .font(.system(size: 28.0))
                        .padding(.bottom)
                    Text("Enter your primary information. Remember that the purpose of this app is for other users to recognize you during an emergency. For this reason, you must upload an accurate profile picture. Additionally, you will be required to input your real name, a username that accurately reflects your name, and the email you use most often. Once you are done, press 'Save Information' to save your account information. Then press 'Next Page' to continue the signup process.")
                        .multilineTextAlignment(.center)
                       .font(.system(size: 15.0))
                        //You will recieve reminders in this app to update your primary information, if needed, every month.
                    }
                    /*
                         
                     - implement zoom feature for profile picture
                     - map profile picture to the circle on main page
                     */
                  //Spacer()
                
                    NavigationLink(destination:
                    ImagePage()) {
                        Image(systemName: "person.crop.circle.fill").resizable().frame(width: 80, height: 80).padding()
                            .foregroundColor(.black)
                    }
                    //.ButtonRender()
                    
                    TextField("First Name", text: $firstname)
                        .TextFieldRender()
                    
                    TextField("Last Name", text: $lastname)
                        .TextFieldRender()
                    
                    TextField("Username", text: $username)
                        .TextFieldRender()
                    
                    TextField("email", text: $email)
                        .TextFieldRender()
                    
                    TextField("Password", text: $password)
                        .TextFieldRender()
                    
                    TextField("Confirm Password", text: $confirmpassword)
                            .TextFieldRender()
                /* in this navigation link, if name/username/email have all been used or taken before, alert and say need to put in something else. if password do not match, alert to fix
                     */
                    HStack{
                        Button(action: {
                            if (self.password != self.confirmpassword) {
                                print("hi")
                                self.Verification = true
                                self.ToggleVar = "Pass"
                            }
                            else if (self.checkemail(self.email) == true ) {
                                self.Verification = true
                                self.ToggleVar = "Email"
                            }
                            else {
                                print(self.password)
                                print(self.confirmpassword)
                                //self.addusername(self.username)
                                 self.save_all_data(self.firstname, self.lastname, self.email, self.password, self.username, self.confirmpassword)
                            }
                        })
                        {
                            Text("Save Information")
                                .foregroundColor(.white)
                                .padding(9)
                        }
                            .ButtonRender()
                            .alert(isPresented: self.$Verification) {
                                switch ToggleVar {
                                case "Email":  return Alert(title: Text("You have entered an invalid email"), message: Text("Please enter a valid email."))
                                    
                                case "Pass":
                                    return Alert(title: Text("Your passwords do not match"), message: Text("Please retype your password carefully to ensure they match. If you think your passwords match, check to see if there are any spaces at the end of your password."))
                                
                                default:
                                     return Alert(title: Text("Your passwords do not match"), message: Text("Please retype your password carefully to ensure they match."))
                                }
                                                       }

                        
 
                NavigationLink(destination:
                  UserVerification()
        
                ) {
                    Text("Next Page")
                         .foregroundColor(.white)
                        .padding(9)
                }
                 .ButtonRender()
                
                
                }
                
                // need to add password verification
                
                }.navigationBarTitle("Sign Up")
            
        }
    }
 // edit function once confirmed how storing sign up and sign in page data
    func checkemail(_ email: String) -> Bool {
        var retBool: Bool = true
        for character in email {
            if(character == "@") {
                retBool = false
            }
        }
        return retBool
    }
    func passwordVerification(_ password: String,_ confirmpassword: String) -> Bool {
        if password == confirmpassword {
            return false
        }
        else {
            return true
        }
    }
    func save_all_data(_ firstname: String,_ lastname: String,_ email: String,_ password: String,_ username: String,_ confirmpassword: String){
        // functions to ensure username & email & password have not been taken
        addusername(username)
        addname(firstname, lastname)
        adduseremail(email)
        adduserpassword(password, username)
        
    }
    
    func addusername(_ username: String){
    
        let db = Firestore.firestore()
        let user = db.collection("usernames").document("\(username)")
        user.setData(["username": "\(username)"]) {
            (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("success")
            }
     }
    func addname(_ firstname: String,_ lastname: String){
        let db = Firestore.firestore()
        let user = db.collection("user name").document("\(username)")
        user.setData(["firstname": "\(firstname)", "lastname": "\(lastname)"]) {
            (err) in
            
            if err != nil {
                print((err?.localizedDescription)!)
                return
            }
            print("success")
        }
    }
    func adduseremail(_ email: String){
         let db = Firestore.firestore()
               let user = db.collection("user email").document("\(username)")
               user.setData(["email": "\(email)"]) {
                   (err) in
                   
                   if err != nil {
                       print((err?.localizedDescription)!)
                       return
                   }
                   print("success")
               }
           }
    func adduserpassword(_ password: String,_ username: String){
        let db = Firestore.firestore()
            let user = db.collection("user password").document("\(username)")
        user.setData(["username": "\(username)", "password": "\(password)"]) {
                (err) in
                
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                print("success")
            }
    }
}

    struct UserVerification: View {
    @EnvironmentObject var switchBool: ScreenSwitchBools
    @State private var Registered: Bool = false
    @State var Recepient: Bool = true
    @State var NotRecepient: Bool = true
    @State var Helper: Bool = true
    @State var NotHelper: Bool = true
    var body: some View {
                VStack{
                           Text("Page Two")
                               .font(.system(size: 28.0))
                                .padding(.bottom)
                               // .padding(.bottom)
                           Text("Here, you will recieve verifications that will decide how you are allowed to use the application. There are two ways you can be verified to use this app: as a helper, and as a recepient. You can choose to be a helper and a recepient, or either of the roles. Below are two buttons that you can click on to learn more about how having these verifications will affect your usage of the app. These buttons will take you to another page where you can get verified for each role as well.")
                               .multilineTextAlignment(.center)
                              .font(.system(size: 15.0))
                    
                     //  You can be both a helper and a recepient; recepients use this app to post emergencies. For more information on becoming a recepient, click the 'Recepient' button on the previous page."
                               
                    Spacer()
                  
                    NavigationLink( destination:
                        HelperPage(helper: self.$Helper, nothelper: self.$NotHelper)
                
               
                       ) {
                           Text("Helper")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                               .padding(9)
                       }
                         .padding()
                               .frame(width: 300, height: 200, alignment: .center)
                               .overlay(
                                   RoundedRectangle(cornerRadius: 100)
                                       .stroke(Color.red, lineWidth: 3) )
                    Spacer()
                    
                    NavigationLink(destination:
                        RecepientPage(recepient: self.$Recepient, notrecepient: self.$NotRecepient)
                        
                            ) {
                                    Text("Recepient")
                                         .foregroundColor(.black)
                                        .font(.largeTitle)
                                        .padding(9)
                            }
                                .padding()
                                       .frame(width: 300, height: 200, alignment: .center)
                                       .overlay(
                                           RoundedRectangle(cornerRadius: 100)
                                               .stroke(Color.red, lineWidth: 3) )
                    Spacer()
                    HStack {
                    Button(action: {
                        self.Registered = true // make registration alert happen after run function and send data to firebase
                        /*
                        print(self.Helper)
                        print(self.NotHelper)
                        print(self.Recepient)
                        print(self.NotRecepient)
                        */
                        
                        self.VerificationData(self.Helper, self.NotHelper, self.Recepient,self.NotRecepient)
                    
                    }
                    ) {
                        Text("Save Verification Info")
                                                           .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(9)
                                              
                        }
                        .padding()
                        .frame(width: 200, height: 50, alignment: .center)
                        .overlay(
                        RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 3) )
                        .alert(isPresented: self.$Registered ){
                                                   Alert(title: Text("You have successfully registered for this app!"), message: Text("Click 'Register for App' to go to your homescreen!"))
                             }
                    Button(action: {
                        self.switchBool.switchViews = false
                        print(self.switchBool.switchViews)
                    }
                        ) {
                                Text("Register for App")
                                     .foregroundColor(.black)
                                    .font(.system(size: 15))
                                    .padding(9)
                        }
                            .padding()
                                   .frame(width: 200, height: 50, alignment: .center)
                                   .overlay(
                                       RoundedRectangle(cornerRadius: 10)
                                           .stroke(Color.red, lineWidth: 3) )
                   
                    Spacer()
                    }
                    
            }
                        
                       }
    
    func VerificationData(_ HelperYes: Bool, _ HelperNo: Bool, _ RecYes: Bool,_ RecNo: Bool){
               var HelperData: Bool = false
        // change to int later so can have another state in which indicate that nothing was pressed by user, but tried to save data
               var RecieverData: Bool = false
               if(!HelperYes && HelperNo) {
                   HelperData = true
               }
               else if(HelperYes && !HelperNo){
                   HelperData = false
               }
               else {
                   print("something is wrong here...") //send back input to user that one should be clicked and other should not - make way to unclick the buttons
               }
               
               if(!RecYes && RecNo) {
                   RecieverData = true
                          }
               else if(RecYes && !RecNo){
                   RecieverData = false
                          }
               else {
                              print("something is wrong here...") //send back input to user that one should be clicked and other should not - make way to unclick the buttons
                          }
               
               let db = Firestore.firestore()
               // change document to username
               let user = db.collection("User Verifications").document("Ansh")
               user.setData(["Helper Status": HelperData, "Recepient Status": RecieverData]) {
                       (err) in
                                            
                       if err != nil {
                   print((err?.localizedDescription)!)
                   return
                   }
               print("success")
               }

           }
        }

struct RecepientPage: View {
     @Binding var recepient: Bool
     @Binding var notrecepient: Bool
    @State var rectoggle: Bool = false
    @State var notrectoggle: Bool  = false
     var body: some View {
        VStack{
                      Text("Verification Page to Become a Recepient")
                          .font(.system(size: 23.0))
                           .padding(.bottom)
            Text("What does it mean to be a 'Recepient'?")
                        .font(.system(size: 20.0))
                        .padding(.bottom)
                          // .padding(.bottom)
                      Text("Recepients use this app to post emergencies they are having. These emergencies must be urgent and important; recepients who post emergencies that do not threaten the lives of themselves or others in some significant way will be banned from using this platform. It is integral to this platform that recepients post credible emergencies that require other people's help to resolve. Without this integrity, this platform--which can do so much good for those who have legitament emergencies--will not have credibility and trust from the public to use. Therefore, in your hand is the immense responsibility of using this app ethically to maintain its reputation. The development team for this app hopes that you assume and uphold this responsibility for the future of the platform. To use this app as a reciever, please click 'I need help from others!' below. If you have chosen not to use this app as a reciever, click 'I do not need help from others through this app.'")
                          .multilineTextAlignment(.center)
                         .font(.system(size: 15.0))
                          
            Spacer()
            Button(action: {
                self.recepient = false
                self.rectoggle = true
                print(self.recepient)
            } ) {  Text("I need help from others")
                .foregroundColor(.black)
                .font(.system(size: 20.0))
                .padding(9)
                 }
                        .padding()
                        .frame(width: 300, height: 150, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100).stroke(Color.red, lineWidth: 3) )
        
                .alert(isPresented: self.$rectoggle ){
             Alert(title: Text("You Have Registered as a Recepient"), message: Text("Please go back to the last page, and decide whether you would like to be a helper as well."))
            }
             
               Spacer()
            Button(action: {
                self.notrecepient = false
                self.notrectoggle = true
            } ) {  Text("I do not need help from others through this app")
                .foregroundColor(.black)
                .font(.system(size: 20.0))
                .padding(9)
                 }
                        .padding()
                        .frame(width: 300, height: 150, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100).stroke(Color.red, lineWidth: 3) )
            
                .alert(isPresented: self.$notrectoggle ){
             Alert(title: Text("You Have Chosen Not to Register as a Recepient"), message: Text("Thank you for being honest. We only want those who have legitament emergencies to post for help on this app. Please go back to the last page and decide whether you want to be a helper."))
            }
 
            Spacer()
                  }
           
    }
}
struct HelperPage: View {
    @Binding var helper: Bool
    @Binding var nothelper: Bool
    @State var helptoggle: Bool = false
    @State var nothelptoggle: Bool = false
     var body: some View {
        VStack{
                      Text("Verification Page to Become a Helper")
                          .font(.system(size: 24.0))
                           .padding(.bottom)
            Text("What does it mean to be a 'Helper'?")
                        .font(.system(size: 20.0))
                        .padding(.bottom)
                          // .padding(.bottom)
                      Text("Helpers on this app have the responsibility of responding to emergencies they believe they can dedicate their full effort and support towards. Helpers will have access to postings of individuals that are having emergencies, and can respond to them by texting or calling through this app. Being a helper is an emmense responsibility. Helpers must be active in assisting individuals who need help through this app, and cannot use this app for any other reason that to help those in need. Any abuse of this platform by a helper will result in an automatic ban from using this platform ever again. If you would like to use this app as a helper, please click 'I want to help others!' below. If you feel that the responsibilities of being a helper are too much for you (which is completely fine!), please click 'I do not want to help others through this app.' Admitting you cannot help others will do more good for them in the long run, so please click this choice of you have any hesitation.")
                          .multilineTextAlignment(.center)
                         .font(.system(size: 15.0))
           
                          
            Spacer()
            Button(action: {
                self.helper = false
                self.helptoggle = true
                print(self.helper)
            } ) {  Text("I want to help others!")
                .foregroundColor(.black)
                .font(.system(size: 20.0))
                .padding(9)
                 }
                        .padding()
                        .frame(width: 300, height: 150, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100).stroke(Color.red, lineWidth: 3) )
                .alert(isPresented: self.$helptoggle ){
             Alert(title: Text("You Have Registered as a Helper!"), message: Text("Please go back to the last page, and decide whether you would like to be a recepient as well."))
            }
             
               Spacer()
            Button(action: {
                self.nothelper = false
                self.nothelptoggle = true
            } ) {  Text("I do not want to help others through this app")
                .foregroundColor(.black)
                .font(.system(size: 20.0))
                .padding(9)
                 }
                        .padding()
                        .frame(width: 300, height: 150, alignment: .center)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100).stroke(Color.red, lineWidth: 3) )
                .alert(isPresented: self.$nothelptoggle ){
             Alert(title: Text("You have chosen not to register as a helper"), message: Text("Thank you for being honest. We only want those who are dedicated to helping others to be helpers. Please go back to the last page and decide whether you want to be a recepient."))
            }
            Spacer()
                  }
           
    }
}
}



struct SignUpPage_Previews: PreviewProvider {
    static var previews: some View {
        SignUpPage()
    }
}
