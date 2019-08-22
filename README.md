# Mobile Store (Work in progress throughout July-August)
Building an E-commerce (and Admin) application for my friend to sell his pottery. App will integrate Firebase/Firestore/Kingfisher and Stripe

## Step 1: Created initial Login and Registration front end

<img src="initial.png" width="500" height="350" />

## Step 2: Password matching animation, user error messages and custom messages 

<img src="pmatch.gif" width="150" height="300"/> <img src="userError.gif" width="150" height="300"/> <img src="customError.gif" width="150" height="300"/>

## Step 3: Added forgot password functionality, along with Home table view, and product table view to show categories and products. Updated design.  

<img src="segue.gif" width="150" height="300"/> <img src="udesign.png" width="150" height="300"/>

## Key Learning

* Storyboard building/Auto Layout/Stackviews
* Firebase connection 
* Firebase register new users
* Password matching using controls, adding targets and actions to controls
* Added RoundedViews for images and buttons, Constants and extensions file to clean up code
* User error messages 
* Forgot password through firebase
* Custome cell Xibs for collectionView (Currently effected by error, may change) and TableView 
* Segues to move between CollectionView and tableView
* Intiated firestore with data for categories
* Fetched, parse, append, create new category and display data from firestore
* Fetch and parse collection of data from firestore 
* Added listener to immeadiately update changes in database

