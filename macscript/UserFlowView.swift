//
//  UserFlowView.swift
//  macscript
//
//  Created by Ainara Garcia on 5/5/23.
//

import SwiftUI

struct UserFlowView: View {
    static var palera1n = "palera1n-macos-universal"
    @State var step = Step.MAIN_MENU
    @State var cmd: [String] = []
    @State var enterAction: String? = ""
    
    var body: some View {
        VStack {
            switch step {
            case Step.MAIN_MENU:
                ContentView(flow: self)
            case Step.PALERA1N:
                Palera1nView(flow: self)
            case Step.TERMINAL:
                LogsView(flow: self)
            }
        }
    }
    
    func runCommand(cmd: [String], enterAction: String? = nil) {
        self.cmd = cmd
        self.step = Step.TERMINAL
        self.enterAction = enterAction
    }
    func runCommand(cmd: String, enterAction: String? = nil) {
        self.cmd = cmd.components(separatedBy: " ")
        self.step = Step.TERMINAL
        self.enterAction = enterAction
    }
}

struct UserFlowView_Previews: PreviewProvider {
    static var previews: some View {
        UserFlowView()
    }
}
