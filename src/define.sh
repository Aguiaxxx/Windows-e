#!/usr/bin/env bash
set -Eeuo pipefail

: "${VERIFY:=""}"
: "${MANUAL:=""}"
: "${VERSION:=""}"
: "${DETECTED:=""}"
: "${PLATFORM:="x64"}"

MIRRORS=5

parseVersion() {

  [ -z "$VERSION" ] && VERSION="win11"

  if [[ "${VERSION}" == \"*\" || "${VERSION}" == \'*\' ]]; then
    VERSION="${VERSION:1:-1}"
  fi

  case "${VERSION,,}" in
    "11" | "win11" | "windows11" | "windows 11" )
      VERSION="win11${PLATFORM,,}"
      ;;
    "11e" | "win11e" | "windows11e" | "windows 11e" )
      VERSION="win11${PLATFORM,,}-enterprise-eval"
      ;;
    "10" | "win10" | "windows10" | "windows 10" )
      VERSION="win10${PLATFORM,,}"
      ;;
    "10e" | "win10e" | "windows10e" | "windows 10e" )
      VERSION="win10${PLATFORM,,}-enterprise-eval"
      ;;
    "8" | "81" | "8.1" | "win8" | "win81" | "windows 8" )
      VERSION="win81${PLATFORM,,}"
      ;;
    "8e" | "81e" | "8.1e" | "win8e" | "win81e" | "windows 8e" )
      VERSION="win81${PLATFORM,,}-enterprise-eval"
      ;;
    "7" | "7e" | "win7" | "win7e" | "windows7" | "windows 7" )
      VERSION="win7${PLATFORM,,}"
      DETECTED="win7${PLATFORM,,}-enterprise"
      ;;
    "vista" | "winvista" | "windowsvista" | "windows vista" )
      VERSION="winvista${PLATFORM,,}"
      DETECTED="winvista${PLATFORM,,}-enterprise"
      ;;
    "xp" | "xp32" | "winxp" | "windowsxp" | "windows xp" )
      VERSION="winxpx86"
      ;;
    "xp64" | "winxp64" | "windowsxp64" | "windows xp 64" )
      VERSION="winxpx64"
      ;;
    "22" | "2022" | "win22" | "win2022" | "windows2022" | "windows 2022" )
      VERSION="win2022-eval"
      ;;
    "19" | "2019" | "win19" | "win2019" | "windows2019" | "windows 2019" )
      VERSION="win2019-eval"
      ;;
    "16" | "2016" | "win16" | "win2016" | "windows2016" | "windows 2016" )
      VERSION="win2016-eval"
      ;;
    "2012" | "2012r2" | "win2012" | "win2012r2" | "windows2012" | "windows 2012" )
      VERSION="win2012r2-eval"
      ;;
    "2008" | "2008r2" | "win2008" | "win2008r2" | "windows2008" | "windows 2008" )
      VERSION="win2008r2"
      ;;
    "core11" | "core 11" )
      VERSION="core11"
      DETECTED="win11${PLATFORM,,}"
      ;;
    "tiny11" | "tiny 11" )
      VERSION="tiny11"
      DETECTED="win11${PLATFORM,,}"
      ;;
   "tiny10" | "tiny 10" )
      VERSION="tiny10"
      DETECTED="win10${PLATFORM,,}-ltsc"
      ;;
    "iot11" | "11iot" | "win11-iot" | "win11${PLATFORM,,}-iot" | "win11${PLATFORM,,}-enterprise-iot-eval" )
      DETECTED="win11${PLATFORM,,}-iot"
      VERSION="win11${PLATFORM,,}-enterprise-iot-eval"
      ;;
    "iot10" | "10iot" | "win10-iot" | "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval" )
      DETECTED="win10${PLATFORM,,}-iot"
      VERSION="win10${PLATFORM,,}-enterprise-iot-eval"
      ;;
    "ltsc10" | "10ltsc" | "win10-ltsc" | "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval" )
      DETECTED="win10${PLATFORM,,}-ltsc"
      VERSION="win10${PLATFORM,,}-enterprise-ltsc-eval"
      ;;
  esac

  return 0
}

