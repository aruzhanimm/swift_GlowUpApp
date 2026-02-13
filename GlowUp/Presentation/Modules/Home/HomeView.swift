
import SwiftUI
import Kingfisher

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.backgroundDark.ignoresSafeArea()
                
                if viewModel.isLoading {
                   
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .neonPink))
                        .scaleEffect(2)
                } else if let error = viewModel.errorMessage {
                   
                    VStack {
                        Image(systemName: "exclamationmark.triangle")
                            .foregroundColor(.red)
                            .font(.largeTitle)
                        Text(error)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            viewModel.loadProducts()
                        }
                    }
                } else {
                   
                    ScrollView {
                      
                        HStack {
                            Text("New Arrivals")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.products) { product in
                              
                                NavigationLink(destination: ProductDetailView(product: product)) {
                                    ProductCard(product: product)
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
               
                if viewModel.products.isEmpty {
                    viewModel.loadProducts()
                }
            }
        }
    }
}

struct ProductCard: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading) {
           
            KFImage(product.imageURL)
                .placeholder {
                  
                    Rectangle().fill(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 120)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(10)
            
        
            Text(product.brand?.uppercased() ?? "BRAND")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .padding(.top, 5)
            
            
            Text(product.name)
                .font(.headline)
                .foregroundColor(.white)
                .lineLimit(2) // Максимум 2 строки
                .multilineTextAlignment(.leading)
            
           
            Text(product.priceInTenge)
                .font(.subheadline)
                .foregroundColor(.neonPink)
                .padding(.top, 2)
        }
        .padding()
        .background(Color.cardDark) 
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 5)
    }
}

#Preview {
    HomeView()
}
