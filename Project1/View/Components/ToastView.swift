//
//  ToastView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-15.
//

import SwiftUI

/**
 Example use:
 VStack {
     Button {
         toast = FancyToast(type: .info, title: "Toast info", message: "Toast message")
     } label: {
         Text("Run")
     }

    }
    .toastView(toast: $toast)
 
 */

// MARK: Enum
enum ToastStyle {
    case error
    case warning
    case success
    case info
}

// MARK: Toast Style
extension ToastStyle {
    var themeColour: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        }
    }
    
    var iconFileName: String {
        switch self {
        case .error: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "checkmark.circle.fill"
        case .success: return "xmark.circle.fill"
        }
    }
}

// MARK: Toast struct
struct Toast: Equatable {
    var type: ToastStyle
    var title: String
    var message: String
    var duration: Double = 3
}

// MARK: Toast view
struct ToastView: View {
    var type: ToastStyle
    var title: String
    var message: String
    var onCancelTapped: (() -> Void)
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Image(systemName: type.iconFileName)
                    .foregroundColor(type.themeColour)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.system(size: 14, weight: .semibold))
                    
                    Text(message)
                        .font(.system(size: 12))
                        .foregroundColor(.black.opacity(0.6))
                }
                
                Spacer(minLength: 10) // woah spacers can have a min length
                
                Button {
                    onCancelTapped()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.black)
                }
            }
            .padding()
        }
        .background(.white)
        .overlay(
            Rectangle()
                .fill(type.themeColour)
                .frame(width: 6)
                .clipped(),
            alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
    }
}

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay(
                ZStack {
                    mainToastView()
                        .offset(y: -30)
                }.animation(.spring(), value: toast)
            )
            .onChange(of: toast) { value in
                showToast()
            }
    }
    
    @ViewBuilder func mainToastView() -> some View {
        if let toast = toast {
            VStack {
                Spacer()
                ToastView(type: toast.type, title: toast.title, message: toast.message) {
                    dismissToast()
                }
            }
            .transition(.move(edge: .bottom))
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }

        UIImpactFeedbackGenerator(style: .light).impactOccurred() // ???
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            toast = nil
        }
        
        workItem?.cancel()
        workItem = nil
    }
}

extension View {
    func toastView(toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}