printVersion() {

  local id="$1"
  local desc="$2"

  case "${id,,}" in
    "tiny11"* ) desc="Tiny 11" ;;
    "tiny10"* ) desc="Tiny 10" ;;
    "core11"* ) desc="Core 11" ;;
    "win7"* ) desc="Windows 7" ;;
    "win8"* ) desc="Windows 8" ;;
    "win10"* ) desc="Windows 10" ;;
    "win11"* ) desc="Windows 11" ;;
    "winxp"* ) desc="Windows XP" ;;
    "winvista"* ) desc="Windows Vista" ;;
    "win2025"* ) desc="Windows Server 2025" ;;
    "win2022"* ) desc="Windows Server 2022" ;;
    "win2019"* ) desc="Windows Server 2019" ;;
    "win2016"* ) desc="Windows Server 2016" ;;
    "win2012"* ) desc="Windows Server 2012" ;;
    "win2008"* ) desc="Windows Server 2008" ;;
  esac

  if [ -z "$desc" ]; then
    desc="Windows"
    [[ "${PLATFORM,,}" != "x64" ]] && desc="$desc for ${PLATFORM}"
  fi

  echo "$desc"
  return 0
}

printEdition() {

  local id="$1"
  local desc="$2"
  local result=""
  local edition=""

  result=$(printVersion "$id" "x")
  [[ "$result" == "x" ]] && echo "$desc" && return 0

  case "${id,,}" in
    "win7${PLATFORM,,}-home"* )
      edition="Home"
      ;;
    "win7${PLATFORM,,}-starter"* )
      edition="Starter"
      ;;
    "win7${PLATFORM,,}-ultimate"* )
      edition="Ultimate"
      ;;
    "win7${PLATFORM,,}-enterprise"* )
      edition="Enterprise"
      ;;
    "win7"* )
      edition="Professional"
      ;;
    "win8${PLATFORM,,}-enterprise"* )
      edition="Enterprise"
      ;;
    "win8"* )
      edition="Pro"
      ;;
    "win10${PLATFORM,,}-iot"* )
      edition="IoT"
      ;;
    "win10${PLATFORM,,}-ltsc"* )
      edition="LTSC"
      ;;
    "win10${PLATFORM,,}-home"* )
      edition="Home"
      ;;
    "win10${PLATFORM,,}-education"* )
      edition="Education"
      ;;
    "win10${PLATFORM,,}-enterprise"* )
      edition="Enterprise"
      ;;
    "win10"* )
      edition="Pro"
      ;;
    "win11${PLATFORM,,}-iot"* )
      edition="IoT"
      ;;
    "win11${PLATFORM,,}-home"* )
      edition="Home"
      ;;
    "win11${PLATFORM,,}-education"* )
      edition="Education"
      ;;
    "win11${PLATFORM,,}-enterprise"* )
      edition="Enterprise"
      ;;
    "win11"* )
      edition="Pro"
      ;;
    "winxp"* )
      edition="Professional"
      ;;
    "winvista${PLATFORM,,}-home"* )
      edition="Home"
      ;;
    "winvista${PLATFORM,,}-starter"* )
      edition="Starter"
      ;;
    "winvista${PLATFORM,,}-ultimate"* )
      edition="Ultimate"
      ;;
    "winvista${PLATFORM,,}-enterprise"* )
      edition="Enterprise"
      ;;
    "winvista"* )
      edition="Business"
      ;;
    "win2025"* | "win2022"* | "win2019"* | "win2016"* | "win2012"* | "win2008"* )
      edition="Standard"
      ;;
  esac

  [[ "${id,,}" == *"-eval" ]] && edition="$edition (Evaluation)"
  [ -n "$edition" ] && result="$result $edition"

  echo "$result"
  return 0
}

