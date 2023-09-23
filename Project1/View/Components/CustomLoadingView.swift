//
//  CustomLoadingView.swift
//  Project1
//
//  Created by Dave Gumba on 2023-09-19.
//

/*
// To anyone who finds this file, I apologize in advance for
// the non-optimal code.
 
The same way that Pompeiians used phalluses for good luck, here, is a digital blessing in hopes for good luck, despite whatever catastrophe this code may bring:
 
 //                   _ooOoo_
 //                  o8888888o
 //                  88" . "88
 //                  (| -_- |)
 //                  O\  =  /O
 //               ____/`---'\____
 //             .'  \\|     |//  `.
 //            /  \\|||  :  |||//  \
 //           /  _||||| -:- |||||-  \
 //           |   | \\\  -  /// |   |
 //           | \_|  ''\---/''  |   |
 //           \  .-\__  `-`  ___/-. /
 //         ___`. .'  /--.--\  `. . __
 //      ."" '<  `.___\_<|>_/___.'  >'"".
 //     | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 //     \  \ `-.   \_ __\ /__ _/   .-` /  /
 //======`-.____`-.___\_____/___.-`____.-'======
 //                   `=---='
 //
 //^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 //          佛祖保佑           永无BUG
 //         God Bless        Never Crash

*/

import SwiftUI

struct CustomLoadingView: View {
    @State var text: String = ""
    @State var secondaryText: String = "Please wait..."
    @State var tertiaryText: String = "Almost there..."
    @State var fourthText: String = "Almost!!"
    @State var displaySecondaryText = false
    @State var displayTertiaryText = false
    @State var displayFourthText = false

    var body: some View {
        ProgressView(displayFourthText ? fourthText :  (displayTertiaryText ? tertiaryText : (displaySecondaryText ? secondaryText : text)))
            .font(.headline)
            .progressViewStyle(CircularProgressViewStyle())
            .tint(.blue)
            .padding()
            .task {
                await delayProgressViewText()
            }
    }
    
    private func delayProgressViewText() async {
        // 1 second = 1_000_000_000 nanoseconds
        try? await Task.sleep(nanoseconds: 3_500_000_000)
        displaySecondaryText = true
        
        try? await Task.sleep(nanoseconds: 3_500_000_000)
        displaySecondaryText = false
        displayTertiaryText = true
        
        try? await Task.sleep(nanoseconds: 4_500_000_000)
        displayFourthText = false
        displayTertiaryText = true
    }
}

struct CustomLoadingView_Previews: PreviewProvider {
    static var previews: some View {
        CustomLoadingView(text: "Loading")
    }
}
