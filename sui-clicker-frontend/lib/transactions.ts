import { TransactionBlock } from '@mysten/sui.js/transactions';
import { PACKAGE_ID, GAME_MODULE } from './constants';

export function buildTapClickTx(playerId: string, clicks: number) {
  const tx = new TransactionBlock();
  tx.moveCall({
    target: `${PACKAGE_ID}::${GAME_MODULE}::tap_click`,
    arguments: [tx.object(playerId), tx.pure.u64(clicks)],
  });
  return tx;
}

export function buildClaimTx(playerId: string) {
  const tx = new TransactionBlock();
  tx.moveCall({
    target: `${PACKAGE_ID}::${GAME_MODULE}::claim_rewards`,
    arguments: [tx.object(playerId)],
  });
  return tx;
}
