import UIKit

protocol SettingViewProtocol: AnyObject {
    var tableView: UITableView {get set}
}

class SettingView: UIViewController, SettingViewProtocol {

    var presenter: SettingViewPresenterProtocol!
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: view.bounds, style: .insetGrouped)
        table.dataSource = self
        table.backgroundColor = .appMain
        table.separatorStyle = .none
        
        table.register(SettingViewCell.self, forCellReuseIdentifier: SettingViewCell.reuseId)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(tableView)
        title = "Настройки"
        view.backgroundColor = .appMain
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = .appMain
        
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
    }
  
}

extension SettingView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        SettingItems.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingViewCell.reuseId, for: indexPath) as! SettingViewCell
        let cellItem = SettingItems.allCases[indexPath.row]
        cell.cellSetup(cellType: cellItem)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        
        cell.completion = {
            if indexPath.row == 0 {
                let passcodeVC = Builder.getPasscodeController(passcodeState: .setNewPasscode, sceneDelegate: nil, isSetting: true)
                self.present(passcodeVC, animated: true)
            }
        }
        
        return cell
    }
    
    
}
