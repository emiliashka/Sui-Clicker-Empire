'use client';

import { useWallet } from '@mysten/wallet-adapter-react';
import { ClickButton } from '@/components/ClickButton';
import { EnergyPanel } from '@/components/EnergyPanel';
import { ClaimButton } from '@/components/ClaimButton';
import { useClickBatch } from '@/hooks/useClickBatch';
import { usePlayer } from '@/hooks/usePlayer';
import { buildTapClickTx, buildClaimTx } from '@/lib/transactions';

export default function Home() {
  const wallet = useWallet();
  const playerId = '0xPLAYER_OBJECT_ID';

  const player = usePlayer(playerId);
  const clickBatch = useClickBatch();

  async function syncClicks() {
    const clicks = clickBatch.flushClicks();
    if (!clicks) return;

    const tx = buildTapClickTx(playerId, clicks);
    await wallet.signAndExecuteTransactionBlock({ transactionBlock: tx });
  }

  async function claim() {
    const tx = buildClaimTx(playerId);
    await wallet.signAndExecuteTransactionBlock({ transactionBlock: tx });
  }

  return (
    <main>
      <h1>⚡ Sui Clicker</h1>

      {player && (
        <EnergyPanel
          energy={Number(player.energy)}
          unclaimed={Number(player.unclaimed)}
        />
      )}

      <ClickButton onClick={clickBatch.registerClick} />

      <button onClick={syncClicks}>
        Sync ({clickBatch.pendingClicks})
      </button>

      <ClaimButton
        onClaim={claim}
        disabled={!player || player.unclaimed === '0'}
      />
    </main>
  );
}
