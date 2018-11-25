//
//  ViewController.swift
//  Flashcards
//
//  Created by Jaelyn Domingo on 10/13/18.
//  Copyright © 2018 Jaelyn Domingo. All rights reserved.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
}

class ViewController: UIViewController {

    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var card: UIView!
    
    // Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    // Current flashcard index
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Read saved flashcards
        readSavedFlashcards()
        
        // Adding our initial flashcard if needed
        if flashcards.count == 0 {
            updateFlashcard(question: "What is the phase going from a Liquid to a Solid?", answer: "Deposition")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func didTapOnFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        if frontLabel.isHidden == true {
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {self.frontLabel.isHidden = false})
        } else {
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {self.frontLabel.isHidden = true})
        }
        
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)}, completion: { finished in
            self.updateLabels()
            self.animateCardIn()
        })
    }
    
    func animateCardIn() {
        // Start on right side
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        
        // Animate card going back to OG position
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        // Decrease current index
        currentIndex -= 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        
        // Increase current index
        currentIndex += 1
        
        // Update labels
        updateLabels()
        
        // Update buttons
        updateNextPrevButtons()
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)

        // Adding flashcard to flashcards array
        flashcards.append(flashcard)
        
        // Logging to the console
        print("Added new flashcard")
        print("We now have \(flashcards.count) flashcards")
        
        // Update current index
        currentIndex = flashcards.count - 1
        print("Our current index is \(currentIndex)")
        
        // Update buttons
        updateNextPrevButtons()
        
        // Update labels
        updateLabels()
        
        // Save to disk
        saveAllFlashcardsToDisk()
    }

    func updateNextPrevButtons(){
        
        // Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        
        // Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        // Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func saveAllFlashcardsToDisk() {
    
        // From flashcard array to dictionary
        let dictionaryArray = flashcards.map { (card) -> [String : String] in return ["question": card.question, "answer": card.answer]
        }
        
        // save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        // Log it
        print("Flashcards saved to UserDefaults")
    }
    
    func readSavedFlashcards() {
        
        // Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String : String]] {
            
            // In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            
            // Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
    }
}

