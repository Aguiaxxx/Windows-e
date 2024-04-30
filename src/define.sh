#!/usr/bin/env bash
set -Eeuo pipefail

: "${MANUAL:=""}"
: "${VERSION:=""}"
: "${DETECTED:=""}"
: "${PLATFORM:="x64"}"

parseVersion() {

  [ -z "$VERSION" ] && VERSION="win11"

  if [[ "${VERSION}" == \"*\" || "${VERSION}" == \'*\' ]]; then
    VERSION="${VERSION:1:-1}"
  fi

  case "${VERSION,,}" in
    "11" | "win11" | "windows11" | "windows 11")
      VERSION="win11${PLATFORM,,}"
      ;;
    "11e" | "win11e" | "windows11e" | "windows 11e")
      VERSION="win11${PLATFORM,,}-enterprise-eval"
      ;;
    "10" | "win10" | "windows10" | "windows 10")
      VERSION="win10${PLATFORM,,}"
      ;;
    "10e" | "win10e" | "windows10e" | "windows 10e")
      VERSION="win10${PLATFORM,,}-enterprise-eval"
      ;;
    "8" | "81" | "8.1" | "win8" | "win81" | "windows 8" | "windows 8.1")
      VERSION="win81${PLATFORM,,}"
      ;;
    "8e" | "81e" | "8.1e" | "win8e" | "win81e" | "windows8e" | "windows 8e")
      VERSION="win81${PLATFORM,,}-enterprise-eval"
      ;;
    "7" | "7e" | "win7" | "win7e" | "windows7" | "windows 7")
      VERSION="win7${PLATFORM,,}"
      DETECTED="win7${PLATFORM,,}-enterprise"
      ;;
    "vista" | "winvista" | "windowsvista" | "windows vista")
      VERSION="winvista${PLATFORM,,}"
      DETECTED="winvista${PLATFORM,,}-ultimate"
      ;;
    "xp" | "winxp" | "windowsxp" | "windows xp")
      VERSION="winxpx86"
      ;;
    "xp64" | "winxp64" | "windowsxp64")
      VERSION="winxpx64"
      ;;
    "22" | "2022" | "win22" | "win2022" | "windows2022" | "windows 2022")
      VERSION="win2022-eval"
      ;;
    "19" | "2019" | "win19" | "win2019" | "windows2019" | "windows 2019")
      VERSION="win2019-eval"
      ;;
    "16" | "2016" | "win16" | "win2016" | "windows2016" | "windows 2016")
      VERSION="win2016-eval"
      ;;
    "2012" | "2012r2" | "win2012" | "win2012r2" | "windows2012" | "windows 2012")
      VERSION="win2012r2-eval"
      ;;
    "2008" | "2008r2" | "win2008" | "win2008r2" | "windows2008" | "windows 2008")
      VERSION="win2008r2"
      ;;
    "core11" | "core 11" | "tiny11" | "tiny 11")
      DETECTED="win11${PLATFORM,,}"
      ;;
   "tiny10" | "tiny 10")
      DETECTED="win10${PLATFORM,,}-ltsc"
      ;;
    "iot10" | "10iot" | "win10-iot" | "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval")
      DETECTED="win10${PLATFORM,,}-iot"
      VERSION="win10${PLATFORM,,}-enterprise-iot-eval"
      ;;
    "ltsc10" | "10ltsc" | "win10-ltsc" | "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval")
      DETECTED="win10${PLATFORM,,}-ltsc"
      VERSION="win10${PLATFORM,,}-enterprise-ltsc-eval"
      ;;
  esac

  return 0
}

