#!/usr/bin/env bash
# scsi1(빈 디스크)을 찾아 ext4 포맷 → /var/lib/docker 마운트(fstab UUID). 멱등.
set -e

find_new_disk() {
  for d in /dev/sd?; do
    [ -b "$d" ] || continue
    # 파티션 없음 + 파일시스템 없음 = 새 빈 디스크 (OS 디스크는 파티션 보유 → 제외)
    if [ -z "$(ls ${d}[0-9]* 2>/dev/null)" ] && [ -z "$(lsblk -dno FSTYPE "$d")" ]; then
      echo "$d"; return
    fi
  done
}

# 이미 마운트돼 있으면 멱등 종료
if mountpoint -q /var/lib/docker; then
  echo "이미 마운트됨: $(df -h --output=source,size,target /var/lib/docker | tail -1)"; exit 0
fi

NEWDISK=$(find_new_disk)
if [ -z "$NEWDISK" ]; then
  echo "SCSI 재스캔..."; for h in /sys/class/scsi_host/host*/scan; do echo "- - -" | sudo tee "$h" >/dev/null; done; sleep 3
  NEWDISK=$(find_new_disk)
fi
if [ -z "$NEWDISK" ]; then
  echo "새 디스크 못 찾음:"; lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT; exit 1
fi

echo "새 디스크: $NEWDISK ($(lsblk -dno SIZE "$NEWDISK" | tr -d ' '))"
sudo mkfs.ext4 -qF -L docker "$NEWDISK"
UUID=$(sudo blkid -s UUID -o value "$NEWDISK")
sudo mkdir -p /var/lib/docker
grep -q "/var/lib/docker" /etc/fstab || \
  echo "UUID=$UUID /var/lib/docker ext4 defaults,noatime 0 2" | sudo tee -a /etc/fstab >/dev/null
sudo mount -a
echo "완료: $(df -h --output=source,size,target /var/lib/docker | tail -1)"