fromFile() {

  local id=""
  local desc="$1"
  local file="${1,,}"

  case "${file/ /_}" in
    "win7"* | "win_7"* | *"windows7"* | *"windows_7"* )
      id="win7${PLATFORM,,}"
      ;;
    "win8"* | "win_8"* | *"windows8"* | *"windows_8"* )
      id="win81${PLATFORM,,}"
      ;;
    "win10"*| "win_10"* | *"windows10"* | *"windows_10"* )
      id="win10${PLATFORM,,}"
      ;;
    "win11"* | "win_11"* | *"windows11"* | *"windows_11"* )
      id="win11${PLATFORM,,}"
      ;;
    *"winxp"* | *"win_xp"* | *"windowsxp"* | *"windows_xp"* )
      id="winxpx86"
      ;;
    *"winvista"* | *"win_vista"* | *"windowsvista"* | *"windows_vista"* )
      id="winvista${PLATFORM,,}"
      ;;
    "tiny11core"* | "tiny11_core"* | "tiny_11_core"* )
      id="core11"
      ;;
    "tiny11"* | "tiny_11"* )
      id="tiny11"
      ;;
    "tiny10"* | "tiny_10"* )
      id="tiny10"
      ;;
    *"server2025"* | *"server_2025"* )
      id="win2025"
      ;;
    *"server2022"* | *"server_2022"* )
      id="win2022"
      ;;
    *"server2019"* | *"server_2019"* )
      id="win2019"
      ;;
    *"server2016"* | *"server_2016"* )
      id="win2016"
      ;;
    *"server2012"* | *"server_2012"* )
      id="win2012r2"
      ;;
    *"server2008"* | *"server_2008"* )
      id="win2008r2"
      ;;
  esac

  if [ -n "$id" ]; then
    desc=$(printVersion "$id" "$desc")
  fi

  echo "$desc"
  return 0
}

fromName() {

  local id=""
  local name="$1"

  case "${name,,}" in
    *"server 2025"* ) id="win2025" ;;
    *"server 2022"* ) id="win2022" ;;
    *"server 2019"* ) id="win2019" ;;
    *"server 2016"* ) id="win2016" ;;
    *"server 2012"* ) id="win2012r2" ;;
    *"server 2008"* ) id="win2008r2" ;;
    *"windows 7"* ) id="win7${PLATFORM,,}" ;;
    *"windows 8"* ) id="win81${PLATFORM,,}" ;;
    *"windows 10"* ) id="win10${PLATFORM,,}" ;;
    *"windows 11"* ) id="win11${PLATFORM,,}" ;;
    *"windows vista"* ) id="winvista${PLATFORM,,}" ;;
  esac

  echo "$id"
  return 0
}

getVersion() {

  local id
  local name="$1"

  id=$(fromName "$name")

  case "${id,,}" in
    "win7"* | "winvista"* )
        case "${name,,}" in
          *" home"* ) id="$id-home" ;;
          *" starter"* ) id="$id-starter" ;;
          *" ultimate"* ) id="$id-ultimate" ;;
          *" enterprise"* ) id="$id-enterprise" ;;
        esac
      ;;
    "win8"* )
        case "${name,,}" in
          *" enterprise evaluation"* ) id="$id-enterprise-eval" ;;
          *" enterprise"* ) id="$id-enterprise" ;;
        esac
      ;;
    "win10"* )
        case "${name,,}" in
          *" iot"* ) id="$id-iot" ;;
          *" ltsc"* ) id="$id-ltsc" ;;
          *" home"* ) id="$id-home" ;;
          *" education"* ) id="$id-education" ;;
          *" enterprise evaluation"* ) id="$id-enterprise-eval" ;;
          *" enterprise"* ) id="$id-enterprise" ;;
        esac
      ;;
    "win11"* )
       case "${name,,}" in
          *" iot"* ) id="$id-iot" ;;
          *" home"* ) id="$id-home" ;;
          *" education"* ) id="$id-education" ;;
          *" enterprise evaluation"* ) id="$id-enterprise-eval" ;;
          *" enterprise"* ) id="$id-enterprise" ;;
        esac
      ;;
    "win2025"* | "win2022"* | "win2019"* | "win2016"* | "win2012"* | "win2008"* )
       case "${name,,}" in
          *" evaluation"* ) id="$id-eval" ;;
        esac
      ;;
  esac

  echo "$id"
  return 0
}

