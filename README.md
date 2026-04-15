[![Magisk](https://img.shields.io/badge/Magisk-27.0+-green.svg)](https://github.com/topjohnwu/Magisk)
[![Android](https://img.shields.io/badge/Android-12+-blue.svg)](https://www.android.com)
[![Device](https://img.shields.io/badge/Device-Moto_G24-orange.svg)](https://motorola.com)

# 👨🏻‍💻 BuSy
BuSy é um modulo Magisk que visa implementar os comandos do Linux no Android de forma segura pelo Magisk com seu sistema de montagem Systemless

---

## compatibilidade
o BuSy tem compatibilidade com diferentes arquiteturas

| **Archs** | **Tipo de Arquivo** |
| :--- | :--- |
| arm64-v8a | arm64 |
| armeabi / armeabi-v7a / armv7l | arm |
| x86_64 | x86_64 |
| x86 | x86 |

---

## BuSy também
BuSy conta com 3 niveis de instalação sendo Full, Medium, Small

---

> [!NOTE]
> Use os botões de **Volume Up** ou **Volume Down** durante a instalação para escolher o nível (Full, Medium ou Small).

> [!IMPORTANT]
> O nível **Full** remove automaticamente comandos conflitantes para garantir que seu Android não entre em Bootloop.

---

1. Full -todos os comandos disponíveis no busybox menos aqueles que causam crash do sistema 
`su sh init adb surfaceflinger logcat logger chcon getcon setenforce getenforce getprop setprop load_policy insmod rmmod lsmod kill logd start stop am pm monkey wm reboot poweroff swapon swapoff service toolbox toybox cmd dumpsys killall uptime watch ps top free resetprop powertop`
2. Medium só o Essencial
`ash chrt taskset renice ionice vi nano cat less more head tail cp mv rm mkdir rmdir touch ln ls find grep sed awk wc sort uniq cut tr df du free ps kill mount umount ping wget curl tar gzip gunzip zip unzip date sleep which whoami id env export unset`
3. Small foca mais para um complemento ao meu modulo [GameHub-PRO-X](https://github.com/inrryoff/GameHub-PRO-X.V3) adicionando apenas estes 5 comandos: `ash taskset chrt renice ionice`

---

## Créditos e Licença
- **Scripts do Módulo:** Licença MIT © [inrryoff/BuSy](https://github.com/inrryoff)
- **Binário BusyBox:** Licença GNU GPLv2
  - Criador Original: **Erik Andersen**
  - Mantenedor Atual: **Denys Vlasenko**
  - Site Oficial: [busybox.net](https://busybox.net)
  - Fonte do Binário: [meefik/busybox](https://github.com/meefik/busybox)
