pragma solidity ^0.8.19;

contract InventoryManagement {
    
    struct Product {
        uint productId;
        string productName;
        string brandName;
        uint quantity;
        uint manufacturingDate;
        uint expiryDate;
        address manufacturer;
        mapping(address => RetailerProduct) retailerProducts; // mapping to store RetailerProduct for each retailer
    }
    
    struct RetailerProduct {
        address retailer;
        uint quantity;
    }
    mapping(uint => Product) public products;
    uint public productsCount;
    
    function manufactureProduct(uint _productId, string memory _productName, string memory _brandName, uint _quantity, uint _manufacturingDate, uint _expiryDate) public {
        require(products[_productId].productId == 0, "Product already exists");
        require(_expiryDate > _manufacturingDate, "Expiry date must be after manufacturing date");
        
        Product storage p = products[_productId];
        p.productId = _productId;
        p.productName = _productName;
        p.brandName = _brandName;
        p.quantity = _quantity;
        p.manufacturingDate = _manufacturingDate;
        p.expiryDate = _expiryDate;
        p.manufacturer = msg.sender;
        
        productsCount++;
    }
    
    
   
      function getProduct(uint _productId) public view returns (string memory, string memory, uint, uint, uint) {
        require(products[_productId].productId != 0, "Product does not exist");
        Product storage p = products[_productId];
        return (p.productName, p.brandName, p.quantity, p.manufacturingDate, p.expiryDate);
}
    
    
    function getTotalProductQuantity(uint _productId) public view returns (uint) {
        require(products[_productId].productId != 0, "Product does not exist");
        return products[_productId].quantity;
    }
    
    function deliverProduct(uint _productId, address _retailer, uint _quantity) public {
        require(products[_productId].productId != 0, "Product does not exist");
        require(_retailer != address(0), "Retailer address is invalid");
        require(_quantity > 0 && _quantity <= products[_productId].quantity, "Invalid quantity");
        
        Product storage p = products[_productId];
        p.quantity -= _quantity;
        
        RetailerProduct storage rp = p.retailerProducts[_retailer];
        rp.retailer = _retailer;
        rp.quantity += _quantity;
    }
    
   

  function getRetailerProductDetails(uint _productId, address _retailer) public view returns (string memory, string memory, uint, uint, uint) {
        require(products[_productId].productId != 0, "Product does not exist");
        require(_retailer != address(0), "Retailer address is invalid");
        
        Product storage p = products[_productId];
        
        RetailerProduct memory rp = p.retailerProducts[_retailer];
        require(rp.quantity > 0, "Retailer has not received this product");
        
        return (p.productName, p.brandName, p.manufacturingDate, p.expiryDate, rp.quantity);
}
function updateProduct(uint _productId, string memory _productName, string memory _brandName, uint _quantity, uint _manufacturingDate, uint _expiryDate) public {
    require(products[_productId].productId != 0, "Product does not exist");
    require(msg.sender == products[_productId].manufacturer, "Only manufacturer can update the product details");
    require(_expiryDate > _manufacturingDate, "Expiry date must be after manufacturing date");
    
    Product storage p = products[_productId];
    p.productName = _productName;
    p.brandName = _brandName;
    p.quantity = _quantity;
    p.manufacturingDate = _manufacturingDate;
    p.expiryDate = _expiryDate;
}



function updateRetailerProduct(uint _productId, address _retailer, uint _newQuantity) public {
        require(products[_productId].productId != 0, "Product does not exist");
        require(_retailer != address(0), "Retailer address is invalid");
        require(_newQuantity > 0, "Quantity must be greater than zero");

        Product storage p = products[_productId];
        RetailerProduct storage rp = p.retailerProducts[_retailer];

        require(rp.quantity > 0, "Retailer has not received this product");

        rp.quantity = _newQuantity;
    }

function updateRetailerAddress(uint _productId, address _oldRetailer, address _newRetailer) public {
        require(products[_productId].productId != 0, "Product does not exist");
        require(_oldRetailer != address(0) && _newRetailer != address(0), "Retailer addresses are invalid");

        Product storage p = products[_productId];
        RetailerProduct storage rp = p.retailerProducts[_oldRetailer];

        require(rp.quantity > 0, "Retailer has not received this product");
        require(rp.retailer == _oldRetailer, "Current retailer address is incorrect");

        rp.quantity = 0;
        p.retailerProducts[_newRetailer] = RetailerProduct(_newRetailer, 0);
        p.retailerProducts[_newRetailer].quantity += rp.quantity;
    }

  





 

}
