pragma solidity ^0.4.17;

contract AnalysisLogin{// deploys the Campaign contract
    address[] public clients;
    
    function makeAnalysis() public{
        address newAnalysis = new Analysis(msg.sender);
        clients.push(newAnalysis);
    }
    
    function getClients() public view returns (address[]){
        return clients;
    }
}

contract Analysis{
    struct Selection{
        uint number;
        string actionmade;
        uint value;
    }
    
    struct Action{
        string namedata;
        string action; //It depends of the Selection struct
        uint valueaction; //It depends of the Selection struct
        address bank; //Account
        bool made;
        string hashimage;
    }
    
    mapping(uint => Selection) public sactions;
    Action[] public actions; //Dynamic array
    address public controller; //Creator
    uint public actionsCount; //To make the id of the action

    modifier restricted(){
        require(msg.sender==controller);
        _;
    }
    
    function Analysis(address creator) public{ //Get into the contract
        controller = creator;
        addActions("Clasificacion",7);
        addActions("Estadistica Descriptiva",5);
        addActions("Regresion lineal",8);
        addActions("Regresion multilineal",10);
    }
    
    function addActions(string memory _name, uint _payment) private {
        actionsCount++; //This will be the id of the action
        sactions[actionsCount].number = actionsCount; 
        sactions[actionsCount].actionmade = _name; 
        sactions[actionsCount].value = _payment; 
        //Assigning value to the Action structure
    }
    
    function selectAction(string namedata, uint actionId, address bank) public restricted {
       require(actionId<=actionsCount);
        Action memory newAction = Action({
            namedata: namedata,
            action: sactions[actionId].actionmade,
            valueaction: sactions[actionId].value,//amount
            bank: bank, //account
            made: false,
            hashimage: "empty"
        });
        actions.push(newAction);
    }
    
    function makeAction(uint index) public payable {
        Action storage action = actions[index];
        require(!action.made);
        require(msg.value == action.valueaction);
        action.bank.transfer(action.valueaction);
        action.made = true;
        action.hashimage = "hashimage";
    }

    function getSummary() public view returns (
        uint, address
        ) {
        return (
            actions.length, //Pending requests
            controller //address
        );
    }

    function getAnalysisCount() public view returns (uint) {
        return actions.length;
    }
}