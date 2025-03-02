import SwiftUI
import Design


public struct BuddiesProfileView: View {
    
    @ObservedObject private var viewModel: BuddiesProfileViewModel
    @EnvironmentObject private var coordinator: BuddiesProfileCoordinator

    @State private var selectionSegment: String = "Posts"
    private var segments: [String] = ["Posts", "Liked"]
    
    init(viewModel: BuddiesProfileViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            GeometryReader { geometry in
                let size = geometry.size
                
                VStack {
                    HStack {
                        if let urlString = viewModel.profileInfos?.picture,
                           let url = URL(string: urlString) {
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
                        if let profileInfos = viewModel.profileInfos {
                            VStack(alignment: .leading) {
                                Text(profileInfos.name)
                                    .font(.title2)
                                    .foregroundColor(Color.dynamicColor)
                                
                                Text(profileInfos.email)
                                    .font(.system(size: 18, weight: .light))
                                    .foregroundColor(Color.dynamicColor.opacity(0.6))
                                
                                HStack(spacing: 20) {
                                    
                                    if let url = URL(string: profileInfos.linkedin ?? "") {
                                        Link(destination: url) {
                                            Image("linkedinIcon")
                                                .resizable()
                                                .scaledToFit()
                                                .foregroundColor(Color.dynamicColor)
                                                .frame(height: 25)
                                        }
                                    }
                                    
                                    if let url = URL(string: profileInfos.github ?? "") {
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
                        } else {
                            VStack {
                                ProgressView()
                                Text("Loading...")
                                    .font(.title3)
                                    .foregroundColor(Color.dynamicColor)
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
                        Button {
                            coordinator.push(.settings)
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
