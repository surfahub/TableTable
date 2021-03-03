//
//  RatingControl.swift
//  TableTable
//
//  Created by Surfa on 26.02.2021.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

   private var ratingButtons = [UIButton]()
    var rating = 0 {
        didSet{
            updateButtonSelectedState()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    
    @IBInspectable var starSize:CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame :frame)
        
        setupButtons()
    }
        
    required init(coder: NSCoder) {
        super.init(coder : coder)
        
        setupButtons()
    }
    //MARK: Button Actions

    @objc func ratingButtonTapped(button: UIButton) {
        
        guard let index = ratingButtons.firstIndex(of: button) else {return}
        
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        }
        else {
            rating = selectedRating
        }
    }
    
    // MARK: Setup Buttons
    
    private func setupButtons(){
        
        for button in ratingButtons {
            
            removeArrangedSubview(button)
            button.removeFromSuperview()
            
        }
        
        ratingButtons.removeAll()
        
        
        //setup buttons
        let bundle = Bundle(for: type(of: self))
        
        let filledStar = UIImage(named: "filledStar",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "emptyStar",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "highlightedStar",
                                      in: bundle, compatibleWith:
                                        self.traitCollection)
        
        
        
        
        for _ in 0 ..< starCount {
            
            let button = UIButton()
            
            
            // set the button image
            
            
            
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected] )
            
            
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
             
            
            // setup the button action
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingButtons.append(button)
        }
        updateButtonSelectedState()
        
    }
    
    private func updateButtonSelectedState(){
        
        for (index, button) in ratingButtons.enumerated() {
            
            button.isSelected = index < rating
        }
    }

}