switchEdition() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}-enterprise-eval" )
      DETECTED="win11${PLATFORM,,}-enterprise"
      ;;
    "win10${PLATFORM,,}-enterprise-eval" )
      DETECTED="win10${PLATFORM,,}-enterprise"
      ;;
    "win81${PLATFORM,,}-enterprise-eval" )
      DETECTED="win81${PLATFORM,,}-enterprise"
      ;;
    "win2022-eval" ) DETECTED="win2022" ;;
    "win2019-eval" ) DETECTED="win2019" ;;
    "win2016-eval" ) DETECTED="win2016" ;;
    "win2012r2-eval" ) DETECTED="win2012r2" ;;
    "win2008r2-eval" ) DETECTED="win2008r2" ;;
  esac

  return 0
}

isESD() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}" ) return 0 ;;
    "win10${PLATFORM,,}" ) return 0 ;;
  esac

  return 1
}

isMido() {

  local id="$1"

  case "${id,,}" in
    "win11${PLATFORM,,}" | "win11${PLATFORM,,}-enterprise-eval" )
      return 0 ;;
    "win10${PLATFORM,,}" | "win10${PLATFORM,,}-enterprise-eval" | "win10${PLATFORM,,}-enterprise-ltsc-eval" )
      return 0 ;;
    "win81${PLATFORM,,}" | "win81${PLATFORM,,}-enterprise-eval" )
      return 0 ;;
    "win2022-eval" | "win2019-eval" | "win2016-eval" | "win2012r2-eval" | "win2008r2" )
      return 0 ;;
  esac

  return 1
}

getLink1() {

  # Fallbacks for users who cannot connect to the Microsoft servers

  local id="$1"
  local ret="$2"
  local url=""
  local sum=""
  local host="https://dl.bobpony.com/windows"

  case "${id,,}" in
    "win11${PLATFORM,,}" )
      sum="5bb1459034f50766ee480d895d751af73a4af30814240ae32ebc5633546a5af7"
      url="$host/11/en-us_windows_11_23h2_${PLATFORM,,}.iso"
      ;;
    "win10${PLATFORM,,}" )
      sum="6673e2ab6c6939a74eceff2c2bb4d36feb94ff8a6f71700adef0f0b998fdcaca"
      url="$host/10/en-us_windows_10_22h2_${PLATFORM,,}.iso"
      ;;
    "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval" )
      sum="a0334f31ea7a3e6932b9ad7206608248f0bd40698bfb8fc65f14fc5e4976c160"
      url="$host/10/en-us_windows_10_iot_enterprise_ltsc_2021_${PLATFORM,,}_dvd_257ad90f.iso"
      ;;
    "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval" )
      sum="c90a6df8997bf49e56b9673982f3e80745058723a707aef8f22998ae6479597d"
      url="$host/10/en-us_windows_10_enterprise_ltsc_2021_${PLATFORM,,}_dvd_d289cf96.iso"
      ;;
    "win81${PLATFORM,,}" )
      sum="d8333cf427eb3318ff6ab755eb1dd9d433f0e2ae43745312c1cd23e83ca1ce51"
      url="$host/8.x/8.1/en_windows_8.1_with_update_${PLATFORM,,}_dvd_6051480.iso"
      ;;
    "win2022" | "win2022-eval" )
      sum="c3c57bb2cf723973a7dcfb1a21e97dfa035753a7f111e348ad918bb64b3114db"
      url="$host/server/2022/en-us_windows_server_2022_updated_jan_2024_${PLATFORM,,}_dvd_2b7a0c9f.iso"
      ;;
    "win2019" | "win2019-eval" )
      sum="0067afe7fdc4e61f677bd8c35a209082aa917df9c117527fc4b2b52a447e89bb"
      url="$host/server/2019/en-us_windows_server_2019_updated_aug_2021_${PLATFORM,,}_dvd_a6431a28.iso"
      ;;
    "win2016" | "win2016-eval" )
      sum="af06e5483c786c023123e325cea4775050324d9e1366f46850b515ae43f764be"
      url="$host/server/2016/en_windows_server_2016_updated_feb_2018_${PLATFORM,,}_dvd_11636692.iso"
      ;;
    "win2012r2" | "win2012r2-eval" )
      sum="f351e89eb88a96af4626ceb3450248b8573e3ed5924a4e19ea891e6003b62e4e"
      url="$host/server/2012r2/en_windows_server_2012_r2_with_update_${PLATFORM,,}_dvd_6052708-004.iso"
      ;;
    "win2008r2" | "win2008r2-eval" )
      sum="dfd9890881b7e832a927c38310fb415b7ea62ac5a896671f2ce2a111998f0df8"
      url="$host/server/2008r2/en_windows_server_2008_r2_with_sp1_${PLATFORM,,}_dvd_617601-018.iso"
      ;;
    "win7${PLATFORM,,}" | "win7${PLATFORM,,}-enterprise" )
      sum="ee69f3e9b86ff973f632db8e01700c5724ef78420b175d25bae6ead90f6805a7"
      url="$host/7/en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"
      ;;
    "win7${PLATFORM,,}-ultimate" )
      sum="0b738b55a5ea388ad016535a5c8234daf2e5715a0638488ddd8a228a836055a1"
      url="$host/7/en_windows_7_with_sp1_${PLATFORM,,}.iso"
      ;;
    "winvista${PLATFORM,,}-ultimate" )
      sum="edf9f947c5791469fd7d2d40a5dcce663efa754f91847aa1d28ed7f585675b78"
      url="$host/vista/en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
      ;;
    "winxpx86" )
      sum="62b6c91563bad6cd12a352aa018627c314cfc5162d8e9f8af0756a642e602a46"
      url="$host/xp/professional/en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso"
      ;;
    "winxpx64" )
      sum="8fac68e1e56c64ad9a2aa0ad464560282e67fa4f4dd51d09a66f4e548eb0f2d6"
      url="$host/xp/professional/en_win_xp_pro_${PLATFORM,,}_vl.iso" 
      ;;
  esac

  [ -z "$ret" ] && echo "$url" || echo "$sum"
  return 0
}

