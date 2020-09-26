import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    
    var memes = [MemeData]()

    override func viewDidLoad() {
        super.viewDidLoad()
        memeCollectionView.delegate = self
        memeCollectionView.dataSource = self
        configureLayoutFlow()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
          
          // Access to the shared data model
          let appDelegate = UIApplication.shared.delegate as! AppDelegate
          memes = appDelegate.memes
        
          memeCollectionView.reloadData()
      }
    
    func configureLayoutFlow() {
        

        let itemSize = UIScreen.main.bounds.width/3 - 3
              
              flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
              flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
              
              flowLayout.minimumInteritemSpacing = 3
              flowLayout.minimumLineSpacing = 3
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "viewcontroller") as! MeViewController
        present(vc, animated: true)
    }
}

    extension MemeCollectionViewController {
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return memes.count
        }
        
        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "memeCollectionViewCell", for: indexPath) as! MemeCollectionViewCell
               let meme = memes[indexPath.row]
            
            //cell.contentView.frame = cell.bounds
            //cell.contentView.autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin, .flexibleTopMargin, .flexibleHeight, .flexibleBottomMargin]
               
               cell.memeiamge.image = meme.memedImage
               
               return cell
        }
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
            let vc = storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as! MeViewController
                
            vc.sentTopText = memes[indexPath.row].topText
            vc.sentBottomText = memes[indexPath.row].bottomText
            vc.sentImage = memes[indexPath.row].originalImage
            
            present(vc, animated: true, completion: nil)
        }
    }
