module clicker_contracts::game {

    use sui::event;

    /// === ERRORS ===
    const E_NO_REWARDS: u64 = 1;
    const E_VAULT_EMPTY: u64 = 2;

    /// =====================
    /// STRUCTS
    /// =====================

    /// Player object (owned)
    public struct Player has key {
        id: UID,
        owner: address,
        energy: u64,
        unclaimed: u64,
        multiplier: u64,
    }

    /// Global reward vault (shared)
    public struct RewardVault has key {
        id: UID,
        total_rewards: u64,
    }

    /// Admin capability
    public struct AdminCap has key {
        id: UID,
    }

    /// Event emitted on click
    public struct ClickEvent has copy, drop {
        player: address,
        amount: u64,
    }

    /// Event emitted on claim
    public struct ClaimEvent has copy, drop {
        player: address,
        amount: u64,
    }

    /// =====================
    /// INIT (called on publish)
    /// =====================
    fun init(ctx: &mut TxContext) {
        let vault = RewardVault {
            id: object::new(ctx),
            total_rewards: 1_000_000,
        };

        let admin = AdminCap {
            id: object::new(ctx),
        };

        transfer::share_object(vault);
        transfer::transfer(admin, tx_context::sender(ctx));
    }

    /// =====================
    /// ENTRY FUNCTIONS
    /// =====================

    /// Register a new player
    entry fun register_player(ctx: &mut TxContext) {
        let sender = tx_context::sender(ctx);

        let player = Player {
            id: object::new(ctx),
            owner: sender,
            energy: 0,
            unclaimed: 0,
            multiplier: 1,
        };

        transfer::transfer(player, sender);
    }

    /// Batched click action
    entry fun tap_click(
        player: &mut Player,
        click_count: u64,
    ) {
        let gained = click_count * player.multiplier;

        player.energy = player.energy + gained;
        player.unclaimed = player.unclaimed + gained;

        event::emit(ClickEvent {
            player: player.owner,
            amount: gained,
        });
    }

    /// Claim rewards
    entry fun claim_rewards(
        player: &mut Player,
        vault: &mut RewardVault,
    ) {
        let amount = player.unclaimed;
        assert!(amount > 0, E_NO_REWARDS);
        assert!(vault.total_rewards >= amount, E_VAULT_EMPTY);

        vault.total_rewards = vault.total_rewards - amount;
        player.unclaimed = 0;

        event::emit(ClaimEvent {
            player: player.owner,
            amount,
        });
    }

    /// Apply an upgrade to a player (called by upgrades module)
    public fun apply_upgrade(
        player: &mut Player,
        cost: u64,
        multiplier_boost: u64,
    ) {
        assert!(player.energy >= cost, 100);

        player.energy = player.energy - cost;
        player.multiplier = player.multiplier + multiplier_boost;
    }

    /// Read-only: get player owner
    public fun player_owner(player: &Player): address {
        player.owner
    }

    /// Read-only: get player multiplier
    public fun player_multiplier(player: &Player): u64 {
        player.multiplier
    }

}