getLink2() {

  local id="$1"
  local ret="$2"
  local url=""
  local sum=""
  local host="https://files.dog/MSDN"

  case "${id,,}" in
    "win81${PLATFORM,,}" )
      sum="d8333cf427eb3318ff6ab755eb1dd9d433f0e2ae43745312c1cd23e83ca1ce51"
      url="$host/Windows%208.1%20with%20Update/en_windows_8.1_with_update_${PLATFORM,,}_dvd_6051480.iso"
      ;;
    "win81${PLATFORM,,}-enterprise" | "win81${PLATFORM,,}-enterprise-eval" )
      sum="c3c604c03677504e8905090a8ce5bb1dde76b6fd58e10f32e3a25bef21b2abe1"
      url="$host/Windows%208.1%20with%20Update/en_windows_8.1_enterprise_with_update_${PLATFORM,,}_dvd_6054382.iso"
      ;;
    "win2012r2" | "win2012r2-eval" )
      sum="f351e89eb88a96af4626ceb3450248b8573e3ed5924a4e19ea891e6003b62e4e"
      url="$host/Windows%20Server%202012%20R2%20with%20Update/en_windows_server_2012_r2_with_update_${PLATFORM,,}_dvd_6052708.iso"
      ;;
    "win2008r2" | "win2008r2-eval" )
      sum="dfd9890881b7e832a927c38310fb415b7ea62ac5a896671f2ce2a111998f0df8"
      url="$host/Windows%20Server%202008%20R2/en_windows_server_2008_r2_with_sp1_${PLATFORM,,}_dvd_617601.iso"
      ;;
    "win7${PLATFORM,,}" | "win7${PLATFORM,,}-enterprise" )
      sum="ee69f3e9b86ff973f632db8e01700c5724ef78420b175d25bae6ead90f6805a7"
      url="$host/Windows%207/en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"
      ;;
    "win7${PLATFORM,,}-ultimate" )
      sum="36f4fa2416d0982697ab106e3a72d2e120dbcdb6cc54fd3906d06120d0653808"
      url="$host/Windows%207/en_windows_7_ultimate_with_sp1_${PLATFORM,,}_dvd_u_677332.iso"
      ;;
    "winvista${PLATFORM,,}" | "winvista${PLATFORM,,}-enterprise" )
      sum="0a0cd511b3eac95c6f081419c9c65b12317b9d6a8d9707f89d646c910e788016"
      url="$host/Windows%20Vista/en_windows_vista_enterprise_sp2_${PLATFORM,,}_dvd_342332.iso"
      ;;
    "winvista${PLATFORM,,}-ultimate" )
      sum="edf9f947c5791469fd7d2d40a5dcce663efa754f91847aa1d28ed7f585675b78"
      url="$host/Windows%20Vista/en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
      ;;
    "winxpx86" )
      sum="62b6c91563bad6cd12a352aa018627c314cfc5162d8e9f8af0756a642e602a46"
      url="$host/Windows%20XP/en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso"
      ;;
    "winxpx64" )
      sum="8fac68e1e56c64ad9a2aa0ad464560282e67fa4f4dd51d09a66f4e548eb0f2d6"
      url="$host/Windows%20XP/en_win_xp_pro_${PLATFORM,,}_vl.iso"
      ;;
  esac

  [ -z "$ret" ] && echo "$url" || echo "$sum"
  return 0
}

