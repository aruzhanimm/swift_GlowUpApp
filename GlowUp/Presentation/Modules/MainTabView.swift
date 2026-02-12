//  MainTabView.swift
//  GlowUp
//
//  Created by Аружан Картам on 10.02.2026.
//

import SwiftUI

struct MainTabView: View {
    // Инициализатор для настройки внешнего вида TabBar (нижней панели)
    init() {
        // Делаем нижнюю панель черной
        UITabBar.appearance().backgroundColor = UIColor(Color.cardDark)
        UITabBar.appearance().barTintColor = UIColor(Color.cardDark)
        // Скрываем линию разделителя
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray
    }
    
    var body: some View {
        TabView {
            // Вкладка 1: Главная
            HomeView() // <-- ЗАМЕНЯЕМ заглушку на наш готовый экран с косметикой
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Feed")
                }
            
            // Вкладка 2: Поиск
            SearchView() // <-- Вставляем наш новый экран
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            // Вкладка 3: Избранное
                        FavoritesView()
                            .tabItem {
                                Image(systemName: "heart")
                                Text("Favorites")
                            }
            // Вкладка 4: Профиль
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
