#!/usr/bin/env bash
# DNS Benchmark Script
# Tests response time for popular DNS servers using dig
# Usage: bash dns_benchmark.sh [domain] [queries_per_server]

DOMAIN="${1:-https://fruits.shaidmonu300.workers.dev/items}"
ROUNDS="${2:-100}"

DNS_SERVERS=(
  "8.8.8.8|Google Primary"
  "8.8.4.4|Google Secondary"
  "1.1.1.1|Cloudflare Primary"
  "1.0.0.1|Cloudflare Secondary"
  "9.9.9.9|Quad9"
  "103.123.225.10|Quad9 Primary"
  "103.94.136.106|Quad9 Secondary"
  "208.67.222.222|OpenDNS Primary"
  "208.67.220.220|OpenDNS Secondary"
  "76.76.2.0|Control D"
  "94.140.14.14|AdGuard Primary"
  "185.228.168.9|CleanBrowsing"
)

# Check dependencies
if ! command -v dig &>/dev/null; then
  echo "Error: 'dig' not found. Install with: sudo apt install dnsutils"
  exit 1
fi

if ! command -v bc &>/dev/null; then
  echo "Error: 'bc' not found. Install with: sudo apt install bc"
  exit 1
fi

echo ""
echo "=== DNS Benchmark ==="
echo "Domain : $DOMAIN"
echo "Rounds : $ROUNDS queries per server"
echo "====================="
printf "%-22s %-20s %10s %10s %10s\n" "IP" "Provider" "Min(ms)" "Avg(ms)" "Max(ms)"
echo "------------------------------------------------------------------------"

declare -A results

for entry in "${DNS_SERVERS[@]}"; do
  IP="${entry%%|*}"
  NAME="${entry##*|}"
  
  total=0; min=9999; max=0; failed=0

  for i in $(seq 1 "$ROUNDS"); do
    ms=$(dig @"$IP" "$DOMAIN" +time=2 +tries=1 +stats 2>/dev/null \
      | grep "Query time:" | awk '{print $4}')

    if [[ -z "$ms" ]]; then
      ((failed++))
      continue
    fi

    total=$(echo "$total + $ms" | bc)
    (( $(echo "$ms < $min" | bc -l) )) && min=$ms
    (( $(echo "$ms > $max" | bc -l) )) && max=$ms
  done

  success=$(( ROUNDS - failed ))

  if [[ $success -eq 0 ]]; then
    printf "%-22s %-20s %10s %10s %10s\n" "$IP" "$NAME" "FAIL" "FAIL" "FAIL"
    results["FAIL_$IP"]="9999"
  else
    avg=$(echo "scale=1; $total / $success" | bc)
    printf "%-22s %-20s %10s %10s %10s\n" "$IP" "$NAME" "${min}" "${avg}" "${max}"
    results["$avg|$IP|$NAME"]="$avg"
  fi
done

echo "------------------------------------------------------------------------"
echo ""

# Find winner (lowest average)
best_avg=9999; best_line=""
for key in "${!results[@]}"; do
  avg="${key%%|*}"
  if (( $(echo "$avg < $best_avg" | bc -l) )); then
    best_avg="$avg"
    best_line="$key"
  fi
done

if [[ -n "$best_line" ]]; then
  best_ip=$(echo "$best_line" | cut -d'|' -f2)
  best_name=$(echo "$best_line" | cut -d'|' -f3)
  echo "  Fastest DNS: $best_name ($best_ip) — avg ${best_avg}ms"
  echo ""
  echo "  To use it permanently, add to /etc/resolv.conf:"
  echo "    nameserver $best_ip"
  echo ""
  echo "  Or with systemd-resolved:"
  echo "    sudo resolvectl dns <interface> $best_ip"
fi
