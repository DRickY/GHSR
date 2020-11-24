//
//  ConcurrencySearch.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import Foundation

class ConcurrencyRequests {
    
    private let maxConcurrentOperationCount: Int
    private let workerQueue = DispatchQueue(label: "com.ConcurrencyRequests.queue", attributes: .concurrent)
    private let group = DispatchGroup()
    private var blocks = Atomic(value: [() -> Void]())

    init(maxConcurrentOperationCount: Int) {
        self.maxConcurrentOperationCount = maxConcurrentOperationCount
    }   
    
    func executeGroup(_ backgroundBlock: @escaping (@escaping() -> Void) -> Void, notify queue: DispatchQueue, on: @escaping () -> Void) {

        for _ in 0..<self.maxConcurrentOperationCount {
            self.group.enter()
            
            self.blocks.mutate { $0.append({ self.group.leave() }) }
            
            self.workerQueue.async(group: group) { [weak self] in
                self?.blocks.mutate { value in
                    let block = value.remove(at: 0)
                    backgroundBlock(block)
                }
            }
        }
        
        print("count blocks \(self.blocks.value.count)")
        
        
        group.notify(queue: queue, execute: on)
    }
}


