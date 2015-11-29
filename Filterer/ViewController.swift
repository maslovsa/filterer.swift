//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate {
    let animationDuration = 0.4
    var filteredImage: UIImage?
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageViewFiltered: UIImageView!
    
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var sliderMenu: UIView!
    
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet weak var buttonCompare: UIButton!
    
    @IBOutlet weak var buttonEdit: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet var filterButton: UIButton!
    var image: UIImage?
    var isShowOriginal = true
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        
        image = imageView.image
        buttonCompare.enabled = false
        buttonEdit.enabled = false
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", imageView.image!], applicationActivities: nil)
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

    @IBAction func showEdit(sender: AnyObject) {

        if hasSlider(currentIndex) {
            buttonEdit.selected = !buttonEdit.selected
            if buttonEdit.selected {
                showSlider()
                hideSecondaryMenu(false)
            } else {
                hideSlider()
                showSecondaryMenu()
            }
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

    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
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
        let heightConstraint = sliderMenu.heightAnchor.constraintEqualToConstant(50)
        
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
    
    func hideSlider() {
        UIView.animateWithDuration(animationDuration, animations: {
            self.sliderMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.sliderMenu.removeFromSuperview()
                }
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
        case 0:     return UIColor.redColor()
        case 1:     return UIColor.greenColor()
        case 2:     return UIColor.blueColor()
        default: return UIColor.whiteColor()
        }
    }
    
    func hasSlider(index: Int) -> Bool {
        switch index{
        case 4..<5:     return false
        default: return true
        }
    }
    
    func applyFilterWithNumber(index: Int){
        let raw = ImageFilter(image: image!)
        switch index {
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
            imageView.alpha = 1.0
            imageViewFiltered.alpha = 0.0
        } else {
            imageView.alpha = 0.0
            imageViewFiltered.alpha = 1.0
        }
    }

    @IBAction func sliderDragged(sender: AnyObject) {
        applyFilterWithNumber(currentIndex)
    }
}

// MARK: UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.image = image
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