printVersion() {

  local id="$1"
  local desc="$2"

  [[ "$id" == "win7"* ]] && desc="Windows 7"
  [[ "$id" == "win8"* ]] && desc="Windows 8"
  [[ "$id" == "win10"* ]] && desc="Windows 10"
  [[ "$id" == "win11"* ]] && desc="Windows 11"
  [[ "$id" == "winxp"* ]] && desc="Windows XP"
  [[ "$id" == "winvista"* ]] && desc="Windows Vista"

  [[ "$id" == "win2025"* ]] && desc="Windows Server 2025"
  [[ "$id" == "win2022"* ]] && desc="Windows Server 2022"
  [[ "$id" == "win2019"* ]] && desc="Windows Server 2019"
  [[ "$id" == "win2016"* ]] && desc="Windows Server 2016"
  [[ "$id" == "win2012"* ]] && desc="Windows Server 2012"
  [[ "$id" == "win2008"* ]] && desc="Windows Server 2008"

  [ -z "$desc" ] && desc="Windows"

  echo "$desc"
  return 0
}

getName() {

  local file="$1"
  local desc="$2"

  [[ "${file,,}" == "win11"* ]] && desc="Windows 11"
  [[ "${file,,}" == "win10"* ]] && desc="Windows 10"
  [[ "${file,,}" == "win8"* ]] && desc="Windows 8"
  [[ "${file,,}" == "win7"* ]] && desc="Windows 7"
  [[ "${file,,}" == "winxp"* ]] && desc="Windows XP"
  [[ "${file,,}" == "winvista"* ]] && desc="Windows Vista"
  [[ "${file,,}" == "tiny10"* ]] && desc="Tiny 10"
  [[ "${file,,}" == "tiny11"* ]] && desc="Tiny 11"
  [[ "${file,,}" == "tiny11_core"* ]] && desc="Tiny 11 Core"
  [[ "${file,,}" == *"windows11"* ]] && desc="Windows 11"
  [[ "${file,,}" == *"windows10"* ]] && desc="Windows 10"
  [[ "${file,,}" == *"windows8"* ]] && desc="Windows 8"
  [[ "${file,,}" == *"windows7"* ]] && desc="Windows 7"
  [[ "${file,,}" == *"windowsxp"* ]] && desc="Windows XP"
  [[ "${file,,}" == *"windowsvista"* ]] && desc="Windows Vista"
  [[ "${file,,}" == *"windows_11"* ]] && desc="Windows 11"
  [[ "${file,,}" == *"windows_10"* ]] && desc="Windows 10"
  [[ "${file,,}" == *"windows_8"* ]] && desc="Windows 8"
  [[ "${file,,}" == *"windows_7"* ]] && desc="Windows 7"
  [[ "${file,,}" == *"windows_xp"* ]] && desc="Windows XP"
  [[ "${file,,}" == *"windows_vista"* ]] && desc="Windows Vista"
  [[ "${file,,}" == *"windows 11"* ]] && desc="Windows 11"
  [[ "${file,,}" == *"windows 10"* ]] && desc="Windows 10"
  [[ "${file,,}" == *"windows 8"* ]] && desc="Windows 8"
  [[ "${file,,}" == *"windows 7"* ]] && desc="Windows 7"
  [[ "${file,,}" == *"windows xp"* ]] && desc="Windows XP"
  [[ "${file,,}" == *"windows vista"* ]] && desc="Windows Vista"
  [[ "${file,,}" == *"server2008"* ]] && desc="Windows Server 2008"
  [[ "${file,,}" == *"server2012"* ]] && desc="Windows Server 2012"
  [[ "${file,,}" == *"server2016"* ]] && desc="Windows Server 2016"
  [[ "${file,,}" == *"server2019"* ]] && desc="Windows Server 2019"
  [[ "${file,,}" == *"server2022"* ]] && desc="Windows Server 2022"
  [[ "${file,,}" == *"server2025"* ]] && desc="Windows Server 2025"
  [[ "${file,,}" == *"server_2008"* ]] && desc="Windows Server 2008"
  [[ "${file,,}" == *"server_2012"* ]] && desc="Windows Server 2012"
  [[ "${file,,}" == *"server_2016"* ]] && desc="Windows Server 2016"
  [[ "${file,,}" == *"server_2019"* ]] && desc="Windows Server 2019"
  [[ "${file,,}" == *"server_2022"* ]] && desc="Windows Server 2022"
  [[ "${file,,}" == *"server_2025"* ]] && desc="Windows Server 2025"
  [[ "${file,,}" == *"server 2008"* ]] && desc="Windows Server 2008"
  [[ "${file,,}" == *"server 2012"* ]] && desc="Windows Server 2012"
  [[ "${file,,}" == *"server 2016"* ]] && desc="Windows Server 2016"
  [[ "${file,,}" == *"server 2019"* ]] && desc="Windows Server 2019"
  [[ "${file,,}" == *"server 2022"* ]] && desc="Windows Server 2022"
  [[ "${file,,}" == *"server 2025"* ]] && desc="Windows Server 2025"

  [ -z "$desc" ] && desc="Windows"

  echo "$desc"
  return 0
}

