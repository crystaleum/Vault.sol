//SPDX-License-Identifier: MIT

/**
 * ██╗███╗   ██╗████████╗███████╗██████╗  ██████╗██╗  ██╗ █████╗ ██╗███╗   ██╗███████╗██████╗ 
 * ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗██╔════╝██║  ██║██╔══██╗██║████╗  ██║██╔════╝██╔══██╗
 * ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝██║     ███████║███████║██║██╔██╗ ██║█████╗  ██║  ██║
 * ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗██║     ██╔══██║██╔══██║██║██║╚██╗██║██╔══╝  ██║  ██║
 * ██║██║ ╚████║   ██║   ███████╗██║  ██║╚██████╗██║  ██║██║  ██║██║██║ ╚████║███████╗██████╔╝
 * ╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝ 
 */

pragma solidity ^0.8.4;

interface IERC20 {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external view returns (string memory);
    function symbol() external view returns (string memory);
    function decimals() external view returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function transfer(address payable to, uint value) external returns (bool);
    function transferFrom(address payable from, address payable to, uint value) external returns (bool);
}

library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

abstract contract Auth {
    using Address for address;
    address payable public owner;
    mapping (address => bool) internal authorizations;

    constructor(address payable _maintainer, address payable _community, address payable _marketing, address payable _development) {
        owner = payable(_maintainer);
        authorizations[_community] = true;
        authorizations[_marketing] = true;
        authorizations[_development] = true;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyOwner() virtual {
        require(isOwner(msg.sender), "!OWNER"); _;
    }

    /**
     * Function modifier to require caller to be contract owner
     */
    modifier onlyZero() virtual {
        require(isOwner(address(0)), "!ZERO"); _;
    }

    /**
     * Function modifier to require caller to be authorized
     */
    modifier authorized() virtual {
        require(isAuthorized(msg.sender), "!AUTHORIZED"); _;
    }

    /**
     * Authorize address. Owner only
     */
    function authorize(address adr) public onlyOwner {
        authorizations[adr] = true;
    }

    /**
     * Remove address' authorization. Owner only
     */
    function unauthorize(address adr) public onlyOwner {
        authorizations[adr] = false;
    }

    /**
     * Check if address is owner
     */
    function isOwner(address account) public view returns (bool) {
        if(account == owner){
            return true;
        } else {
            return false;
        }
    }

    /**
     * Return address' authorization status
     */
    function isAuthorized(address adr) public view returns (bool) {
        return authorizations[adr];
    }
}

contract donationVault is Auth {
    using Address for address;
    string public name     = unicode"💸VAULT🔒";
    string public symbol   = unicode"🔑";

    uint public devDonationMultiplier = 2000; // 20%
    uint public communityDonationMultiplier = 5000; // 50%
    uint public immutable shareBasisDivisor = 10000; 
    uint8 public key = 1; // keyholders get 1 key each

    address payable public _development = payable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4);
    address payable public _marketing = payable(0x74b9006390BfA657caB68a04501919B72E27f49A);
    address payable public _community = payable(0xdF01E4213A38B463F4f04e9D3Ec3E28cA90b81Be);
    address payable public _maintainer = payable(0xD87243a8629905813c28fB82136f99d6Ab29E46e);

    event Withdrawal(address indexed src, uint wad);
    event WithdrawToken(address indexed src, address indexed token, uint wad);

    mapping (address => uint)                       public  balanceOf;
    mapping (address => mapping (address => uint))  public  allowance;
    constructor() Auth(_community, _development, _marketing, _maintainer) {
        balanceOf[_community] += key;
        balanceOf[_development] += key;
        balanceOf[_marketing] += key;
        balanceOf[_maintainer] += key;
    }

    receive() external payable {}
    
    function setMarketing(address _marketingWallet) public onlyOwner returns(bool) {
        require(_maintainer == msg.sender);
        _marketing = payable(_marketingWallet);
        return true;
    }

    function setCommunity(address _communityWallet) public onlyOwner returns(bool) {
        require(_maintainer == msg.sender);
        _community = payable(_communityWallet);
        return true;
    }

    function checkKeys() public view returns(bool) {
        assert(balanceOf[msg.sender] == 1);
        return true;
    }

    function split(uint liquidity) public view returns(uint,uint,uint,uint){
        uint communityLiquidity = (liquidity * communityDonationMultiplier) / shareBasisDivisor;
        uint developmentLiquidity = ((liquidity - communityLiquidity) * devDonationMultiplier) / shareBasisDivisor;
        uint marketingLiquidity = (liquidity - (developmentLiquidity+communityLiquidity));
        uint totalSumOfLiquidity = communityLiquidity+developmentLiquidity+marketingLiquidity;
        assert(totalSumOfLiquidity==liquidity);
        require(totalSumOfLiquidity==liquidity,"ERROR");
        return (totalSumOfLiquidity,communityLiquidity,developmentLiquidity,marketingLiquidity);
    }

    function withdraw() public returns(bool) {
        require(checkKeys(),"Unauthorized!");
        if(uint256(balanceOf[msg.sender]) != uint256(1)){
            revert("Unauthorized!");
        }
        uint ETH_liquidity = address(this).balance;
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq, uint mliq) = split(ETH_liquidity);
        assert(sumOfLiquidityWithdrawn==ETH_liquidity);
        if(uint(sumOfLiquidityWithdrawn)!=uint(ETH_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(ETH_liquidity),"ERROR");
        payable(_community).transfer(cliq);
        payable(_development).transfer(dliq);
        payable(_marketing).transfer(mliq);
        emit Withdrawal(address(this), sumOfLiquidityWithdrawn);
        return true;
    }

    function withdrawETH() public authorized() returns(bool) {
        require(checkKeys(),"Unauthorized!");
        if(uint(balanceOf[msg.sender]) != uint(1)){
            revert("Unauthorized!");
        }
        assert(isAuthorized(msg.sender));
        assert(uint(balanceOf[msg.sender]) == uint(1));
        uint ETH_liquidity = address(this).balance;
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq, uint mliq) = split(ETH_liquidity);
        if(uint(sumOfLiquidityWithdrawn)!=uint(ETH_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(ETH_liquidity),"ERROR");
        payable(_community).transfer(cliq);
        payable(_development).transfer(dliq);
        payable(_marketing).transfer(mliq);
        emit Withdrawal(address(this), sumOfLiquidityWithdrawn);
        return true;
    }

    function withdrawToken(address token) public authorized() returns(bool) {
        require(checkKeys(),"Unauthorized!");
        if(uint256(balanceOf[msg.sender]) != uint256(1)){
            revert("Unauthorized!");
        }
        assert(isAuthorized(msg.sender));
        assert(balanceOf[msg.sender] == key);
        uint Token_liquidity = IERC20(token).balanceOf(address(this));
        (uint sumOfLiquidityWithdrawn,uint cliq, uint dliq, uint mliq) = split(Token_liquidity);
        if(uint(sumOfLiquidityWithdrawn)!=uint(Token_liquidity)){
            revert("Mismatched split, try again");
        }
        require(uint(sumOfLiquidityWithdrawn)==uint(Token_liquidity),"ERROR");
        IERC20(token).transfer(payable(_community), cliq);
        IERC20(token).transfer(payable(_development), dliq);
        IERC20(token).transfer(payable(_marketing), mliq);
        emit WithdrawToken(address(this), address(token), sumOfLiquidityWithdrawn);
        return true;
    }

}