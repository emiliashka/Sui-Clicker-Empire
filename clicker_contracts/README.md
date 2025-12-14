# Sui Clicker Empire

MVP on-chain clicker game built with **Sui Move**.

Players register, click to generate energy, buy upgrades, and claim rewards — all secured and verifiable on-chain.

---

## Repository Structure

clicker_contracts/
├── Move.toml
├── Move.lock
├── sources/
│ ├── game.move # Core game logic (Player, clicks, rewards)
│ ├── upgrades.move # Upgrade logic (multipliers)
│ └── events.move # On-chain events for indexing
└── tests/
└── clicker_contracts_tests.move


---

## 🧠 Core Concepts

### Player
- Owned object
- Tracks:
  - energy
  - unclaimed rewards
  - click multiplier

### Reward Vault
- Shared object
- Holds total available rewards
- Used when claiming rewards

### Upgrades
- Increase player multiplier
- Bought using player energy
- Applied on-chain

---

## 🧩 Modules

### `game.move`
Handles:
- Player registration
- Click batching
- Reward claiming
- Core invariants

Main entry functions:
- `register_player`
- `tap_click`
- `claim_rewards`

---

### `upgrades.move`
Handles:
- Buying upgrades
- Applying multiplier boosts to players

### `events.move`
Emits on-chain events:
- ClickEvent
- ClaimEvent
- UpgradeEvent

Used for:
- Backend indexing
- Leaderboards
- Analytics