getVersion() {

  local name="$1"
  local detected=""

  if [[ "${name,,}" == *"windows 7"* ]]; then
    detected="win7${PLATFORM,,}"
    [[ "${name,,}" == *"ultimate"* ]] && detected="win7${PLATFORM,,}-ultimate"
    [[ "${name,,}" == *"enterprise"* ]] && detected="win7${PLATFORM,,}-enterprise"
  fi

  if [[ "${name,,}" == *"windows vista"* ]]; then
    detected="winvista${PLATFORM,,}"
    [[ "${name,,}" == *"ultimate"* ]] && detected="winvista${PLATFORM,,}-ultimate"
    [[ "${name,,}" == *"enterprise"* ]] && detected="winvista${PLATFORM,,}-enterprise"
  fi

  if [[ "${name,,}" == *"server 2025"* ]]; then
    detected="win2025"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2025-eval"
  fi

  if [[ "${name,,}" == *"server 2022"* ]]; then
    detected="win2022"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2022-eval"
  fi

  if [[ "${name,,}" == *"server 2019"* ]]; then
    detected="win2019"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2019-eval"
  fi

  if [[ "${name,,}" == *"server 2016"* ]]; then
    detected="win2016"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2016-eval"
  fi

  if [[ "${name,,}" == *"server 2012"* ]]; then
    detected="win2012r2"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2012r2-eval"
  fi

  if [[ "${name,,}" == *"server 2008"* ]]; then
    detected="win2008r2"
    [[ "${name,,}" == *"evaluation"* ]] && detected="win2008r2-eval"
  fi

  if [[ "${name,,}" == *"windows 8"* ]]; then
    detected="win81${PLATFORM,,}"
    [[ "${name,,}" == *"enterprise"* ]] && detected="win81${PLATFORM,,}-enterprise"
    [[ "${name,,}" == *"enterprise evaluation"* ]] && detected="win81${PLATFORM,,}-enterprise-eval"
  fi

  if [[ "${name,,}" == *"windows 11"* ]]; then
    detected="win11${PLATFORM,,}"
    [[ "${name,,}" == *"enterprise"* ]] && detected="win11${PLATFORM,,}-enterprise"
    [[ "${name,,}" == *"enterprise evaluation"* ]] && detected="win11${PLATFORM,,}-enterprise-eval"
  fi

  if [[ "${name,,}" == *"windows 10"* ]]; then
    detected="win10${PLATFORM,,}"
    if [[ "${name,,}" == *" iot "* ]]; then
      detected="win10${PLATFORM,,}-iot"
    else
      if [[ "${name,,}" == *"ltsc"* ]]; then
        detected="win10${PLATFORM,,}-ltsc"
      else
        [[ "${name,,}" == *"enterprise"* ]] && detected="win10${PLATFORM,,}-enterprise"
        [[ "${name,,}" == *"enterprise evaluation"* ]] && detected="win10${PLATFORM,,}-enterprise-eval"
      fi
    fi
  fi

  echo "$detected"
  return 0
}

