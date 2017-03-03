//
//  Utils.swift
//  MyNinja
//
//  TP 1 MacOSX
//  Paris Diderot
//  Binonme
//  Rakotonirina Eric Niaina
//  Rahajarivelo Manambintsoa Miora Tahina
//  Copyright © 2017 Home. All rights reserved.
//
//From
//  Utilities.swift
//  Platformer
//
//  Created by MattBaranowski on 2/15/16.
//  Copyright © 2016 mattbaranowski. All rights reserved.
//
import Foundation

func * (a : CGPoint, b : CGPoint) -> CGPoint {
    return CGPoint(x: a.x * b.x,y: a.y * b.y)
}

func * (a : CGPoint, b : CGFloat) -> CGPoint {
    return CGPoint(x: a.x * b, y: a.y * b)
}

func * (a : CGPoint, b : Double) -> CGPoint {
    let f = CGFloat(b)
    return CGPoint(x: a.x * f, y: a.y * f)
}

func + (a : CGPoint, b : CGPoint) -> CGPoint {
    return CGPoint(x: a.x + b.x,
                   y: a.y + b.y)
}

func - (a : CGPoint, b : CGPoint) -> CGPoint {
    return CGPoint(x: a.x - b.x, y: a.y - b.y)
}

func min<T: Comparable>(a : T, b : T) -> T {
    return a < b
        ? a : b
}
