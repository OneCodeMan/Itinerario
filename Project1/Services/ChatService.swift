//
//  ChatService.swift
//  Project1
//
//  Created by Dave Gumba on 2023-08-31.
//

import Foundation
import ChatGPTSwift

struct ChatService {
    
    public var responseData: String = ""
    let API_KEY = "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"
    
    // Function to call ChatGPT here
    func getChatData() async throws -> String {
        do {
            let api = ChatGPTAPI(apiKey: API_KEY)
            
            let message = "TODO"
            
            let response = try await api.sendMessage(text: "7 day itinerary to Tokyo.",
                                                     model: "gpt-3.5-turbo",
                                                     systemText: "You are a CS Professor",
                                                     temperature: 0.5)
            print(response)
            return response
        } catch {
            print(error.localizedDescription)
        }
            
        return ""
    }
    
}

struct MOCK_DATA {
    
    let tokyoItinerarySevenDays = """
    Day 1: Arrival and Exploration of Shibuya
    - Arrive in Tokyo and check into your accommodation.
    - Start your trip by exploring the vibrant neighborhood of Shibuya. Visit the famous Shibuya Crossing, known as one of the busiest intersections in the world.
    - Explore the trendy shopping streets of Shibuya, such as Takeshita Street and Center Street.
    - Visit the Meiji Shrine, a serene oasis in the heart of the city.

    Day 2: Cultural Exploration in Asakusa and Ueno
    - Start your day by visiting Senso-ji, Tokyo's oldest and most famous Buddhist temple, located in Asakusa.
    - Explore Nakamise Shopping Street, where you can find traditional souvenirs and snacks.
    - Visit the Tokyo National Museum in Ueno Park, which houses an extensive collection of Japanese art and artifacts.
    - Enjoy a relaxing stroll through Ueno Park, known for its beautiful cherry blossoms (if in season) and various museums.

    Day 3: Modern Tokyo in Shinjuku and Akihabara
    - Begin your day in Shinjuku, one of Tokyo's busiest and most vibrant districts. Visit the Tokyo Metropolitan Government Building for panoramic views of the city.
    - Explore the lively streets of Kabukicho, known for its entertainment and nightlife.
    - Head to Akihabara, the center of Japanese pop culture and electronics. Visit the numerous anime and manga stores, as well as the famous electronic shops.

    Day 4: Day Trip to Hakone
    - Take a day trip to Hakone, a picturesque town known for its hot springs and stunning views of Mt. Fuji (weather permitting).
    - Enjoy a scenic boat ride on Lake Ashi and take the Hakone Ropeway for breathtaking views of the surrounding mountains.
    - Visit the Owakudani Valley, known for its volcanic activity and black eggs boiled in sulfuric hot springs.
    - Relax in one of the many hot spring resorts in Hakone before returning to Tokyo.

    Day 5: Imperial Palace and Ginza
    - Start your day by visiting the Imperial Palace, the primary residence of the Emperor of Japan. Explore the beautiful gardens and learn about Japan's imperial history.
    - Head to Ginza, Tokyo's upscale shopping district. Explore the luxury boutiques, department stores, and enjoy a delicious meal at one of the many gourmet restaurants.

    Day 6: Harajuku and Odaiba
    - Begin your day in Harajuku, known for its unique fashion and vibrant street culture. Visit the iconic Takeshita Street and explore the trendy shops and cafes.
    - Visit the teamLab Borderless digital art museum in Odaiba, where you can immerse yourself in interactive and mesmerizing art installations.
    - Enjoy a stroll along Odaiba's waterfront and take in the stunning views of Tokyo Bay.

    Day 7: Day Trip to Nikko
    - Take a day trip to Nikko, a UNESCO World Heritage site known for its historical shrines and natural beauty.
    - Visit Toshogu Shrine, the final resting place of Tokugawa Ieyasu, the founder of the Tokugawa shogunate.
    - Explore the beautiful natural surroundings, including the Kegon Falls and Lake Chuzenji.
    - Return to Tokyo and spend your last evening exploring any areas you may have missed or revisit your favorite spots.
    """
    
}
