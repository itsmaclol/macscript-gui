//
//  Palera1nView.swift
//  macscript
//
//  Created by Nara Garcia on 5/5/23.
//

import SwiftUI

struct Palera1nView: View {
    var flow: UserFlowView?
    
    init(flow: UserFlowView?) {
        self.flow = flow
    }
    
    var body: some View {
        Image("macscript")
        Image("palera1n")
            .resizable()
            .frame(width: 64.0, height: 64.0)
        HStack {
            VStack {
                Menu("Rootful") {
                    Button("Setup FakeFS", action: setupFakefs)
                    Button("Setup BindFS", action: setupBindfs)
                    Button("Boot Rootful", action: rootful)
                    Button("Safe Mode", action: safemodeful)
                    Button("Restore RootFS", action: restoreful)
                }
                .fixedSize()
                
                Menu("Rootless") {
                    Button("Boot Rootless", action: rootless)
                    Button("Safe Mode", action: safemodeless)
                    Button("Restore RootFS", action: restoreless)
                }
                .fixedSize()
                
                Button("DFU Helper", action: dfuhelper)
                Button("Enter Recovery Mode", action: enterrecv)
                Button("Exit Recovery Mode", action: exitrecv)
                Button("Main Menu") { flow?.step = Step.MAIN_MENU }
            }
        }
    }
    
    func rootful() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -f", enterAction: "Start DFU Helper")
    }
    func setupFakefs() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -cf", enterAction: "Start DFU Helper")
    }
    func setupBindfs() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -Bf", enterAction: "Start DFU Helper")
    }
    func safemodeful() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -fs", enterAction: "Start DFU Helper")
    }
    func restoreful() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " --force-revert -f", enterAction: "Start DFU Helper")
    }
    func rootless() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -l", enterAction: "Start DFU Helper")
    }
    func safemodeless() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -s", enterAction: "Start DFU Helper")
    }
    func restoreless() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " --force-revert", enterAction: "Start DFU Helper")
    }
    func dfuhelper() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " --dfuhelper", enterAction: "Start DFU Helper")
    }
    func enterrecv() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -E", enterAction: "Start DFU Helper")
    }
    func exitrecv() {
        self.flow!.runCommand(cmd: UserFlowView.palera1n + " -n", enterAction: "Start DFU Helper")
    }
}

struct Palera1nView_Previews: PreviewProvider {
    static var previews: some View {
        Palera1nView(flow: nil)
    }
}
