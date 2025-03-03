import SwiftUI
import Localization

struct RepoFilterView: View {
    let filters: [RepoFilter]
    let onFilterToggle: (RepoFilter) -> Void
    let onClearFilters: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                L.contributors_filter_by_repository
                    .font(.headline)
                Spacer()
                
                if filters.contains(where: \.isSelected) {
                    Button(L.$button_clear.localized, action: onClearFilters)
                        .font(.subheadline)
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(filters) { filter in
                        FilterChip(
                            title: filter.name,
                            isSelected: filter.isSelected
                        ) {
                            onFilterToggle(filter)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .contentMargins(.horizontal, 16)

        }
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.accentColor : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(isSelected ? Color.accentColor : Color.gray.opacity(0.3), lineWidth: 1)
                )
        }
    }
} 
