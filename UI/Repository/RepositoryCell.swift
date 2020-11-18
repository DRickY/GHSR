//
//  RepositoryCell.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import UIKit
import SwiftUI

class RepositoryCell: UITableViewCell {
    
    lazy var titleLabel = UILabel()
    lazy var countLabel = UILabel()
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var countLabel: UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    func setupViews() {
        let content = self.contentView
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        content.addSubview(stack)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = .systemFont(ofSize: 14)
        countLabel.textColor = .darkGray
        
        [titleLabel, countLabel].forEach(stack.addArrangedSubview)
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: stack.topAnchor, constant: -8),
            content.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -4),
            content.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -4),
            content.bottomAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: 8)
        ])
    }
    
    func fill(text: String, description: String) {
        titleLabel.text = text
        
        countLabel.text = description
        self.layoutIfNeeded()
    }
}


#if canImport(SwiftUI) && targetEnvironment(simulator) && DEBUG
class PreviewUIView: PreviewProvider {
    
    static var previews: some View {
        Group {
            UIViewPreview {
                let cell = RepositoryCell(frame: .zero)
                cell.backgroundColor = .white
                return cell
            }
            .previewDisplayName("Cell")
            .frame(width: 414.0, height: 60)
            .previewLayout(.sizeThatFits)

            
        }
    }
}
#endif
