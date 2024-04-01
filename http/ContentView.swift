//
//  ContentView.swift
//  http
//
//  Created by Chidume Nnamdi on 4/1/24.
//

import SwiftUI

struct Photo: Codable, Identifiable {
    var id: Int;
    var title: String;
    var url: String;
    var thumbnailUrl: String;
}

struct ContentView: View {
    @State private var photos: [Photo]?
    @State private var selectedPhoto: Photo?
    
    func fetchData() async throws -> [Photo] {
        let url = URL(string: "https://jsonplaceholder.typicode.com/photos")
                    
        let (data, _) = try await URLSession.shared.data(from: url!)
        
        let decodedResponse = try? JSONDecoder().decode([Photo].self, from: data)
        
        return decodedResponse!
        
    }
    
    var body: some View {

        if(selectedPhoto != nil) {
            
            if(selectedPhoto?.url != nil) {
                let string =  String(selectedPhoto!.url)
                Group {
                    HStack {
                    Text("Image View")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.heavy).animation(.bouncy)
                    Spacer()
                    Image(systemName: "xmark.circle")
                    .font(.system(.title))
                    .onTapGesture {
                        selectedPhoto = nil
                    }
                  }
                    .padding(.horizontal)
                //.padding(.top, 20)
                
                    AsyncImage(url: URL(string: string))
                        .frame( maxHeight: .infinity)
                    Spacer()
                }

            }
            
        } else {
            NavigationView {
                if(photos != nil) {
                    List(photos!) { photo in
                        
                        VStack {
                            AsyncImage(url: URL(string: photo.thumbnailUrl)) {image in image
                                    .resizable()
                                    .frame(height: 200)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            Text(photo.title).bold()
                            
                        }.onTapGesture(perform: {
                            selectedPhoto = photo
                        })
                        
                    }.listStyle(.plain)
                    
                        .navigationTitle(Text("Photos").font(.system(.largeTitle, design: .rounded)))
                }
            }
            .onAppear {
                Task {
                    do {
                        photos = try await fetchData()
                    } catch {
                        print("Error fetching data: \(error)")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
