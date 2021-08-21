pragma solidity ^ 0.8.0;

contract LibraryManagementSystem{
    // Declaring mapping to store Struct of Books
    mapping(uint8 => Books) books;
    // storing address of contract Owner
    address contractOwner;
    // Array for storing address of books
    address[] listOfBooks;
    // Declaring new Modifier to restrict access
    modifier onlyAdmins(){
        require(msg.sender == contractOwner);
        _;
    }
    // Initializing the owner of the Contract
    constructor() public{
        contractOwner = msg.sender;
    }
    // Book type Struct
    struct Books{
        uint8 bookID;
        string bookTitle;
        string genere;
        address bookOwner;
    }
    // Function for adding new Books which take some input parameter and store in the mappings.
    function addNewBook(uint8 _bookID, string memory _bookTitle,string memory _genere, address _bookOwner) public onlyAdmins{
        books[_bookID].bookID    = _bookID;        
        books[_bookID].bookTitle = _bookTitle;
        books[_bookID].genere    = _genere;
        books[_bookID].bookOwner = _bookOwner;
        listOfBooks.push(msg.sender);
    }
    // Searching book in mapping by book ID
    function getBookByID(uint8 _bookIDs) public view returns(uint8 _bookID, string memory _bookTitle,string memory _genere, address _bookOwner) {
        return(books[_bookIDs].bookID,books[_bookIDs].bookTitle,books[_bookIDs].genere,books[_bookIDs].bookOwner);
    }
    // Transferrign owner ship of the Book to new Owner by supplying the new owner address
    function TransferBook(uint8 _bookID,address _newOwner) public onlyAdmins{
        books[_bookID].bookOwner = _newOwner;
    }
    function countOfBooks() public view returns(uint256){
        return listOfBooks.length;
    }
}