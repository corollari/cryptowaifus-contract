pragma solidity ^0.4.24;

import "./WaifuDistribution.sol";

contract SocialMediaWaifus is WaifuDistribution{

	modifier isWaifuOwner(_tokenId){
		address owner = ownerOf(_tokenId);
		require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
		_;
	}

	// Associates each tokenId with the social media profile it's linked to
	mapping(uint=>uint) _tokenToMedia; 

	/// @dev Generate a unique id associated to a social media profile
	/// @param _network Social media platform where the profile is located (eg: "facebook.com", "twitter.com"...)
	/// @param _profile Profile/user handle on the social media platform (eg: "@corollari", "@messi"...)
	function _getSocialProfileId(string _network, string _profile) private view returns (uint){
		return keccak256(_network, _profile);
	}

	/// @dev Return an array of tokenIds representing the waifus linked to a social media profile
	/// @param _network Used for _getSocialProfileId
	/// @param _profile Used for _getSocialProfileId
	function getWaifusInProfile(string _network, string _profile) external view returns (uint[]){
		uint profileId=_getSocialProfileId(_network, _profile);
		uint length=0;
		for(uint i=0; i<_ownedWaifus; i++){
			if(_tokenToMedia[i]==profileId){
				length++;
			}
		}
		uint[] waifus=new uint[](length);
		for(uint i=0; i<_ownedWaifus; i++){
			if(_tokenToMedia[i]==profileId){
				waifus.push(i);
			}
		}
		return waifus;
	}

	function setWaifuProfile(uint _tokenId, string _network, string _profile) external isWaifuOwner(_tokenId){
		_tokenToMedia[_tokenId]=_getSocialProfileId(_network, _profile);
	}
}