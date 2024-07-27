//
//  HomeView.swift
//  iOS-watchOS-demo-1 Watch App
//
//  Created by Lakshya Verma on 24/07/24.
//

import Foundation
import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.cyan)
                .padding(.top, 0)
            // Add more content for the homepage here
        }
    }
}

#Preview {
    HomeView()
}