getLink3() {

  local id="$1"
  local ret="$2"
  local url=""
  local sum=""
  local host="https://file.cnxiaobai.com/Windows"

  case "${id,,}" in
    "core11" )
      sum="78f0f44444ff95b97125b43e560a72e0d6ce0a665cf9f5573bf268191e5510c1"
      url="$host/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny11%20core%20${PLATFORM,,}%20beta%201.iso"
      ;;
    "tiny11" )
      sum="a028800a91addc35d8ae22dce7459b67330f7d69d2f11c70f53c0fdffa5b4280"
      url="$host/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny11%202311%20${PLATFORM,,}.iso"
      ;;
    "tiny10" )
      sum="a11116c0645d892d6a5a7c585ecc1fa13aa66f8c7cc6b03bf1f27bd16860cc35"
      url="$host/%E7%B3%BB%E7%BB%9F%E5%AE%89%E8%A3%85%E5%8C%85/Tiny%2010_11/tiny10%2023H2%20${PLATFORM,,}.iso"
      ;;
  esac

  [ -z "$ret" ] && echo "$url" || echo "$sum"
  return 0
}

getLink4() {

  # Fallbacks for users who cannot connect to the Microsoft servers

  local id="$1"
  local ret="$2"
  local url=""
  local sum=""
  local host="https://drive.massgrave.dev"

  case "${id,,}" in
    "win11${PLATFORM,,}" )
      sum="a6c21313210182e0315054789a2b658b77394d5544b69b5341075492f89f51e5"
      url="$host/en-us_windows_11_consumer_editions_version_23h2_updated_april_2024_${PLATFORM,,}_dvd_d986680b.iso"
      ;;
    "win11${PLATFORM,,}-enterprise" | "win11${PLATFORM,,}-enterprise-eval" )
      sum="3d4d388d6ffa371956304fa7401347b4535fd10e3137978a8f7750b790a43521"
      url="$host/en-us_windows_11_business_editions_version_23h2_updated_april_2024_${PLATFORM,,}_dvd_349cd577.iso"
      ;;
    "win11${PLATFORM,,}-iot" | "win11${PLATFORM,,}-enterprise-iot-eval" )
      sum="5d9b86ad467bc89f488d1651a6c5ad3656a7ea923f9f914510657a24c501bb86"
      url="$host/en-us_windows_11_iot_enterprise_version_23h2_${PLATFORM,,}_dvd_fb37549c.iso"
      ;;
    "win10${PLATFORM,,}" )
      sum="b072627c9b8d9f62af280faf2a8b634376f91dc73ea1881c81943c151983aa4a"
      url="$host/en-us_windows_10_consumer_editions_version_22h2_updated_april_2024_${PLATFORM,,}_dvd_9a92dc89.iso"
      ;;
    "win10${PLATFORM,,}-enterprise" | "win10${PLATFORM,,}-enterprise-eval" )
      sum="05fe9de04c2626bd00fbe69ad19129b2dbb75a93a2fe030ebfb2256d937ceab8"
      url="$host/en-us_windows_10_business_editions_version_22h2_updated_april_2024_${PLATFORM,,}_dvd_c00090a7.iso"
      ;;
    "win10${PLATFORM,,}-iot" | "win10${PLATFORM,,}-enterprise-iot-eval" )
      sum="a0334f31ea7a3e6932b9ad7206608248f0bd40698bfb8fc65f14fc5e4976c160"
      url="$host/en-us_windows_10_iot_enterprise_ltsc_2021_${PLATFORM,,}_dvd_257ad90f.iso"
      ;;
    "win10${PLATFORM,,}-ltsc" | "win10${PLATFORM,,}-enterprise-ltsc-eval" )
      sum="c90a6df8997bf49e56b9673982f3e80745058723a707aef8f22998ae6479597d"
      url="$host/en-us_windows_10_enterprise_ltsc_2021_${PLATFORM,,}_dvd_d289cf96.iso"
      ;;
    "win81${PLATFORM,,}-enterprise" | "win81${PLATFORM,,}-enterprise-eval" )
      sum="c3c604c03677504e8905090a8ce5bb1dde76b6fd58e10f32e3a25bef21b2abe1"
      url="$host/en_windows_8.1_enterprise_with_update_${PLATFORM,,}_dvd_6054382.iso"
      ;;
    "win2022" | "win2022-eval" )
      sum="7f41d603224e8a0bf34ba957d3abf0a02437ab75000dd758b5ce3f050963e91f"
      url="$host/en-us_windows_server_2022_updated_april_2024_${PLATFORM,,}_dvd_164349f3.iso"
      ;;
    "win2019" | "win2019-eval" )
      sum="4c5dd63efee50117986a2e38d4b3a3fbaf3c1c15e2e7ea1d23ef9d8af148dd2d"
      url="$host/en_windows_server_2019_${PLATFORM,,}_dvd_4cb967d8.iso"
      ;;
    "win2016" | "win2016-eval" )
      sum="4caeb24b661fcede81cd90661aec31aa69753bf49a5ac247253dd021bc1b5cbb"
      url="$host/en_windows_server_2016_${PLATFORM,,}_dvd_9327751.iso"
      ;;
    "win2012r2" | "win2012r2-eval" )
      sum="f351e89eb88a96af4626ceb3450248b8573e3ed5924a4e19ea891e6003b62e4e"
      url="$host/en_windows_server_2012_r2_with_update_${PLATFORM,,}_dvd_6052708.iso"
      ;;
    "win2008r2" | "win2008r2-eval" )
      sum="dfd9890881b7e832a927c38310fb415b7ea62ac5a896671f2ce2a111998f0df8"
      url="$host/en_windows_server_2008_r2_with_sp1_${PLATFORM,,}_dvd_617601.iso"
      ;;
    "win7${PLATFORM,,}" | "win7${PLATFORM,,}-enterprise" )
      sum="ee69f3e9b86ff973f632db8e01700c5724ef78420b175d25bae6ead90f6805a7"
      url="$host/en_windows_7_enterprise_with_sp1_${PLATFORM,,}_dvd_u_677651.iso"
      ;;
    "win7${PLATFORM,,}-ultimate" )
      sum="36f4fa2416d0982697ab106e3a72d2e120dbcdb6cc54fd3906d06120d0653808"
      url="$host/en_windows_7_ultimate_with_sp1_${PLATFORM,,}_dvd_u_677332.iso"
      ;;
    "winvista${PLATFORM,,}" | "winvista${PLATFORM,,}-enterprise" )
      sum="0a0cd511b3eac95c6f081419c9c65b12317b9d6a8d9707f89d646c910e788016"
      url="$host/en_windows_vista_enterprise_sp2_${PLATFORM,,}_dvd_342332.iso"
      ;;
    "winvista${PLATFORM,,}-ultimate" )
      sum="edf9f947c5791469fd7d2d40a5dcce663efa754f91847aa1d28ed7f585675b78"
      url="$host/en_windows_vista_sp2_${PLATFORM,,}_dvd_342267.iso"
      ;;
  esac

  [ -z "$ret" ] && echo "$url" || echo "$sum"
  return 0
}

