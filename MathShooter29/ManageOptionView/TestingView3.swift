//
//  TestingView3.swift
//  MathShooter29
//
//  Created by วรัญพงษ์ สุทธิพนไพศาล on 25/1/2567 BE.
//

import SwiftUI
import PhotosUI

var BossChoice = UserDefaults.standard
@MainActor
final class PhotoPickerViewModel: ObservableObject{
    @Published private(set) var seledtedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil{
        didSet{
            setImage(from: imageSelection)
        }
    }
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        Task {
            do {
                let data = try await selection.loadTransferable(type: Data.self)
                guard let data, let uiImage = UIImage(data: data) else {
                    throw URLError(.badServerResponse)
                }
                // Instead of resizing, directly proceed to save with adjusted quality
                DispatchQueue.main.async {
                    self.seledtedImage = uiImage
                    self.saveImageToFileSystem(uiImage)
                }
            } catch {
                print("Error loading image: \(error)")
            }
        }
    }
    private func saveImageToFileSystem(_ image: UIImage) {
        // Target size for the image
        let targetSize = CGSize(width: 80, height: 80)
        
        // Resize the image to the target size while maintaining aspect ratio
        guard let resizedImage = resizeImage(image, to: targetSize) else {
            print("Error resizing image")
            return
        }
        
        // Compress the resized image
        guard let data = resizedImage.jpegData(compressionQuality: 0.5) else { // Adjust compression quality as needed
            print("Could not get JPEG representation of UIImage")
            return
        }
        
        // Save the compressed and resized image to the file system
        let filename = getDocumentsDirectory().appendingPathComponent("BossImage.jpg")
        do {
            try data.write(to: filename)
            BossChoice.set(filename.path, forKey: "BossImagePath")
        } catch {
            print("Error saving image to file system: \(error)")
        }
    }

    // Helper function to resize an image to a target size while maintaining its aspect ratio
    private func resizeImage(_ image: UIImage, to targetSize: CGSize) -> UIImage? {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Determine the scale factor that preserves aspect ratio
        let scaleFactor = min(widthRatio, heightRatio)
        
        let scaledWidth  = size.width * scaleFactor
        let scaledHeight = size.height * scaleFactor
        let targetRect = CGRect(x: (targetSize.width - scaledWidth) / 2.0,
                                y: (targetSize.height - scaledHeight) / 2.0,
                                width: scaledWidth,
                                height: scaledHeight)
        
        // Create a new context with the target size and scale the image
        UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
        image.draw(in: targetRect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func clearSelectedImage() {
        DispatchQueue.main.async {
            self.seledtedImage = nil
            UserDefaults.standard.removeObject(forKey: "BossImagePath")
        }
    }
}

struct TestingView3: View {
    @StateObject private var viewModel = PhotoPickerViewModel()
    //@StateObject private var viewModel2 = PhotoPickerViewModel2()
    @State private var message: Bool = false
    @State private var navigateToOthers = false
    //@State private var navigateToOthers2 = false
    var body: some View {
        NavigationView{
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .ignoresSafeArea(.all)
                VStack(spacing: 40){
                    VStack(alignment: .center, content: {
                        Text("slide to back")
                        Image(systemName: "chevron.down")
                    })
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 10, x: 0, y: 0)

                    Spacer()
                    Text("Boss One")
                        .foregroundColor(.black)
                        .font(.custom("Chalkduster", size: 40))
                        .foregroundColor(.black)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .shadow(color: .gray, radius: 20, x: 0, y: 0)
                    
                    Button{
                        //others()
                        navigateToOthers = true
                    } label: {
                        Text("Boss Simulation")
                            .foregroundColor(.black)
                            .font(.custom("Chalkduster", size: 20))
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .gray, radius: 20, x: 0, y: 0)
                    }
                    .sheet(isPresented: $navigateToOthers, content: {
                        others()
                    })
                    //You have modified the Boss1 interface. To see the result, please click the simulation button at the top. If you do not want to keep these changes, please click 'Clear Image.
                    //.foregroundColor(.red)
                    VStack{
                        if message{
                            VStack{
                                HStack{
                                    Image(systemName: "leaf")
                                        .foregroundColor(.green)
                                    Text("You have modified Boss1 interface.")
                                        .foregroundColor(.black)
                                }
                                HStack{
                                    Image(systemName: "arrowshape.down")
                                        .foregroundColor(.green)
                                    Text("To see the result")
                                        .foregroundColor(.black)
                                    Image(systemName: "arrowshape.down")
                                        .foregroundColor(.green)
                                }
                                HStack{
                                    Text("please click")
                                        .foregroundColor(.black)
                                    Text("Boss Simulation")
                                        .foregroundColor(.blue)
                                }
                                HStack{
                                    Image(systemName: "xmark")
                                    Image(systemName: "bin.xmark.fill")
                                }
                                .foregroundColor(.green)
                                .padding(0.5)
                                Text("If you do not want to keep these changes,")
                                    .foregroundColor(.black)
                                HStack{
                                    Text("please click")
                                        .foregroundColor(.black)
                                    Text("Clear Image")
                                        .foregroundColor(.red)
                                }
                            }
                            .font(.custom("", size: 12.5))
                            //.frame(width: 100, height: 100)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 2), value: message)
                            .onAppear{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 6){
                                    withAnimation{
                                        message = false
                                    }
                                }
                            }
                        }
                        HStack{
                            if let image = viewModel.seledtedImage{
                                Image(uiImage:image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .cornerRadius(10)
                                Button("Clear Image") {
                                    viewModel.clearSelectedImage()
                                }
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .shadow(color: .white, radius: 10, x: 0, y: 0)
                                .onAppear{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4){
                                        withAnimation{
                                            message = true
                                        }
                                    }
                                }
                            }
                        }
                    }
                    PhotosPicker(selection: $viewModel.imageSelection, matching: .images){
                        Text("Select image")
                            .foregroundColor(.black)
                            .padding()
                            .background(Color.gray.opacity(0.15))
                            .foregroundColor(.white)
                            .cornerRadius(20)
                            .shadow(color: .gray, radius: 20, x: 0, y: 0)
                    }
                    /*PhotosPicker(selection: $viewModel2.imageSelection2, matching: .images){
                        Text("another phtos")
                            .foregroundColor(.blue)
                    }*/
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    TestingView3()
}