switchEdition() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}-enterprise-eval")
      DETECTED="win11${PLATFORM,,}-enterprise"
      ;;
    "win10${PLATFORM,,}-enterprise-eval")
      DETECTED="win10${PLATFORM,,}-enterprise"
      ;;
    "win81${PLATFORM,,}-enterprise-eval")
      DETECTED="win81${PLATFORM,,}-enterprise"
      ;;
    "win2022-eval")
      DETECTED="win2022"
      ;;
    "win2019-eval")
      DETECTED="win2019"
      ;;
    "win2016-eval")
      DETECTED="win2016"
      ;;
    "win2012r2-eval")
      DETECTED="win2012r2"
      ;;
    "win2008r2-eval")
      DETECTED="win2008r2"
      ;;
  esac

  return 0
}

isESD() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}")
      return 0
      ;;
    "win10${PLATFORM,,}")
      return 0
      ;;
  esac

  return 1
}

isMido() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}" | "win11${PLATFORM,,}-enterprise-eval")
      return 0
      ;;
    "win10${PLATFORM,,}" | "win10${PLATFORM,,}-enterprise-eval" | "win10${PLATFORM,,}-enterprise-ltsc-eval")
      return 0
      ;;
    "win81${PLATFORM,,}" | "win81${PLATFORM,,}-enterprise-eval")
      return 0
      ;;
    "win2022-eval" | "win2019-eval" | "win2016-eval" | "win2012r2-eval" | "win2008r2")
      return 0
      ;;
  esac

  return 1
}

getLink() {

  # Fallbacks for users who cannot connect to the Microsoft servers

  local id="$1"
  local url=""
  local host="https://dl.bobpony.com"

  case "${id,,}" in
    "win11${PLATFORM,,}")
      url="$host/windows/11/en-us_windows_11_23h2_${PLATFORM,,}.iso"
      ;;
    "win10${PLATFORM,,}")
      url="$host/windows/10/en-us_windows_10_22h2_${PLATFORM,,}.iso"
      ;;
    "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval")
      url="$host/windows/10/en-us_windows_10_iot_enterprise_ltsc_2021_${PLATFORM,,}_dvd_257ad90f.iso"
      ;;
    "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval")
      url="$host/windows/10/en-us_windows_10_enterprise_ltsc_2021_${PLATFORM,,}_dvd_d289cf96.iso"
      ;;
    "win81${PLATFORM,,}")
      url="$host/windows/8.x/8.1/en_windows_8.1_with_update_${PLATFORM,,}_dvd_6051480.iso"
      ;;
    "win2022" | "win2022-eval")
      url="$host/windows/server/2022/en-us_windows_server_2022_updated_jan_2024_${PLATFORM,,}_dvd_2b7a0c9f.iso"
      ;;
    "win2019" | "win2019-eval")
      url="$host/windows/server/2019/en-us_windows_server_2019_updated_aug_2021_${PLATFORM,,}_dvd_a6431a28.iso"
      ;;
    "win2016" | "win2016-eval")
      url="$host/windows/server/2016/en_windows_server_2016_updated_feb_2018_${PLATFORM,,}_dvd_11636692.iso"
      ;;
    "win2012r2" | "win2012r2-eval")
      url="$host/windows/server/2012r2/en_windows_server_2012_r2_with_update_${PLATFORM,,}_dvd_6052708-004.iso"
      ;;
    "win2008r2" | "win2008r2-eval")
      url="$host/windows/server/2008r2/en_windows_server_2008_r2_with_sp1_${PLATFORM,,}_dvd_617601-018.iso"
      ;;
    "win7${PLATFORM,,}" | "win7${PLATFORM,,}-enterprise")
      url="$host/windows/7/en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"
      ;;
    "winvista${PLATFORM,,}" | "winvista${PLATFORM,,}-ultimate")
      url="$host/windows/vista/en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
      ;;
    "winxpx86")
      url="$host/windows/xp/professional/en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso"
      ;;
    "winxpx64")
      url="$host/windows/xp/professional/en_win_xp_pro_${PLATFORM,,}_vl.iso"
      ;;
    "core11")
      url="https://file.cnxiaobai.com/Windows/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny11%20core%20${PLATFORM,,}%20beta%201.iso"
      ;;
    "tiny11")
      url="https://file.cnxiaobai.com/Windows/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny11%202311%20${PLATFORM,,}.iso"
      ;;
    "tiny10")
      url="https://file.cnxiaobai.com/Windows/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny10%2023H2%20${PLATFORM,,}.iso"
      ;;
  esac

  echo "$url"
  return 0
}

