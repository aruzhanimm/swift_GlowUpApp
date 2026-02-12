import SwiftUI
import Kingfisher

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    let columns = [GridItem(.flexible(), spacing: 16), GridItem(.flexible(), spacing: 16)]
    
    // Список категорий, которые поддерживает API
    let categories = ["Mascara", "Lipstick", "Foundation", "Eyeliner", "Eyeshadow", "Blush"]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // --- 1. Поисковая строка ---
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Search brand (e.g. nyx)...", text: $viewModel.searchText)
                            .foregroundColor(.white)
                            .accentColor(.neonPink)
                            .disableAutocorrection(true)
                        
                        if !viewModel.searchText.isEmpty {
                            Button(action: { viewModel.searchText = "" }) {
                                Image(systemName: "xmark.circle.fill").foregroundColor(.gray)
                            }
                        }
                    }
                    .padding()
                    .background(Color.cardDark)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // --- 2. Фильтры (Категории) ---
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(categories, id: \.self) { category in
                                Button(action: {
                                    viewModel.selectCategory(category)
                                }) {
                                    Text(category)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(
                                            // Если выбрано - розовый, если нет - темно-серый
                                            viewModel.selectedCategory == category ? Color.neonPink : Color.cardDark
                                        )
                                        .foregroundColor(
                                            viewModel.selectedCategory == category ? .black : .white
                                        )
                                        .cornerRadius(20)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                    }
                    
                    // --- 3. Результаты ---
                    if viewModel.isLoading {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .neonPink))
                            .scaleEffect(1.5)
                        Spacer()
                    } else if let message = viewModel.errorMessage {
                        Spacer()
                        Text(message).foregroundColor(.gray).padding()
                        Spacer()
                    } else if viewModel.searchResults.isEmpty {
                        Spacer()
                        VStack(spacing: 15) {
                            Image(systemName: "sparkle.magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.cardDark)
                            Text("Find your favorite products")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 20) {
                                ForEach(viewModel.searchResults) { product in
                                    NavigationLink(destination: ProductDetailView(product: product)) {
                                        ProductCard(product: product)
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    SearchView()
}
