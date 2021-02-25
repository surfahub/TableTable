//
//  RatingControl.swift
//  TableTable
//
//  Created by Surfa on 26.02.2021.
//

import UIKit

@IBDesignable class RatingControl: UIStackView {

   private var ratingbuttons = [UIButton]()
   var rating = 0
    
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
        print("Button pressed")
    }
    
    // MARK: Setup Buttons
    
    private func setupButtons(){
        
        for button in ratingbuttons {
            
            removeArrangedSubview(button)
            button.removeFromSuperview()
            
        }
        
        ratingbuttons.removeAll()
        
        for _ in 0 ..< starCount {
            
            let button = UIButton()
            
            button.backgroundColor = .red
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
             
            
            // setup the button action
            
            button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            
            ratingbuttons.append(button)
        }
        
    }

}