getLink5() {

  local id="$1"
  local ret="$2"
  local url=""
  local sum=""
  local host="https://archive.org/download"

  case "${id,,}" in
    "core11" )
      sum="78f0f44444ff95b97125b43e560a72e0d6ce0a665cf9f5573bf268191e5510c1"
      url="$host/tiny-11-core-x-64-beta-1/tiny11%20core%20${PLATFORM,,}%20beta%201.iso"
      ;;
    "tiny11" )
      sum="a028800a91addc35d8ae22dce7459b67330f7d69d2f11c70f53c0fdffa5b4280"
      url="$host/tiny11-2311/tiny11%202311%20${PLATFORM,,}.iso"
      ;;
    "tiny10" )
      sum="a11116c0645d892d6a5a7c585ecc1fa13aa66f8c7cc6b03bf1f27bd16860cc35"
      url="$host/tiny-10-23-h2/tiny10%20${PLATFORM,,}%2023h2.iso"
      ;;
    "winxpx86" )
      sum="62b6c91563bad6cd12a352aa018627c314cfc5162d8e9f8af0756a642e602a46"
      url="$host/XPPRO_SP3_ENU/en_windows_xp_professional_with_service_pack_3_x86_cd_x14-80428.iso"
      ;;
  esac

  [ -z "$ret" ] && echo "$url" || echo "$sum"
  return 0
}

