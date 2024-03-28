//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private var posts: [Post] = []

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        fetchPosts()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        
        let post = posts[indexPath.row]
        cell.captionLabel.text = post.summary
        if let photo = post.photos.first {
            let url = photo.originalSize.url
            Nuke.loadImage(with: url, into: cell.postView)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the desired height for your cells
        return 235
    }



    func fetchPosts() {
        // THATS SO FRICKING COOL. I JUST PUT IN BOBA BLOG AND IT GOT ME SO MUCH DATA TT I DIDNT HAVE TO DO ANYTHING IM SO HAPPYYYYY!!!!
        let url = URL(string: "https://api.tumblr.com/v2/blog/bobahol1c/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)

                DispatchQueue.main.async { [weak self] in
                    let allPosts = blog.response.posts
                    self?.posts = allPosts
                    self?.tableView.reloadData()


                    print("✅ We got \(allPosts.count) posts!")
                    for post in allPosts {
                        print("🍏 Summary: \(post.summary)")
                    }
                }

            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
}
