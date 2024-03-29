// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <=0.8.17;
import "./Token_test.sol";
import "./notification.sol";
import "./workers.sol"; 
import "./marketplace.sol";


contract Kontrakt is marketplace, Notifications, AccountTypes {

    address tokenAddress = address(this);       

    // wyjasnienie -> tutaj sa tylko funkcje ktore uzywaja adresu kontraktu
    //akceptacja ticketa 
    // moneyAddres -> adres zdeployowanego Token_test
    function approveTicket ( uint256 _id , string calldata _Explenation, address moneyAddres ) payable external {
        require( _id >= 0, "Negative id");
        require(Table.length > 0, "Empty stack");
        require( _id < Table.length, "Index out of range");
        require( Table[_id].Status == statuses.SEND, "Ticket is closed");
        Table[_id].Status = statuses.APPROVED;
        Table[_id].StatusExplanation = _Explenation;
        ERC20 token = ERC20(moneyAddres);
        token.transfer( payable(Table[_id].ReciverWallet), Table[_id].TokenAmount);
    }

    // kupno przedmiotu 
    function buyItem ( uint256 item_id , address _buyer) payable external  {
        require( item_id >= 0  , "Negative ID");
        require( Items.length > 0, "Empty stack");
        require( item_id < Items.length,"Product out of the list");
        require( Items[item_id].status == item_status.SELLING, "Product is not for sale" );
        AddToHistory(item_id ,_buyer);

        // ERC20 token = ERC20(moneyAddres);
        // token.transferFrom(payable (_buyer), payable(moneyAddres), Items[item_id].price);
    }

}