getLink() {

  local url=""
  local id="$2"
  local func="getLink$1"

  if [ "$1" -gt 0 ] && [ "$1" -le "$MIRRORS" ]; then
    url=$($func "$id" "")
  fi

  echo "$url"
  return 0
}

getHash() {

  local sum=""
  local id="$2"
  local func="getLink$1"

  if [ "$1" -gt 0 ] && [ "$1" -le "$MIRRORS" ]; then
    sum=$($func "$id" "sum")
  fi

  echo "$sum"
  return 0
}

validVersion() {

  local id="$1"
  local url

  isESD "$id" && return 0
  isMido "$id" && return 0

  for ((i=1;i<=MIRRORS;i++)); do

    url=$(getLink "$i" "$id")
    [ -n "$url" ] && return 0

  done

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

  if [ ! -f "$target/TXTSETUP.SIF" ]; then
    error "The file TXTSETUP.SIF could not be found!" && return 1
  fi

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

  local key pid setup
  setup=$(find "$target" -maxdepth 1 -type f -iname setupp.ini | head -n 1)
  pid=$(<"$setup")
  pid="${pid:(-4)}"
  pid="${pid:0:3}"

  if [[ "$pid" == "270" ]]; then
    info "Warning: this XP version requires a volume license, it will reject the generic key during installation."
  fi

  if [[ "${arch,,}" == "x86" ]]; then
    # Windows XP Professional x86 generic key (no activation, trial-only)
    # This is not a pirated key, it comes from the official MS documentation.
    key="DR8GV-C8V6J-BYXHG-7PYJR-DB66Y"
  else
    # Windows XP Professional x64 generic key (no activation, trial-only)
    # This is not a pirated key, it comes from the official MS documentation.
    key="B2RBK-7KPT9-4JP6X-QQFWM-PJD6G"
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
  ETFS="[BOOT]/Boot-NoEmul.img"

  [[ "$MANUAL" == [Yy1]* ]] && return 0
  configXP "$dir" && return 0

  return 1
}

prepareLegacy() {

  local iso="$1"
  local dir="$2"

  ETFS="boot.img"
  rm -f "$dir/$ETFS"

  local len offset
  len=$(isoinfo -d -i "$iso" | grep "Nsect " | grep -o "[^ ]*$")
  offset=$(isoinfo -d -i "$iso" | grep "Bootoff " | grep -o "[^ ]*$")

  dd "if=$iso" "of=$dir/$ETFS" bs=2048 "count=$len" "skip=$offset" status=none && return 0

  return 1
}

return 0
