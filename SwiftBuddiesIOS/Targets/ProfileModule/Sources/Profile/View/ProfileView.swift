import SwiftUI
import Design


public struct ProfileView: View {
    
    public init() { }
    
    @StateObject private var viewModel = ProfileViewModel()
    
    @State private var selectionSegment: String = "Posts"
    private var segments: [String] = ["Posts", "Liked"]
    
    public var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let size = geometry.size
                
                VStack {
                    HStack {
                        if let url = URL(string: viewModel.profileInfos.picture) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                Circle()
                                    .foregroundColor(.gray.opacity(0.3))
                            }
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.horizontal, 10)
                            .padding(.trailing, 10)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.profileInfos.name)
                                .font(.title2)
                                .foregroundColor(Color.dynamicColor)
                            
                            Text(viewModel.profileInfos.email)
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(Color.dynamicColor.opacity(0.6))
                            
                            HStack(spacing: 20) {
                                
                                if let url = URL(string: viewModel.profileInfos.linkedin ?? "") {
                                    Link(destination: url) {
                                        Image("linkedinIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color.dynamicColor)
                                            .frame(height: 25)
                                    }
                                }
                                
                                if let url = URL(string: viewModel.profileInfos.github ?? "") {
                                    Link(destination: url) {
                                        Image("githubIcon")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(Color.dynamicColor)
                                            .frame(height: 25)
                                        
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Picker("", selection: $selectionSegment) {
                        ForEach(segments, id: \.self) { item in
                            Text(item)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.vertical, 10)
                    .padding(.horizontal)
                    
                    
                }
                .frame(width: size.width)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingsView()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundStyle(Color.dynamicColor)
                        }
                    }
                }
                .task {
                    await viewModel.getProfileInfos()
                }
                
            }
        }
        
    }
}


#Preview {
    ProfileView()
}
