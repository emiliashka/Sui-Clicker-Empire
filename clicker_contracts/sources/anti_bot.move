module clicker::anti_bot {

    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};
    use sui::error;

    const E_TOO_MANY_CLICKS: u64 = 0;
    const E_RATE_LIMIT: u64 = 1;

    struct RateTracker has key {
        id: UID,
        last_tx: u64,
        calls_in_window: u64,
    }

    public fun new(ctx: &mut TxContext): RateTracker {
        RateTracker {
            id: object::new(ctx),
            last_tx: tx_context::epoch(ctx),
            calls_in_window: 0,
        }
    }

    public fun check_and_update(
        tracker: &mut RateTracker,
        click_count: u64,
        ctx: &TxContext
    ) {
        if (click_count > 500) {
            abort E_TOO_MANY_CLICKS;
        }

        let current_epoch = tx_context::epoch(ctx);

        if (tracker.last_tx == current_epoch) {
            tracker.calls_in_window = tracker.calls_in_window + 1;
        } else {
            tracker.last_tx = current_epoch;
            tracker.calls_in_window = 1;
        }

        if (tracker.calls_in_window > 5) {
            abort E_RATE_LIMIT;
        }
    }
}
