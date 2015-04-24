//
//  Model.swift
//  TableViewCellWithAutoLayout
//
//  Copyright (c) 2014 Tyler Fox
//

import UIKit

class Model
{
    struct CellData {
        let title: String
        let message: String
        let hasHeader: Bool
    }
    
    var data = [CellData]()
    
    
    private var exampleTitle: NSString = "Steve Jobs, BMW & eBay"
    
    private var exampleMessage: NSString = "And you know what? He’s right.\nThe world doesn’t need another Dell or HP.  It doesn’t need another manufacturer of plain, beige, boring PCs.  If that’s all we’re going to do, then we should really pack up now.\nBut we’re lucky, because Apple has a purpose.  Unlike anyone in the industry, people want us to make products that they love.  In fact, more than love.  Our job is to make products that people lust for.  That’s what Apple is meant to be.\nWhat’s BMW’s market share of the auto market?  Does anyone know?  Well, it’s less than 2%, but no one cares.  Why?  Because either you drive a BMW or you stare at the new one driving by.  If we do our job, we’ll make products that people lust after, and no one will care about our market share.\nApple is a start-up.  Granted, it’s a startup with $6B in revenue, but that can and will go in an instant.  If you are here for a cushy 9-to-5 job, then that’s OK, but you should go.  We’re going to make sure everyone has stock options, and that they are oriented towards the long term.  If you need a big salary and bonus, then that’s OK, but you should go.  This isn’t going to be that place.  There are plenty of companies like that in the Valley.  This is going to be hard work, possibly the hardest you’ve ever done.  But if we do it right, it’s going to be worth it.\n"
    
    
    
    func appendData(count: Int) {
        for var i = 0; i < count; i++ {
            data.append(randomCellData())
        }
    }
    
    func randomCellData() -> CellData {
        
        var randomNumber1 = Int(arc4random_uniform(UInt32(exampleMessage.length)))
        var randomNumber2 = Int(arc4random_uniform(UInt32(exampleMessage.length)))
        
        let message = exampleMessage.substringWithRange(NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2))) + "m" //make sure it contains at least 1 char
        
        randomNumber1 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        randomNumber2 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        let title = exampleTitle.substringWithRange(NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2))) + "t" //make sure it contains at least 1 char
        
        let hasHeader = (arc4random_uniform(6) % 2) == 1
        
        return CellData(title: title, message: message, hasHeader: hasHeader)
    }
}
