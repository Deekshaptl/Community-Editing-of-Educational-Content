// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CommunityEditing {
    struct Content {
        uint id;
        string title;
        string contentHash; // IPFS hash for content storage
        address contributor;
        uint upvotes;
        uint timestamp;
    }

    mapping(uint => Content) public contents;
    uint public contentCount;

    mapping(address => uint) public contributorRewards;

    event ContentAdded(uint indexed id, string title, address indexed contributor, uint timestamp);
    event ContentEdited(uint indexed id, string newContentHash, address indexed editor, uint timestamp);
    event ContentUpvoted(uint indexed id, address indexed voter, uint timestamp);

    function addContent(string memory _title, string memory _contentHash) public {
        contentCount++;
        contents[contentCount] = Content(contentCount, _title, _contentHash, msg.sender, 0, block.timestamp);
        contributorRewards[msg.sender] += 10; // Reward for adding content

        emit ContentAdded(contentCount, _title, msg.sender, block.timestamp);
    }

    function editContent(uint _id, string memory _newContentHash) public {
        require(_id > 0 && _id <= contentCount, "Invalid content ID");
        require(contents[_id].contributor == msg.sender, "Only the original contributor can edit this content");

        contents[_id].contentHash = _newContentHash;
        emit ContentEdited(_id, _newContentHash, msg.sender, block.timestamp);
    }

    function upvoteContent(uint _id) public {
        require(_id > 0 && _id <= contentCount, "Invalid content ID");

        contents[_id].upvotes++;
        contributorRewards[contents[_id].contributor] += 5; // Reward for upvotes
        emit ContentUpvoted(_id, msg.sender, block.timestamp);
    }

    function getContributorRewards(address _contributor) public view returns (uint) {
        return contributorRewards[_contributor];
    }
}
