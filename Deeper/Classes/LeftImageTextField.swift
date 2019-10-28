import UIKit

class LeftImageTextField: UITextField {
    
    @IBInspectable private var leftImage: UIImage? {
        didSet {
            setLeftView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLeftView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLeftView()
    }
    
    private func setLeftView() {
        let leftImageView = UIImageView(image: leftImage)
        if let size = leftImageView.image?.size {
            leftImageView.frame = CGRect(x: 0.0, y: 0.0, width: size.width + 8.0, height: size.height)
        }
        leftImageView.contentMode = .right
        leftViewMode = .always
        leftView = leftImageView
    }
    
}
