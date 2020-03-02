
import SwiftUI
import Combine


/// A view that displays store's sale items in a list.
struct SaleItemListView: View {
    
    @EnvironmentObject var saleItemDataSource: SaleItemDataSource
    
    @State private var showCreateSaleItemForm = false
    
    @State private var newSaleItemModel = SaleItemFormModel()
    
    @ObservedObject private var viewReloader = ViewForceReloader()
    
    @ObservedObject private var searchField = SearchField()
        
    @State private var showCreateItemFailedAlert = false
    
    
    
    // MARK: - Body
    
    var body: some View {
        List {
            SearchTextField(searchField: searchField)
                .onAppear(perform: setupSearchField)
            ForEach(saleItemDataSource.fetchedResult.fetchedObjects ?? [], id: \.self) {  saleItem in
                SaleItemRow(
                    saleItem: self.saleItemDataSource.readObject(saleItem),
                    onDeleted: self.viewReloader.forceReload
                )
            }
        }
        .onAppear(perform: setupView)
        .navigationBarItems(trailing: addNewSaleItemNavItem)
        .sheet(isPresented: $showCreateSaleItemForm, onDismiss: dismissCreateSaleItem, content: { self.createSaleItemForm })
        .alert(isPresented: $showCreateItemFailedAlert, content: { .createObjectWithoutCurrentStore(object: "Item") })
    }
}
 

// MARK: - Body Component

extension SaleItemListView {
    
    var addNewSaleItemNavItem: some View {
        Button(action: beginCreateNewSaleItem) {
            Image(systemName: "plus").imageScale(.large)
        }
    }
    
    var createSaleItemForm: some View {
        NavigationView {
            SaleItemForm(
                model: $newSaleItemModel,
                onCreate: saveNewSaleItem,
                onCancel: dismissCreateSaleItem,
                enableCreate: newSaleItemModel.saleItem!.isValid()
            )
                .navigationBarTitle("New Item", displayMode: .inline)
        }
    }
}


// MARK: - Method

extension SaleItemListView {
    
    func dismissCreateSaleItem() {
        saleItemDataSource.discardCreateContext()
        showCreateSaleItemForm = false
    }
    
    func beginCreateNewSaleItem() {
        if let store = Store.current(from: saleItemDataSource.createContext) {
            // discard and prepare a new item for the form
            saleItemDataSource.discardNewObject()
            saleItemDataSource.prepareNewObject()
            saleItemDataSource.newObject!.store = store
            newSaleItemModel = .init(saleItem: saleItemDataSource.newObject!)
            showCreateSaleItemForm = true
        } else {
            showCreateItemFailedAlert = true
        }
    }
    
    func saveNewSaleItem() {
        let result = saleItemDataSource.saveNewObject()
        switch result {
        case .saved: showCreateSaleItemForm = false
        case .failed: break // TODO: add alert
        case .unchanged: break
        }
    }
    
    func setupView() {
        fetchSaleItems()
    }
    
    func fetchSaleItems(withNameOrPrice predicate: String = "") {
        if let storeID = AppCache.currentStoreUniqueID {
            let request = SaleItem.requestObjects(storeID: storeID, withNameOrPrice: predicate)
            saleItemDataSource.performFetch(request)
        } else {
            saleItemDataSource.performFetch(SaleItem.requestNoObject())
        }
        viewReloader.forceReload()
    }
    
    func setupSearchField() {
        searchField.placeholder = "Search name or price"
        searchField.onSearchTextDebounced = fetchSaleItems
    }
}


struct SaleItemList_Previews : PreviewProvider {
    static var previews: some View {
        SaleItemListView()
    }
}
