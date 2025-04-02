// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
contract FundMeTest is Test{
   FundMe fundMe;
   address USER = makeAddr("user");
   uint256 public constant SEND_VALUE = 0.1 ether;
   uint256 STARTING_BALANCE = 10 ether;

    function setUp() external {
        //    fundMe = new FundMe();
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal (USER, STARTING_BALANCE);
    }

    function testMinimumDollarIsFive() public view{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
 
    function testOwnerIsMsgSender() public view{
        assertEq(fundMe.getOwner(), msg.sender);
    }
    
     function testPriceFeedVersionIsAccurate() public view{
         assertEq(fundMe.getVersion(), 4);  
     }

     function testFundFailsWithoutEnoughEth() public{
        vm.expectRevert();
        fundMe.fund();

     }

     function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded , SEND_VALUE);
     }
     modifier funded {
        vm.prank(USER);
        fundMe.fund{value:SEND_VALUE}();
        _;
     }
     function testAddsFunderToArrayOfFunders() public funded{
        
        address funder = fundMe.getFunder(0);
        assertEq(USER, funder);
     }
     function testOnlyOwnerCanWithdraw() public funded{

        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
     }
     function testingWithdrawWithASingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;  

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
     }
     function testingCheaperWithdrawWithASingleFunder() public funded{
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;  

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
     }

     function testWithdrawFromMultipleFunders() public funded {
      uint160 numberOfFunders = 10;
      for (uint160 i = 1; i < numberOfFunders; i++){
         hoax(address(i) , STARTING_BALANCE);
         fundMe.fund{value: SEND_VALUE}();
         }
         uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;  

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
     } 
     
     function testCheaperWithdrawFromMultipleFunders() public funded {
      uint160 numberOfFunders = 10;
      for (uint160 i = 1; i < numberOfFunders; i++){
         hoax(address(i) , STARTING_BALANCE);
         fundMe.fund{value: SEND_VALUE}();
         }
         uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;  

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
     }
} 