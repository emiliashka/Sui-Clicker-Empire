export function EnergyPanel({
  energy,
  unclaimed,
}: {
  energy: number;
  unclaimed: number;
}) {
  return (
    <div>
      <div>⚡ Energy: {energy}</div>
      <div>💰 Unclaimed: {unclaimed}</div>
    </div>
  );
}
