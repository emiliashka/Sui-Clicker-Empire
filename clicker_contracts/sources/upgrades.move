module clicker_contracts::upgrades {

    use sui::object;
    use sui::transfer;
    use sui::event;
    use sui::tx_context::TxContext;

    use clicker_contracts::game;

    /// Error codes
    const E_NOT_OWNER: u64 = 1;

    /// Upgrade NFT (owned)
    public struct Upgrade has key {
        id: object::UID,
        level: u64,
        multiplier_boost: u64,
        owner: address,
    }

    /// Event emitted when upgrade is bought
    public struct UpgradeEvent has copy, drop, store {
        player: address,
        level: u64,
        boost: u64,
        new_multiplier: u64,
    }

    /// Buy an upgrade
    public entry fun buy_upgrade(
        player: &mut game::Player,
        level: u64,
        cost: u64,
        multiplier_boost: u64,
        ctx: &mut TxContext
    ) {
        let sender = tx_context::sender(ctx);

        // ✅ ownership check via game API
        assert!(sender == game::player_owner(player), E_NOT_OWNER);

        // ✅ ALL state mutation happens in game
        game::apply_upgrade(player, cost, multiplier_boost);

        // mint upgrade NFT
        let upgrade = Upgrade {
            id: object::new(ctx),
            level,
            multiplier_boost,
            owner: sender,
        };

        transfer::transfer(upgrade, sender);

        // emit event
        event::emit(UpgradeEvent {
            player: sender,
            level,
            boost: multiplier_boost,
            new_multiplier: game::player_multiplier(player),
        });
    }
}