secondLink() {

  # Fallbacks for users who cannot connect to the Microsoft servers

  local id="$1"
  local url=""
  local host="https://drive.massgrave.dev"

  case "${id,,}" in
    "win11${PLATFORM,,}")
      url="$host/en-us_windows_11_consumer_editions_version_23h2_updated_april_2024_${PLATFORM,,}_dvd_d986680b.iso"
      ;;
    "win11${PLATFORM,,}-enterprise" | "win11${PLATFORM,,}-enterprise-eval")
      url="$host/en-us_windows_11_business_editions_version_23h2_updated_april_2024_${PLATFORM,,}_dvd_349cd577.iso"
      ;;
    "win11${PLATFORM,,}-iot" | "win11${PLATFORM,,}-enterprise-iot-eval")
      url="$host/en-us_windows_11_iot_enterprise_version_23h2_${PLATFORM,,}_dvd_fb37549c.iso"
      ;;
    "win10${PLATFORM,,}")
      url="$host/en-us_windows_10_consumer_editions_version_22h2_updated_april_2024_${PLATFORM,,}_dvd_9a92dc89.iso"
      ;;
    "win10${PLATFORM,,}-enterprise" | "win10${PLATFORM,,}-enterprise-eval")
      url="$host/en-us_windows_10_business_editions_version_22h2_updated_april_2024_${PLATFORM,,}_dvd_c00090a7.iso"
      ;;
    "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval")
      url="$host/en-us_windows_10_iot_enterprise_ltsc_2021_${PLATFORM,,}_dvd_257ad90f.iso"
      ;;
    "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval")
      url="$host/en-us_windows_10_enterprise_ltsc_2021_${PLATFORM,,}_dvd_d289cf96.iso"
      ;;
    "win81${PLATFORM,,}")
      url="$host/en_windows_8.1_pro_vl_with_update_${PLATFORM,,}_dvd_6050880.iso"
      ;;
    "win81${PLATFORM,,}-enterprise" | "win81${PLATFORM,,}-enterprise-eval")
      url="$host/en_windows_8.1_enterprise_with_update_${PLATFORM,,}_dvd_6054382.iso"
      ;;
    "win2022" | "win2022-eval")
      url="$host/en-us_windows_server_2022_updated_april_2024_${PLATFORM,,}_dvd_164349f3.iso"
      ;;
    "win2019" | "win2019-eval")
      url="$host/en_windows_server_2019_${PLATFORM,,}_dvd_4cb967d8.iso"
      ;;
    "win2016" | "win2016-eval")
      url="$host/en_windows_server_2016_${PLATFORM,,}_dvd_9327751.iso"
      ;;
    "win2012r2" | "win2012r2-eval")
      url="$host/en_windows_server_2012_r2_with_update_${PLATFORM,,}_dvd_6052708.iso"
      ;;
    "win2008r2" | "win2008r2-eval")
      url="$host/en_windows_server_2008_r2_with_sp1_${PLATFORM,,}_dvd_617601.iso"
      ;;
    "win7${PLATFORM,,}" | "win7${PLATFORM,,}-enterprise")
      url="$host/en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"
      ;;
    "winvista${PLATFORM,,}" | "winvista${PLATFORM,,}-ultimate")
      url="$host/en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
      ;;
    "winxpx86")
      url="$host/en_windows_xp_professional_with_service_pack_3_x86_cd_vl_x14-73974.iso"
      ;;
    "winxpx64")
      url="$host/en_win_xp_pro_${PLATFORM,,}_with_sp2_vl_x13-41611.iso"
      ;;
    "core11")
      url="https://archive.org/download/tiny-11-core-x-64-beta-1/tiny11%20core%20${PLATFORM,,}%20beta%201.iso"
      ;;
    "tiny11")
      url="https://archive.org/download/tiny11-2311/tiny11%202311%20${PLATFORM,,}.iso"
      ;;
    "tiny10")
      url="https://archive.org/download/tiny-10-23-h2/tiny10%20${PLATFORM,,}%2023h2.iso"
      ;;
  esac

  echo "$url"
  return 0
}

