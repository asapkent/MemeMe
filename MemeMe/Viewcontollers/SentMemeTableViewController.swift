    import UIKit
    
    class SentMemeTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Variable to hold the saved memes
    var memes = [MemeData]()
    // Instance of the tableview
    
    @IBOutlet weak var sentMemeTableView: UITableView!
    
    
    override func viewDidLoad() {
    super.viewDidLoad()
    sentMemeTableView.reloadData()
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    memes = appDelegate.memes
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    memes = appDelegate.memes
    
    // Reload tableview
    sentMemeTableView.reloadData()
    }
        @IBAction func addButtonPressed(_ sender: Any) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
                    
                    present(vc, animated: true, completion: nil)
        }
    }
    
    extension SentMemeTableViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "memescell", for: indexPath)
    let meme = memes[indexPath.row]
    
    cell.imageView?.image = meme.memedImage
    cell.textLabel?.text = "\(meme.topText) \(meme.bottomText)"
    
    return cell
    }
    
    // Present a meme generator view controller when user taps on cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    let memeGeneratorVC = storyboard?.instantiateViewController(withIdentifier: "viewcontroller") as! ViewController
    
    memeGeneratorVC.sentTopText = memes[indexPath.row].topText
    memeGeneratorVC.sentBottomText = memes[indexPath.row].bottomText
    memeGeneratorVC.sentImage = memes[indexPath.row].originalImage
    
    present(memeGeneratorVC, animated: true, completion: nil)
    }
}
