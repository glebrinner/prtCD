

import SwiftUI


struct CustomerListView: View {
    
    @EnvironmentObject var customerDataSource: CustomerDataSource
    
    @State private var showCreateCustomerForm = false
    
    @State private var showCreateCustomerFailedAlert = false
    
    @State private var newCustomerModel = CustomerFormModel()
    
    @ObservedObject private var viewReloader = ViewForceReloader()
    
    @ObservedObject private var searchField = SearchField()
    
    var sortedCustomers: [Customer] {
        let customers = customerDataSource.fetchedResult.fetchedObjects ?? []
        return customers.sorted(by: { $0.identity.lowercased() < $1.identity.lowercased() })
    }
    
    
    // MARK: - Body
    
    var body: some View {
        List {
            SearchTextField(searchField: searchField)
                .onAppear(perform: setupSearchField)
            ForEach(sortedCustomers, id: \.self) { customer in
                CustomerRow(
                    customer: self.customerDataSource.readObject(customer),
                    onDeleted: { self.viewReloader.forceReload() }
                )
            }
        }
        .onAppear(perform: setupView)
        .navigationBarItems(trailing: createNewCustomerNavItem)
        .sheet(isPresented: $showCreateCustomerForm, onDismiss: dismissCreateNewCustomerForm, content: { self.createCustomerForm })
        .alert(isPresented: $showCreateCustomerFailedAlert, content: { .createObjectWithoutCurrentStore(object: "Customer") })
    }
}


// MARK: - Nav Item

extension CustomerListView {
    
    var createNewCustomerNavItem: some View {
        Button(action: beginCreateNewCustomer) {
            Image(systemName: "plus").imageScale(.large)
        }
    }
}


// MARK: - Create Customer Form

extension CustomerListView {
    
    /// A form for creating new customer.
    var createCustomerForm: some View {
        NavigationView {
            CustomerForm(
                model: $newCustomerModel,
                onCreate: saveNewCustomer,
                onCancel: dismissCreateNewCustomerForm,
                enableCreate: newCustomerModel.customer!.isValid()
            )
                .navigationBarTitle("New Customer", displayMode: .inline)
        }
    }
    
    func dismissCreateNewCustomerForm() {
        customerDataSource.discardCreateContext()
        showCreateCustomerForm = false
    }
    
    func beginCreateNewCustomer() {
        if let store = Store.current(from: customerDataSource.createContext) {
            // discard and prepare a new object for the form
            customerDataSource.discardNewObject()
            customerDataSource.prepareNewObject()
            customerDataSource.newObject!.store = store
            newCustomerModel = .init(customer: customerDataSource.newObject!)
            showCreateCustomerForm = true
        } else {
            showCreateCustomerFailedAlert = true
        }
    }
    
    func saveNewCustomer() {
        let result = customerDataSource.saveNewObject()
        switch result {
        case .saved: showCreateCustomerForm = false
        case .failed: break // TODO: add alert
        case .unchanged: break
        }
    }
}


// MARK: - Method

extension CustomerListView {
    
    func setupView() {
        fetchCustomers()
    }
    
    func fetchCustomers(searchText: String = "") {
        if let storeID = AppCache.currentStoreUniqueID {
            let request = Customer.requestObjects(storeID: storeID, withInfo: searchText)
            customerDataSource.performFetch(request)
        } else {
            customerDataSource.performFetch(Customer.requestNoObject())
        }
        viewReloader.forceReload()
    }
    
    func setupSearchField() {
        searchField.placeholder = "Search name, phone, email, etc..."
        searchField.onSearchTextDebounced = fetchCustomers
    }
}


struct CustomerList_Previews : PreviewProvider {
    static var previews: some View {
        CustomerListView()
    }
}
