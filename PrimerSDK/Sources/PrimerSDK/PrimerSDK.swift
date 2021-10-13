import UIKit

public struct Primer {
    
    public static var shared = Primer()
    public weak var delegate : PrimerDelegate?
    public var theme : PrimerTheme = PrimerTheme()
    public var settings : PrimerSettings?
    
    var viewModel = PrimerCheckoutViewModel()
    
    private init() {}
    
    public func showCheckout(on viewController : UIViewController) {
        guard let settings = settings else {
            print("You must provide the Settings")
            return
        }
        
        let checkoutVC = PrimerCheckoutViewController(viewModel : viewModel,
                                                      theme: theme)
        viewModel.delegate = delegate
        viewModel.settings = settings
        viewController.present(checkoutVC,
                               animated: true,
                               completion: nil)
    }
}
