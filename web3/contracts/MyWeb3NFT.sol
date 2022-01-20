pragma solidity 0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import {Base64} from "./libraries/Base64.sol";

contract MyWeb3NFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // I create three arrays, each with their own theme of random words.
    // Pick some random funny words, names of anime characters, foods you like, whatever!
    string[] randomCharacter = [
        "Abhimanyu",
        "Adhiratha",
        "Adrika",
        "Agni",
        "Alambusha",
        "Alayudha",
        "Amba",
        "Ambalika",
        "Ambika",
        "Ambavati",
        "Anjanaparvana",
        "Anuketu",
        "Arjuna",
        "Aruni",
        "Ashvins",
        "Ashwatthama",
        "Astika",
        "Avantini",
        "Ayu",
        "Ayodhaumya",
        "Agastya",
        "Aswasena",
        "Aswapati",
        "Akritavrana",
        "Babruvahana",
        "Bahlika",
        "Bakasura",
        "Balarama",
        "Banasena",
        "Bhagadatta",
        "Bhandasura",
        "Bhanu",
        "Bharadwaja",
        "Bharata",
        "Bhima",
        "Bhishma",
        "Bhrigu",
        "Bhurishravas",
        "Bhuri",
        "Budha",
        "Brihadbala",
        "Bhagiratha",
        "Chandra",
        "Chekitana",
        "Chitrangada",
        "Chitravahana",
        "Chola",
        "Damayanti",
        "Dantavakra",
        "Dashraj",
        "Devaki",
        "Devayani",
        "Devika",
        "Dhrishtadyumna",
        "Dhritrashtra",
        "Draupadi",
        "Drona",
        "Drupada",
        "Durmasena",
        "Duryodhana",
        "Dushala",
        "Dushasana",
        "Dushyanta",
        "Dwapara",
        "Druma",
        "Daityasena",
        "Devasena",
        "Durvasa",
        "Ekalavya",
        "Gandhari",
        "Ganesha",
        "Ganga",
        "Ghatotkacha",
        "Ghritachi",
        "Hanuman",
        "Hidimba",
        "Hidimbi",
        "Hridika",
        "Hiranyavarma",
        "Hotravahana",
        "Ila",
        "Indra",
        "Iravan",
        "Indrayumna",
        "Jambavati",
        "Janamejaya",
        "Janapadi",
        "Jarasandha",
        "Jaratkaru",
        "Jayadratha",
        "Kadru",
        "Kaalvakra",
        "Kalayavana",
        "Kacha",
        "Kamsa",
        "Kanika",
        "Karenumati",
        "Karna",
        "Kauravas",
        "Kauravya",
        "Kichaka",
        "Kirmira",
        "Kratha",
        "Kripa",
        "Kripi",
        "Krishna",
        "Kritavarma",
        "Kunti",
        "Kuru",
        "Kartikeya",
        "Kalki",
        "Kalmasapada",
        "Lakshmanaa",
        "Lopamudra",
        "Lomasa",
        "Madanjaya",
        "Madranjaya",
        "Madrasena",
        "Madri",
        "Malini",
        "Manasa",
        "Marisha",
        "Markandeya",
        "Meghavarna",
        "Menaka",
        "Muchukunda",
        "Mandapala",
        "Mandhata",
        "Nala",
        "Nahusha",
        "Nakula",
        "Nanda",
        "Narakasura",
        "Niramitra",
        "Padmavati",
        "Pandya",
        "Parashara",
        "Parashuram",
        "Parikshit",
        "Pandu",
        "Prabha",
        "Pradyumna",
        "Pratipa",
        "Prativindhya",
        "Prishati",
        "Purochana",
        "Pururavas",
        "Puru",
        "Paurava",
        "Radha",
        "Revati",
        "Rukmi",
        "Rukmini",
        "Ruru",
        "Rochamana",
        "Rantideva",
        "Rama",
        "Sahadeva",
        "Sakradeva",
        "Samba",
        "Shamika",
        "Samvarana",
        "Sanjaya",
        "Sarama",
        "Satrajit",
        "Satyabhama",
        "Satyajit",
        "Satyaki",
        "Satyavati",
        "Shakuni",
        "Shakuntala",
        "Shalva",
        "Shalya",
        "Shankha",
        "Shantanu",
        "Sharmishtha",
        "Shashwathi",
        "Shatanika",
        "Shaunaka",
        "Shikhandi",
        "Shishupala",
        "Shrutkarma",
        "Shrutsena",
        "Shala",
        "Shukracharya",
        "Shveta",
        "Subala",
        "Subhadra",
        "Sudakshina",
        "Sudeshna",
        "Surya",
        "Sutsoma",
        "Svaha",
        "Somadatta",
        "Shini",
        "Shvetaki",
        "Shibi",
        "Somaka",
        "Sahasrapata",
        "Takshaka",
        "Tapati",
        "Tilottama",
        "Tara",
        "Usha",
        "Ugrasena",
        "Uluka",
        "Ulupi",
        "Urvashi",
        "Uttamaujas",
        "Uttanka",
        "Uttara",
        "Vajra",
        "Vajranabh",
        "Valandhara",
        "Vapusthama",
        "Vasudeva",
        "Vasundhara",
        "Vayu",
        "Vichitravirya",
        "Vidura",
        "Viduratha",
        "Vijaya",
        "Vikarna",
        "Vinata",
        "Viraja",
        "Virata",
        "Vishoka",
        "Vrihanta",
        "Vridhakshtra",
        "Vrishaketu",
        "Vrishasena",
        "Vyasa",
        "Yamuna",
        "Yashoda",
        "Yaudheya",
        "Yayati",
        "Yogmaya",
        "Yudhisthira",
        "Yuyutsu"
    ];

    // Get fancy with it! Declare a bunch of colors.
    string[] colors = ["red", "#08C2A8", "black", "yellow", "blue", "green"];

    // We split the SVG at the part where it asks for the background color.
    string svgPartOne =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svgPartTwo =
        "'/><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    event NewWeb3NFTMinted(address sender, uint256 tokenId);

    constructor() ERC721("Web3NFT", "WEB3") {}

    function pickRandomsWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        rand = rand % randomCharacter.length;
        return randomCharacter[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // Same old stuff, pick a random color.
    function pickRandomColor(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("COLOR", Strings.toString(tokenId)))
        );
        rand = rand % colors.length;
        return colors[rand];
    }

    function makeAWeb3NFT(address userAddress) public {
        uint256 newItemId = _tokenIds.current();

        string memory randomWord = pickRandomsWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(randomWord));

        // Add the random color in.
        string memory randomColor = pickRandomColor(newItemId);
        string memory finalSvg = string(
            abi.encodePacked(
                svgPartOne,
                randomColor,
                svgPartTwo,
                combinedWord,
                "</text></svg>"
            )
        );

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "Characters of greatest EPIC of All Time, Mahabharat!.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(userAddress, newItemId);

        // Update your URI!!!
        _setTokenURI(newItemId, finalTokenUri);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            userAddress
        );

        emit NewWeb3NFTMinted(userAddress, newItemId);
    }
}
