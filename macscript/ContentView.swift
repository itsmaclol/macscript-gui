//
//  ContentView.swift
//  macscript
//
//  Created by Ainara Garcia on 5/5/23.
//

import SwiftUI

struct ContentView: View {
    let flow: UserFlowView?
    @State var palera1nDL = false
    @State var checkra1nDL = false
    @State var odysseyra1nDL = false
    @State var strapDL = false
    
    init(flow: UserFlowView?) {
        self.flow = flow
    }
    
    var body: some View {
        Image("macscript")
        VStack(alignment: .leading) {
            HStack {
                Image("palera1n")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                Button("palera1n", action: palera1n).disabled(palera1nDL)
                Text("Jailbreak for checkm8 devices (A8-A11) on iOS 15.0-16.4")
            }
            HStack {
                Image("checkra1n")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                Button("checkra1n", action: checkra1n).disabled(checkra1nDL)
                Text("Jailbreak for iPhone 5s through iPhone X, iOS 12.0 and up")
            }
            HStack {
                Image("sileo")
                    .resizable()
                    .frame(width: 32.0, height: 32.0)
                Button("odysseyra1n", action: odysseyra1n).disabled(odysseyra1nDL)
                Text("Procursus bootstrap for checkra1n")
            }
            if isBootstrapable() {
                HStack {
                    Image("procursus")
                        .resizable()
                        .frame(width: 32.0, height: 32.0)
                    Button("Bootstrap Procursus", action: strap).disabled(strapDL)
                    Text("The macOS APT experience")
                }
            }
            
            Text("We are not responsible for any damage done to your devices while using this tool.")
            Text("Made by Mac and Ainara.")
        }
        .padding()
    }
    
    func isBootstrapable() -> Bool {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        return osVersion.majorVersion >= 11
    }
    
    func palera1n() {
        if UserFlowView.palera1n.hasPrefix("/") {
            self.flow!.step = Step.PALERA1N
            return
        }
        palera1nDL = true
        FileDownloader.githubAPI(url: "https://api.github.com/repos/palera1n/palera1n/releases") { data in
            let apijson = try! JSONDecoder().decode([ReleaseGitHubAPI].self, from: data!)
            if apijson.count > 0 {
                for asset in apijson[0].assets {
                    if asset.name == "palera1n-macos-universal" {
                        FileDownloader.loadFileAsync(url: URL(string: asset.browser_download_url)!) { (path, error) in
                            try! FileManager.default.setAttributes([ .posixPermissions: 0o755 ], ofItemAtPath: path!)
                            UserFlowView.palera1n = path!
                            palera1nDL = false
                            self.flow!.step = Step.PALERA1N
                        }
                        break
                    }
                }
            }
        }
    }
    
    func checkra1n() {
        checkra1nDL = true
        let url = URL(string: "https://assets.checkra.in/downloads/macos/754bb6ec4747b2e700f01307315da8c9c32c8b5816d0fe1e91d1bdfc298fe07b/checkra1n%20beta%200.12.4.dmg")!
        let app = FileManager.default.temporaryDirectory.appendingPathComponent("checkra1n.app")
        if FileManager.default.fileExists(atPath: app.absoluteString) {
            checkra1nDL = false
            Process.launchedProcess(launchPath: "/usr/bin/open", arguments: [ app.absoluteString ])
            return
        }
        FileDownloader.loadFileAsync(url: url) { (path, error) in
            Process.launchedProcess(launchPath: "/usr/bin/hdiutil", arguments: [ "attach", path!, "-mountpoint", "/Volumes/checkra1n", "-nobrowse" ]).waitUntilExit()
            try? FileManager.default.copyItem(at: URL(string: "file:///Volumes/checkra1n/checkra1n.app")!, to: app)
            try? FileManager.default.setAttributes([ .posixPermissions: 0o755 ], ofItemAtPath: app.absoluteString)
            Process.launchedProcess(launchPath: "/usr/bin/hdiutil", arguments: [ "detach", "/Volumes/checkra1n" ]).waitUntilExit()
            Process.launchedProcess(launchPath: "/usr/bin/open", arguments: [ app.absoluteString ])
            checkra1nDL = false
        }
    }
    
    func odysseyra1n() {
        odysseyra1nDL = true
        let url = URL(string: "https://raw.githubusercontent.com/coolstar/Odyssey-bootstrap/master/procursus-deploy-linux-macos.sh")!
        FileDownloader.loadFileAsync(url: url) { (path, error) in
            odysseyra1nDL = false
            try! FileManager.default.setAttributes([ .posixPermissions: 0o755 ], ofItemAtPath: path!)
            self.flow!.runCommand(cmd: [ "/bin/bash", "-c", path! ], enterAction: "Continue")
        }
    }
    
    func strap() {
        // we do a lil skidding
        strapDL = true
        let url = URL(string: "https://cdn.jdevstudios.es/macos-strap.sh")!
        FileDownloader.loadFileAsync(url: url) { (path, error) in
            strapDL = false
            try! FileManager.default.setAttributes([ .posixPermissions: 0o755 ], ofItemAtPath: path!)
            
            self.flow!.runCommand(cmd: [ "/usr/bin/osascript", "-e", "do shell script \"bash " + path! + "\" with administrator privileges" ], enterAction: nil)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(flow: nil)
    }
}
