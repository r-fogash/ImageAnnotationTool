//
//  SelectionViewProtocol.swift
//  ImageMarkTool
//
//  Created by Robert on 05.04.2020.
//  Copyright © 2020 Robert. All rights reserved.
//
import AppKit

protocol SelectionViewProtocol: class {
    
    var leftAnchorRect: NSRect {get}
    var rightAnchorRect: NSRect {get}
    var topAnchorRect: NSRect {get}
    var bottomAnchorRect: NSRect {get}
    var viewRect: NSRect {get}
    
    func beginResizeWidth(mouseLocation: NSPoint)
    func beginResizeHeight(mouseLocation: NSPoint)
    func beginDrag(mouseLocation: NSPoint)
    func remove()
    
    func handleDrag(mouseLocation: NSPoint)

}
