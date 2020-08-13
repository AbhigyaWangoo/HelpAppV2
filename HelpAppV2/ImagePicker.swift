//
//  ImagePicker.swift
//  TemporaryHelpApp
//
//  Created by Ansh Verma on 7/28/20.
//  Copyright © 2020 Ansh Verma. All rights reserved.
//
import SwiftUI
import FirebaseStorage


struct ImagePicker: UIViewControllerRepresentable {
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let image = info[.originalImage] as! UIImage
            
            
    
            let storage = Storage.storage()
            storage.reference().child("Photos").putData(image.jpegData(compressionQuality: 0.35)!, metadata: nil) { (_ , err) in
                if err != nil {
                    print((err?.localizedDescription)!)
                    return
                }
                print("works")
                    
            }
                
    
            
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagepic = UIImagePickerController()
        imagepic.sourceType = .photoLibrary
        imagepic.delegate = context.coordinator
        return imagepic
    }
    
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    
}
