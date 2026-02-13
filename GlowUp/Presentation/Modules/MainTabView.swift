//  MainTabView.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import SwiftUI

struct MainTabView: View {
   
    init() {
       
        UITabBar.appearance().backgroundColor = UIColor(Color.cardDark)
        UITabBar.appearance().barTintColor = UIColor(Color.cardDark)
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
           
            HomeView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Feed")
                }
            
            
            SearchView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
                        FavoritesView()
                            .tabItem {
                                Image(systemName: "heart")
                                Text("Favorites")
                            }
         
                        ProfileView()
                            .tabItem {
                                Image(systemName: "person")
                                Text("Profile")
                            }
        }
        
    }
    #Preview {
        MainTabView()
    }
}
