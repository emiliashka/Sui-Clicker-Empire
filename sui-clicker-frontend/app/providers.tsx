'use client';

import { WalletProvider } from '@mysten/wallet-adapter-react';
import { SuiWalletAdapter } from '@mysten/wallet-adapter-wallets';

export function Providers({ children }: { children: React.ReactNode }) {
  return (
    <WalletProvider wallets={[new SuiWalletAdapter()]} autoConnect>
      {children}
    </WalletProvider>
  );
}
