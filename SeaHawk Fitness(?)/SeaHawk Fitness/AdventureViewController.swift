//
//  AdventureViewController.swift
//  SeaHawk Fitness
//
//  Created by Weston E Jones, James Stinson Gray  on 4/6/16.
//  Copyright © 2016 James Stinson Gray. All rights reserved.
//

import UIKit
// initializes the view controller and specifies which API should be used for this page
class AdventureViewController:
UIViewController, UICollectionViewDelegate, UICollectionViewDataSource,
UITextFieldDelegate, UICollectionViewDelegateFlowLayout{

    
    // ---------  OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    
    // ---------- API STRINGS
    let adventuresAPI = "AdventuresService"
    
    var RequestARGs = ""
    var EditARGs = ""
    
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    // reloads the data in the collection view
    // parameter notification: the notification that the page need to be reloaded
    func refreshList(notification: NSNotification){
        
        self.collectionView.reloadData()
    }
    
    // specifies what must be loaded on the page whenever it is accessed.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.mainScreen().bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList:", name:"refreshMyData", object: nil)
        
        let layout: UICollectionViewFlowLayout = AdventuresCollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        let nib = UINib(nibName: "AdventuresCollectionCell", bundle: nil)
        
        collectionView.registerNib(nib, forCellWithReuseIdentifier: "AdventureCell")
        
        let contentArea = UIImage(named: "ContentArea")!
        view.backgroundColor = UIColor(patternImage: contentArea.scaleUIImageToSize(contentArea, size: CGSizeMake(screenWidth, screenHeight)))

        // Do any additional setup after loading the view.
    }
    // specifies what the page should display whenever a user segues into it.
    override func viewWillAppear(animated: Bool) {
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.backgroundColor = UIColor.clearColor()
        collectionView.layer.cornerRadius = 8
        collectionView.layer.masksToBounds = true
        
        searchBar.placeholder = "What adventure are you looking for?"
        searchBar.delegate = self
        
        refreshButton.setTitle("Refresh Adventures", forState: UIControlState.Normal)
        
        if AdventuresItems.count == 0 {
            getAdventures()
        }

    }
    // attempts to detect for loss of memory
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ***
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return AdventuresItems.count
    }
    // ***
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AdventuresCollectionCell = (collectionView.dequeueReusableCellWithReuseIdentifier("AdventureCell", forIndexPath: indexPath) as? AdventuresCollectionCell)!
        
        let trip = AdventuresItems[indexPath.row]
        
        cell.setupCell( trip.name, date: trip.day, price: 10, image: trip.adventureImage)
        //cell.backgroundColor = UIColor.cyanColor()
        return cell
    }
    
    // *** Required Function of CollectionViews: determines selected cell at click
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let selectectedAdventure = AdventuresItems[indexPath.row]
        
        print("Adventure Name = " + selectectedAdventure.name)
        print("Adventure Description = " + selectectedAdventure.description)
        print("Adventure Time = " + selectectedAdventure.time)
        
    }
    
    // Makes the reuqest to the database to populate the adventures page.
    func getAdventures(){
        makeDatabaseRequest(self.view, API: adventuresAPI, EditARGs: EditARGs, RequestARGs: RequestARGs)
    }
    
    // button to update the sa_adventures page
    // parameter sender: the button that when pressed requests for a refresh
    @IBAction func updateAdventures(sender: UIButton) {
        let adventureName = searchBar?.text
        RequestARGs = "name=" + adventureName!
        AdventuresItems.removeAll()
        getAdventures()
    }
    
    // *** Used to dismiss the keyboard on enter.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    /**
     * Called when the user click on the view (outside the UITextField).
     */
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // ***
    @IBAction func PresentInfoView(sender: AnyObject) {
    }

}
