//
//  RepositoryCell.swift
//  GHSR
//
//  Created by Dmytro.k on 11/17/20.
//

import UIKit
import SwiftUI

//let id: Int
//let title: String
//let stars: Int


extension RepositoryCell {
    struct Props {
        let id : Id; struct Id {
            let value: String
        }
        
        let title: String
        let stars: Int
    }
}

class RepositoryCell: UITableViewCell {
    
    private lazy var titleLabel = UILabel()

    private lazy var countLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.titleLabel.text = nil
        self.countLabel.text = nil
    }
    
    private func setupViews() {
        let content = self.contentView
        
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 4
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        content.addSubview(stack)
        
        let titleLabel = self.titleLabel
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 0
        titleLabel.font = .systemFont(ofSize: 16)
        
        let countLabel = self.countLabel
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.font = .systemFont(ofSize: 14)
        countLabel.textColor = .darkGray
        
        [titleLabel, countLabel].forEach(stack.addArrangedSubview)
        
        let topButtomPadding: CGFloat = 8
        let leftRightPadding: CGFloat = 4
        
        NSLayoutConstraint.activate([
            content.topAnchor.constraint(equalTo: stack.topAnchor, constant: -topButtomPadding),
            content.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: -leftRightPadding),
            content.trailingAnchor.constraint(equalTo: stack.trailingAnchor, constant: -leftRightPadding),
            content.bottomAnchor.constraint(greaterThanOrEqualTo: stack.bottomAnchor, constant: topButtomPadding)
        ])
    }
    
    func fill(props: RepositoryCell.Props) {
        self.titleLabel.text = props.title
        self.countLabel.text = props.stars.description
        
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
