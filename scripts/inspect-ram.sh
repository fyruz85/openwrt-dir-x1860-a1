#!/usr/bin/env bash
set -euo pipefail
image="${1:?FIT image required}"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
# Read the actual FIT configuration, not a source DTS.
conf="$(fdtget -t s "$image" /configurations default)"
node="$(fdtget -t s "$image" "/configurations/$conf" fdt)"
fdtget -t bx "$image" "/images/$node" data | python3 -c 'import sys; sys.stdout.buffer.write(bytes(int(x,16) for x in sys.stdin.read().split()))' > "$tmp/board.dtb"
dt="$tmp/board.dtb"
fdtget -t s "$dt" / compatible | grep -qw 'dlink,dir-x1860-a1'
# Resolve paths from the compiled tree rather than relying on source labels.
walk() {
  local parent="$1" child path
  while IFS= read -r child; do
    [[ -n "$child" ]] || continue
    path="${parent%/}/$child"
    printf '%s\n' "$path"
    walk "$path"
  done < <(fdtget -l "$dt" "$parent")
}
walk / > "$tmp/nodes"
for pattern in '/nand@' '/pcie@'; do
  mapfile -t nodes < <(grep -E "${pattern}[^/]+$" "$tmp/nodes")
  test "${#nodes[@]}" -ge 1
  # Only controller nodes; PCIe child ports also match, so check top-level controller.
  if [[ "$pattern" == '/pcie@' ]]; then
    mapfile -t nodes < <(printf '%s\n' "${nodes[@]}" | grep -vE '/pcie@[^/]+/pcie@')
  fi
  for path in "${nodes[@]}"; do
    test "$(fdtget -t s "$dt" "$path" status)" = disabled
    echo "Verified disabled: $path"
  done
done
echo 'Embedded A1 DTB safety checks passed; not hardware validated.'
