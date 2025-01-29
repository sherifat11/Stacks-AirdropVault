# Stacks Airdrop Vault Smart Contract

## Overview
This smart contract facilitates the distribution of fungible tokens via an airdrop mechanism on the Stacks blockchain. It allows the contract owner to define eligible recipients, set token distribution amounts, and reclaim unclaimed tokens after a set period. Additionally, the contract includes tiered airdrop distributions, pause/resume functionality, and an emergency withdrawal mechanism.

## Features
- **Eligibility Management**: Admin can add or remove eligible recipients.
- **Airdrop Claiming**: Eligible recipients can claim their allocated tokens.
- **Tiered Airdrop Distribution**: Higher tiers receive more tokens.
- **Emergency Withdrawal**: Admin can withdraw tokens after a time lock.
- **Pause/Resume Functionality**: Admin can pause or resume the airdrop.
- **Reclaiming Unclaimed Tokens**: Admin can burn unclaimed tokens after the reclaim period.
- **Event Logging**: Key contract actions are logged for transparency.

## Contract Constants
- **Contract Owner**: `CONTRACT-OWNER` (set to `tx-sender` upon deployment)
- **Error Codes**:
  - `u100`: Not contract owner
  - `u101`: Airdrop already claimed
  - `u102`: Recipient not eligible
  - `u103`: Insufficient token balance
  - `u104`: Airdrop not active
  - `u105`: Invalid amount
  - `u106`: Reclaim period not ended
  - `u107`: Invalid recipient
  - `u108`: Invalid period
  - `u109`: Airdrop already paused
  - `u110`: Airdrop not paused
  - `u111`: Emergency withdrawal not initiated
  - `u112`: Emergency withdrawal timelock not ended

## Data Variables
- `is-airdrop-active`: Boolean, tracks if airdrop is active.
- `is-paused`: Boolean, tracks if airdrop is paused.
- `emergency-timelock`: Block height for emergency withdrawal.
- `total-tokens-distributed`: Total tokens claimed.
- `airdrop-amount-per-recipient`: Tokens per recipient.
- `airdrop-start-block`: Block height when airdrop started.
- `reclaim-period-length`: Blocks after which unclaimed tokens are reclaimed.
- `next-event-id`: Counter for logged events.

## Data Maps
- `eligible-airdrop-recipients`: Maps recipient address to eligibility.
- `claimed-airdrop-amounts`: Maps recipient address to claimed amounts.
- `contract-events`: Stores contract events.
- `tier-multipliers`: Maps tier levels to multipliers.

## Functions
### **Admin Functions**
#### `initiate-emergency-withdrawal()`
Starts emergency withdrawal with a `TIMELOCK-DELAY` (144 blocks).

#### `add-eligible-recipient(principal)`
Adds a recipient to the eligibility list.

#### `remove-eligible-recipient(principal)`
Removes a recipient from the eligibility list.

#### `bulk-add-eligible-recipients(list 200 principal)`
Adds multiple recipients at once.

#### `update-airdrop-amount(uint)`
Updates the airdrop amount per recipient.

#### `update-reclaim-period(uint)`
Updates the reclaim period.

#### `pause-airdrop()`
Pauses the airdrop distribution.

#### `resume-airdrop()`
Resumes the airdrop distribution.

#### `set-tier-multiplier(uint tier-level, uint multiplier)`
Sets a multiplier for a specific tier level.

### **Airdrop Functions**
#### `claim-airdrop-tokens()`
Allows an eligible recipient to claim their allocated tokens.

#### `claim-tiered-airdrop(uint tier-level)`
Allows an eligible recipient to claim tokens based on their tier level.

### **Token Reclaim Functions**
#### `reclaim-unclaimed-tokens()`
Allows the contract owner to burn unclaimed tokens after the reclaim period ends.

### **Emergency Functions**
#### `execute-emergency-withdrawal(principal recipient)`
Transfers all remaining tokens to a recipient after the emergency withdrawal period ends.

### **Read-Only Functions**
#### `get-airdrop-active-status()`
Returns whether the airdrop is active.

#### `get-pause-status()`
Returns whether the airdrop is paused.

#### `get-tier-multiplier(uint tier-level)`
Returns the multiplier for a given tier level.

#### `get-emergency-timelock()`
Returns the current emergency timelock value.

#### `is-recipient-eligible(principal recipient-address)`
Checks if a recipient is eligible for the airdrop.

#### `has-recipient-claimed-airdrop(principal recipient-address)`
Checks if a recipient has already claimed their airdrop.

#### `get-recipient-claimed-amount(principal recipient-address)`
Returns the amount a recipient has claimed.

#### `get-total-tokens-distributed()`
Returns the total amount of tokens distributed.

#### `get-airdrop-amount-per-recipient()`
Returns the current airdrop amount per recipient.

#### `get-reclaim-period()`
Returns the reclaim period length.

#### `get-airdrop-start-block()`
Returns the block height at which the airdrop started.

#### `get-event(uint event-id)`
Returns details of a logged event.

## Contract Initialization
Upon deployment, the contract mints `1,000,000,000` tokens and assigns them to the contract owner.

## Usage Guide
1. **Admin Actions**
   - Set eligibility using `add-eligible-recipient()` or `bulk-add-eligible-recipients()`.
   - Define tier multipliers using `set-tier-multiplier()`.
   - Adjust distribution amounts with `update-airdrop-amount()`.
   - Pause and resume the airdrop if needed.
   - Initiate an emergency withdrawal if required.
2. **Recipient Actions**
   - Check eligibility using `is-recipient-eligible()`.
   - Claim tokens using `claim-airdrop-tokens()` or `claim-tiered-airdrop()`.
3. **Reclaim Process**
   - Admin burns unclaimed tokens after the reclaim period using `reclaim-unclaimed-tokens()`.
4. **Emergency Withdrawal**
   - Admin initiates withdrawal with `initiate-emergency-withdrawal()`.
   - After `TIMELOCK-DELAY`, funds can be withdrawn using `execute-emergency-withdrawal()`.

## Security Considerations
- Only the contract owner can modify airdrop parameters and execute privileged functions.
- Emergency withdrawal requires a time lock to prevent misuse.
- Reclaiming tokens prevents indefinite locking of unclaimed funds.
- Event logging ensures transparency and auditability.

## License
This smart contract is provided under the MIT License. Use it at your own risk.

