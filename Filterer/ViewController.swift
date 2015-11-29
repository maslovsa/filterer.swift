//
//  ViewController.swift
//  Filterer
//
//  Created by MaslovSA on 2015-11-29.
//  Copyright © 2015 All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    let animationDuration = 0.4
    let alphaColor: CGFloat = 0.3
    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewFiltered: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderMenu: UIView!
    
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet weak var buttonCompare: UIButton!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet weak var buttonEdit: UIButton!
    
    @IBOutlet weak var visualOriginal: UIVisualEffectView!
    @IBOutlet weak var slider: UISlider!
    var image: UIImage?
    var isShowOriginal = true
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        sliderMenu.translatesAutoresizingMaskIntoConstraints = false
        initButtons()
    }
    
    func initButtons() {
        image = imageView.image
        buttonCompare.enabled = false
        buttonEdit.enabled = false
        visualOriginal.alpha = 0
        filterButton.selected = false
        
    }
    
    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageViewFiltered.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    @IBAction func showEdit(sender: UIButton) {
        if hasSlider(currentIndex) {
            buttonEdit.selected = !buttonEdit.selected
            if buttonEdit.selected {
                if filterButton.selected {
                    filterButton.selected = false
                    hideSecondaryMenu()
                }
                showSlider()
            } else {
                hideSlider()
            }
        }
    }
    
    @IBAction func showFilter(sender: UIButton) {
        sender.selected = !sender.selected
        if (sender.selected) {
            if buttonEdit.selected {
                buttonEdit.selected = false
                hideSlider()
            }
            
            showSecondaryMenu()
        } else {
            hideSecondaryMenu()
        }
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }

    @IBAction func onCompareImages(sender: AnyObject) {
        isShowOriginal = !isShowOriginal
        changeView(isShowOriginal)
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(55)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(animationDuration) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func showSlider() {
        view.addSubview(sliderMenu)
        
        let bottomConstraint = sliderMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = sliderMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = sliderMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(55)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.sliderMenu.alpha = 0
        UIView.animateWithDuration(animationDuration) {
            self.sliderMenu.alpha = 1.0
        }
    }
    
    func hideSecondaryMenu(useAnimation: Bool = true) {
        if useAnimation {
            
        
        UIView.animateWithDuration(animationDuration, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
        } else {
                self.secondaryMenu.removeFromSuperview()
        }
    }
    
    func hideSlider(useAnimation: Bool = true) {
        if useAnimation {
        UIView.animateWithDuration(animationDuration, animations: {
            self.sliderMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.sliderMenu.removeFromSuperview()
                }
        }
        } else {
            self.sliderMenu.removeFromSuperview()
        }
    }
    
    func getImage(index: Int) -> String {
        switch index{
        case 0...2: return "paint-brush"
        case 3:     return "charlie-chaplin" // black-white
        case 4:     return "camera-photo"    // sepia
        case 5:     return "paint-bucket"    // brightness
        case 6:     return "paint-roller"    // contrast
        case 7:     return "pencil-ruler"    // trunc
        default: return "bomb"
        }
    }
    
    func getColor(index: Int) -> UIColor {
        switch index{
        case 0:     return UIColor.redColor().colorWithAlphaComponent(alphaColor)
        case 1:     return UIColor.greenColor().colorWithAlphaComponent(alphaColor)
        case 2:     return UIColor.blueColor().colorWithAlphaComponent(alphaColor)
            
        case 3:     return UIColor.blackColor().colorWithAlphaComponent(alphaColor)
        case 4:     return UIColor.orangeColor().colorWithAlphaComponent(alphaColor)
 
        default: return UIColor.whiteColor().colorWithAlphaComponent(alphaColor)
        }
    }
    
    func hasSlider(index: Int) -> Bool {
        switch index{
        case 3...4:     return false
        default: return true
        }
    }
    
    func applyFilterWithNumber(index: Int){
        let raw = ImageFilter(image: image!)
        switch index {
        case 0:
            let value = slider.value
            raw.applyFilter(.Red(value))
            imageViewFiltered.image = raw.image
        case 1:
            let value = slider.value
            raw.applyFilter(.Green(value))
            imageViewFiltered.image = raw.image
        case 2:
            let value = slider.value
            raw.applyFilter(.Blue(value))
            imageViewFiltered.image = raw.image
        case 3:
            raw.applyFilter(.GreyScale)
            imageViewFiltered.image = raw.image
        case 4:
            raw.applyFilter(.Sepia)
            imageViewFiltered.image = raw.image
        case 5:
            let value = slider.value * (5 - 0.2) + 0.2
            raw.applyFilter(.Brightness(value)) // use 0.2 to 5
            imageViewFiltered.image = raw.image
        case 6:
            let value = slider.value * (256) - 128
            raw.applyFilter(.Contrast(value)) // use -128 to +128
            imageViewFiltered.image = raw.image
        case 7:
            let value = slider.value * (200) - 50
            raw.applyFilter(.TruncToWhite(value)) // use -50 to 150
            imageViewFiltered.image = raw.image
        
        default: break

        
        }
        buttonCompare.enabled = true
        changeView(false)
    }
    
    
    func changeView(isShowOriginal: Bool){
        if isShowOriginal{
            self.visualOriginal.alpha = 1.0

            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 1.0
                self.imageViewFiltered.alpha = 0.0
            }
            
        } else {
            self.visualOriginal.alpha = 0.0

            UIView.animateWithDuration(animationDuration) {
                self.imageView.alpha = 0.0
                self.imageViewFiltered.alpha = 1.0
            }
        }
    }

    @IBAction func sliderDragged(sender: AnyObject) {
        applyFilterWithNumber(currentIndex)
    }
    
    @IBAction func touchDown(sender: AnyObject) {
        changeView(true)
    }
    
    @IBAction func upInside(sender: AnyObject) {
        changeView(false)
    }
}

// MARK: UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
            self.changeView(true)
            self.initButtons()

    }
}

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return 8;
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCellWithReuseIdentifier("CELL", forIndexPath: indexPath) as! MyCell
        let image = UIImage(named: getImage(indexPath.row))
        cell.imageView.image = image
        cell.backgroundColor = getColor(indexPath.row)
        return cell
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1;
    }
}

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        currentIndex = indexPath.row
        buttonEdit.enabled = hasSlider(currentIndex)
        applyFilterWithNumber(currentIndex)
    }
}