validVersion() {

  local id="$1"
  local url

  isESD "$id" && return 0
  isMido "$id" && return 0

  url=$(getLink "$id")
  [ -n "$url" ] && return 0

  url=$(secondLink "$id")
  [ -n "$url" ] && return 0

  return 1
}

migrateFiles() {

  local base="$1"
  local version="$2"
  local file=""

  [ -f "$STORAGE/$base" ] && return 0

  [[ "${version,,}" == "tiny10" ]] && file="tiny10_${PLATFORM,,}_23h2.iso"
  [[ "${version,,}" == "tiny11" ]] && file="tiny11_2311_${PLATFORM,,}.iso"
  [[ "${version,,}" == "core11" ]] && file="tiny11_core_${PLATFORM,,}_beta_1.iso"
  [[ "${version,,}" == "winxpx86" ]] && file="en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso"
  [[ "${version,,}" == "winvista${PLATFORM,,}" ]] && file="en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
  [[ "${version,,}" == "win7${PLATFORM,,}" ]] && file="en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"

  [ -z "$file" ] && return 0
  [ ! -f "$STORAGE/$file" ] && return 0

  ! mv "$STORAGE/$file" "$STORAGE/$base" && return 1

  return 0
}

configXP() {

  local dir="$1"
  local arch="x86"
  local target="$dir/I386"
  local drivers="$TMP/drivers"

  if [ -d "$dir/AMD64" ]; then
    arch="amd64"
    target="$dir/AMD64"
  fi

  rm -rf "$drivers"

  if ! 7z x /run/drivers.iso -o"$drivers" > /dev/null; then
    error "Failed to extract driver ISO file!" && return 1
  fi

  cp "$drivers/viostor/xp/$arch/viostor.sys" "$target"

  mkdir -p "$dir/\$OEM\$/\$1/Drivers/viostor"
  cp "$drivers/viostor/xp/$arch/viostor.cat" "$dir/\$OEM\$/\$1/Drivers/viostor"
  cp "$drivers/viostor/xp/$arch/viostor.inf" "$dir/\$OEM\$/\$1/Drivers/viostor"
  cp "$drivers/viostor/xp/$arch/viostor.sys" "$dir/\$OEM\$/\$1/Drivers/viostor"

  mkdir -p "$dir/\$OEM\$/\$1/Drivers/NetKVM"
  cp "$drivers/NetKVM/xp/$arch/netkvm.cat" "$dir/\$OEM\$/\$1/Drivers/NetKVM"
  cp "$drivers/NetKVM/xp/$arch/netkvm.inf" "$dir/\$OEM\$/\$1/Drivers/NetKVM"
  cp "$drivers/NetKVM/xp/$arch/netkvm.sys" "$dir/\$OEM\$/\$1/Drivers/NetKVM"

  sed -i '/^\[SCSI.Load\]/s/$/\nviostor=viostor.sys,4/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\nviostor.sys=1,,,,,,4_,4,1,,,1,4/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SCSI\]/s/$/\nviostor=\"Red Hat VirtIO SCSI Disk Device\"/' "$target/TXTSETUP.SIF"
  sed -i '/^\[HardwareIdsDatabase\]/s/$/\nPCI\\VEN_1AF4\&DEV_1001\&SUBSYS_00000000=\"viostor\"/' "$target/TXTSETUP.SIF"
  sed -i '/^\[HardwareIdsDatabase\]/s/$/\nPCI\\VEN_1AF4\&DEV_1001\&SUBSYS_00020000=\"viostor\"/' "$target/TXTSETUP.SIF"
  sed -i '/^\[HardwareIdsDatabase\]/s/$/\nPCI\\VEN_1AF4\&DEV_1001\&SUBSYS_00021AF4=\"viostor\"/' "$target/TXTSETUP.SIF"
  sed -i '/^\[HardwareIdsDatabase\]/s/$/\nPCI\\VEN_1AF4\&DEV_1001\&SUBSYS_00000000=\"viostor\"/' "$target/TXTSETUP.SIF"

  mkdir -p "$dir/\$OEM\$/\$1/Drivers/sata"

  cp -a "$drivers/sata/xp/$arch/." "$dir/\$OEM\$/\$1/Drivers/sata"
  cp -a "$drivers/sata/xp/$arch/." "$target"

  sed -i '/^\[SCSI.Load\]/s/$/\niaStor=iaStor.sys,4/' "$target/TXTSETUP.SIF"
  sed -i '/^\[FileFlags\]/s/$/\niaStor.sys = 16/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaStor.cat = 1,,,,,,,1,0,0/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaStor.inf = 1,,,,,,,1,0,0/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaStor.sys = 1,,,,,,4_,4,1,,,1,4/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaStor.sys = 1,,,,,,,1,0,0/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaahci.cat = 1,,,,,,,1,0,0/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SourceDisksFiles.'"$arch"'\]/s/$/\niaAHCI.inf = 1,,,,,,,1,0,0/' "$target/TXTSETUP.SIF"
  sed -i '/^\[SCSI\]/s/$/\niaStor=\"Intel\(R\) SATA RAID\/AHCI Controller\"/' "$target/TXTSETUP.SIF"
  sed -i '/^\[HardwareIdsDatabase\]/s/$/\nPCI\\VEN_8086\&DEV_2922\&CC_0106=\"iaStor\"/' "$target/TXTSETUP.SIF"

  # Windows XP Pro generic key (no activation)
  local key="DR8GV-C8V6J-BYXHG-7PYJR-DB66Y"

  local pid setup
  setup=$(find "$target" -maxdepth 1 -type f -iname setupp.ini | head -n 1)
  pid=$(<"$setup")
  pid="${pid:(-4)}"
  pid="${pid:0:3}"

  if [[ "$pid" == "270" ]]; then
    info "Warning: this ISO requires a volume license, it will reject the generic key during installation."
  fi

  find "$target" -maxdepth 1 -type f -iname winnt.sif -exec rm {} \;

  {       echo "[Data]"
          echo "AutoPartition=1"
          echo "MsDosInitiated=\"0\""
          echo "UnattendedInstall=\"Yes\""
          echo "AutomaticUpdates=\"Yes\""
          echo ""
          echo "[Unattended]"
          echo "UnattendSwitch=Yes"
          echo "UnattendMode=FullUnattended"
          echo "FileSystem=NTFS"
          echo "OemSkipEula=Yes"
          echo "OemPreinstall=Yes"
          echo "Repartition=Yes"
          echo "WaitForReboot=\"No\""
          echo "DriverSigningPolicy=\"Ignore\""
          echo "NonDriverSigningPolicy=\"Ignore\""
          echo "OemPnPDriversPath=\"Drivers\viostor;Drivers\NetKVM;Drivers\sata\""
          echo "NoWaitAfterTextMode=1"
          echo "NoWaitAfterGUIMode=1"
          echo "FileSystem-ConvertNTFS"
          echo "ExtendOemPartition=0"
          echo "Hibernation=\"No\""
          echo ""
          echo "[GuiUnattended]"
          echo "OEMSkipRegional=1"
          echo "OemSkipWelcome=1"
          echo "AdminPassword=*"
          echo "TimeZone=0"
          echo "AutoLogon=Yes"
          echo "AutoLogonCount=65432"
          echo ""
          echo "[UserData]"
          echo "FullName=\"Docker\""
          echo "ComputerName=\"*\""
          echo "OrgName=\"Windows for Docker\""
          echo "ProductKey=$key"
          echo ""
          echo "[Identification]"
          echo "JoinWorkgroup = WORKGROUP"
          echo ""
          echo "[Networking]"
          echo "InstallDefaultComponents=Yes"
          echo ""
          echo "[Branding]"
          echo "BrandIEUsingUnattended=Yes"
          echo ""
          echo "[URL]"
          echo "Home_Page = http://www.google.com"
          echo "Search_Page = http://www.google.com"
          echo ""
          echo "[RegionalSettings]"
          echo "Language=00000409"
          echo ""
          echo "[TerminalServices]"
          echo "AllowConnections=1"
  } | unix2dos > "$target/WINNT.SIF"

  {       echo "Windows Registry Editor Version 5.00"
          echo ""
          echo "[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Security]"
          echo "\"FirstRunDisabled\"=dword:00000001"
          echo "\"AntiVirusOverride\"=dword:00000001"
          echo "\"FirewallOverride\"=dword:00000001"
          echo "\"FirewallDisableNotify\"=dword:00000001"
          echo "\"UpdatesDisableNotify\"=dword:00000001"
          echo "\"AntiVirusDisableNotify\"=dword:00000001"
          echo ""
          echo "[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\wscsvc]"
          echo "\"Start\"=dword:00000004"
          echo ""
          echo "[HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\WindowsFirewall\StandardProfile]"
          echo "\"EnableFirewall\"=dword:00000000"
          echo ""
          echo "[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess]"
          echo "\"Start\"=dword:00000004"
          echo
          echo "[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\StandardProfile\GloballyOpenPorts\List]"
          echo "\"3389:TCP\"=\"3389:TCP:*:Enabled:@xpsp2res.dll,-22009\""
          echo ""
          echo "[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa]"
          echo "\"LimitBlankPasswordUse\"=dword:00000000"
          echo ""
          echo "[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Applets\Tour]"
          echo "\"RunCount\"=dword:00000000"
          echo ""
          echo "[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced]"
          echo "\"HideFileExt\"=dword:00000000"
          echo ""
          echo "[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon]"
          echo "\"DefaultUserName\"=\"Docker\""
          echo "\"DefaultDomainName\"=\"Dockur\""
          echo "\"AltDefaultUserName\"=\"Docker\""
          echo "\"AltDefaultDomainName\"=\"Dockur\""
          echo "\"AutoAdminLogon\"=\"1\""
  } | unix2dos > "$dir/\$OEM\$/install.reg"

  {       echo "Set WshShell = WScript.CreateObject(\"WScript.Shell\")"
          echo "Set WshNetwork = WScript.CreateObject(\"WScript.Network\")"
          echo "Set oMachine = GetObject(\"WinNT://\" & WshNetwork.ComputerName)"
          echo "Set oInfoUser = GetObject(\"WinNT://\" & WshNetwork.ComputerName & \"/Administrator,user\")"
          echo "Set oUser = oMachine.MoveHere(oInfoUser.ADsPath,\"Docker\")"
  } | unix2dos > "$dir/\$OEM\$/admin.vbs"

  {       echo "[COMMANDS]"
          echo "\"REGEDIT /s install.reg\""
          echo "\"Wscript admin.vbs\""
  } | unix2dos > "$dir/\$OEM\$/cmdlines.txt"

  rm -rf "$drivers"
  return 0
}

prepareXP() {

  local iso="$1"
  local dir="$2"

  MACHINE="pc-q35-2.10"
  BOOT_MODE="windows_legacy"
  ETFS="[BOOT]/Boot-NoEmul.img"

  [[ "$MANUAL" == [Yy1]* ]] && return 0
  configXP "$dir" && return 0

  error "Failed to generate XP configuration files!" && exit 66
}

prepareLegacy() {

  local iso="$1"
  local dir="$2"

  ETFS="boot.img"
  BOOT_MODE="windows_legacy"

  rm -f "$dir/$ETFS"

  local len offset
  len=$(isoinfo -d -i "$iso" | grep "Nsect " | grep -o "[^ ]*$")
  offset=$(isoinfo -d -i "$iso" | grep "Bootoff " | grep -o "[^ ]*$")

  if ! dd "if=$iso" "of=$dir/$ETFS" bs=2048 "count=$len" "skip=$offset" status=none; then
    error "Failed to extract boot image from ISO!" && exit 67
  fi

  return 0
}

return 0
