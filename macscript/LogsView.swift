//
//  jbview.swift
//  macscript
//
//  Created by Nara Garcia on 5/5/23.
//

import SwiftUI
import Foundation

struct LogsView: View {
    let flow: UserFlowView?
    @State var outpipe: Pipe?
    @State var inpipe: Pipe?
    @State var task: Process?
    @State var running = false
    @State var output = ""
    @State var showEnter = false
    @State var finished = false
    
    init(flow: UserFlowView?) {
        self.flow = flow
    }
    
    func start() async {
        running = true
        outpipe = Pipe()
        inpipe = Pipe()
        task = Process()
        var cmd = flow!.cmd
        let exec = cmd.removeFirst()
        
        if String(exec).hasPrefix("/") {
            task!.executableURL = URL(string: "file://" + String(exec))
        } else {
            task!.executableURL = Bundle.main.resourceURL?.appendingPathComponent(String(exec))
        }
        
        task!.arguments = []
        if exec.contains("palera1n") {
            task!.arguments = [ "-SvVL" ]
        }
        for arg in cmd {
            task!.arguments?.append(String(arg))
        }
        task!.standardOutput = outpipe
        task!.standardError = outpipe
        task!.standardInput = inpipe
        
        outpipe!.fileHandleForReading.readabilityHandler = { pipe in
            if let line = String(data: pipe.availableData, encoding: .utf8) {
                if line.lengthOfBytes(using: .utf8) > 0 {
                    /*if line.contains("[K") {
                        var spl = output.components(separatedBy: "\n")
                        spl.popLast()
                        output = String(spl.joined(separator: "\n"))
                    }*/
                    let renderline = line.replacingOccurrences(of: "[K", with: "")
                    if renderline.trimmingCharacters(in: .whitespacesAndNewlines).lengthOfBytes(using: .utf8) > 0 {
                        output += renderline
                    }
                    if line.lowercased().contains("press") && line.lowercased().contains("enter") {
                        showEnter = true
                    }
                }
            } else {
                print("Error decoding data: \(pipe.availableData)")
            }
        }
        
        DispatchQueue(label: "itsmaclol.macscriptgui.task").async {
            try? task!.run()
            task!.waitUntilExit()
            finished = true
            running = false
        }
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                HStack {
                    if running && !finished {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.5)
                    }
                    Button("Start", action: {
                        finished = false
                        output = ""
                        Task {
                            await start()
                        }
                    })
                    .disabled(running)
                    .padding()
                    
                    if flow!.enterAction != nil {
                        Button(flow!.enterAction!, action: {
                            inpipe?.fileHandleForWriting.write("\r\n".data(using: .utf8)!)
                            showEnter = false
                        }).disabled(!showEnter)
                    }
                    
                    if running {
                        Button("Terminate") {
                            Task { task!.terminate() }
                        }
                    } else {
                        Button("Main Menu") {
                            flow!.step = Step.MAIN_MENU
                        }
                    }
                }
                VStack {
                    TextEditor(text: $output)
                        .frame(minWidth: 640, minHeight: 320, maxHeight: .infinity)
                        .scrollContentBackground(.hidden)
                        .background(Color(hue: 0.7, saturation: 0.5, brightness: 0.2))
                        .padding(25)
                        .onChange(of: output) { _ in
                            proxy.scrollTo(0, anchor: .bottom)
                        }
                        .id(0)
                    Spacer().frame(height: 0)
                }
            }
        }
    }
}

struct JBView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView(flow: nil)
    }
}
