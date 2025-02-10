import SwiftUI
import Design

// com.dogukaank.SwiftBuddiesIOS

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
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .foregroundColor(Color.dynamicColor)
                            .padding(.horizontal, 10)
                            .padding(.trailing, 10)
                        
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.profileInfos.name)
                                .font(.title2)
                                .foregroundColor(Color.dynamicColor)
                            
                            Text(viewModel.profileInfos.email)
                                .font(.system(size: 18, weight: .light))
                                .foregroundColor(Color.dynamicColor.opacity(0.6))
                            
                            HStack(spacing: 20) {
                                Link(destination: URL(string: "https://www.linkedin.com/in/fatih-ozen/")!) {
                                    Image("linkedinIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.dynamicColor)
                                        .frame(height: 25)
                                }
                                
                                Link(destination: URL(string: "https://github.com/Fatihozn")!) {
                                    Image("githubIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(Color.dynamicColor)
                                        .frame(height: 30)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    
                                }
                                
                                Spacer()
                            }
                            
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    Picker("Select your language", selection: $selectionSegment) {
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
