// SPDX-License-Identifier: UNLICESNED

pragma solidity >=0.8.0;

// we will import external libraries/ contracts required 

//Ready-Made Structure of ERC721
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// importing libraries
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

//our contract is twitter dapp which inherits from ERC721,
// it is defined as TwitterDpp and symbol as TDAPP
contract TwitterDapp is ERC721("TwitterDApp","TDAPP"){
    uint256 tokenId;//global integer to assign unioque id to tweet
    tweet[] public tweets;// here we declared dynamic length array of type tweet
    //whenever a tweet is minted or its metadata is updated we will refrene the tweet in
    //our array and update the respective details. tokenid counter starts from 0:
    // passing in the tokenid as an index to our array will help to locate the tweet
    struct tweet{
        //way to store the metadata of the tweets 
        string name;
        string description;
        uint256 upvotes;
        string[] comments;
        address fromAddress;
        // we created this struct(represents a record)
    }
    /*
    Now we will write our functions that define the functionality of our contact
    functions== all the actions user is permitted to take
    at the core, tokenURL taked arg. as uint256(eg tokenid)
    next in refrence to opensea standards we need to output name, desc. etc
    we utilize the strings library to format our output as per JSON standards and 
    base64 to resolve it to JSON

    */
    function tokenURI(uint256 _tokenId) public view override returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name":', '"',tweets[_tokenId].name,'",' '"description":' , '"', tweets[_tokenId].description,'"', ',' ,
                '"attributes":', '[', '{', '"trait_type":', '"Upvotes",' , '"value":', Strings.toString(tweets[_tokenId].upvotes), '}',']','}'
        );

        return string (
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }
    /*
    now its time for the tweet function writeTWeet by this users will be albe to 
    mint new tweets we take name and description as arguments
    we use _safeMint by ERC721 for minting purposes
    initialize tweet struct with empt vals and push to our array
    also we set fromAddress of the tweeter using msg.sender
    global tokenId is then incremented for keeping unique token ids
    */
   function writeTweet(string memory prefName, string memory prefDesc) public{
        _safeMint(msg.sender, tokenId);
        tweets.push(tweet({
            name: prefName,
            description: prefDesc,
            upvotes: 0,
            comments: new string [](0),
            fromAddress: msg.sender
        }));
        tokenId = tokenId +1;
    }
    /*
    Now we add the comment function 
    we take tokenid as index of tweets and the comment they want to add and
    push it to comments array or res. tweet
    */
    function addComment(uint256 tweetIndex,string memory perfComments) public {
        tweets[tweetIndex].comments.push(perfComments);
    }

    /*
    upvote function same as add commment
    */
    function upvote(uint256 tweetIndex)public{
        tweets[tweetIndex].upvotes += 1;
    }
    //getall tweets function
    function getallTweets() public view returns (tweet[] memory){
        return tweets;
    }


}