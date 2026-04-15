[![Magisk](https://img.shields.io/badge/Magisk-27.0+-green.svg)](https://github.com/topjohnwu/Magisk)
[![Android](https://img.shields.io/badge/Android-12+-blue.svg)](https://www.android.com)
[![Device](https://img.shields.io/badge/Device-Moto_G24-orange.svg)](https://motorola.com)

# 👨🏻‍💻 BuSy
BuSy traz comandos Linux para o Android de forma segura usando Magisk (systemless),
evitando modificações diretas no sistema e reduzindo riscos de bootloop.

---
# ⚠️ Aviso

Este módulo é voltado para usuários avançados.

É necessário conhecimento básico de:

- Magisk
- Android (systemless / root)
- comandos Linux

O uso incorreto pode causar instabilidade no sistema.

---

## 📱 Compatibilidade
Suporte para diferentes arquiteturas:

| **Archs** | **Tipo de Arquivo** |
| :--- | :--- |
| arm64-v8a | arm64 |
| armeabi / armeabi-v7a / armv7l | arm |
| x86_64 | x86_64 |
| x86 | x86 |

---

## ⚙️ Níveis de instalação
BuSy conta com 3 níveis de instalação sendo **Full**, **Medium**, **Small**

---

> [!NOTE]
> Use os botões de **Volume Up** ou **Volume Down** durante a instalação para escolher o nível (Full, Medium ou Small).

> [!IMPORTANT]
> O nível **Full** remove automaticamente comandos conflitantes para garantir que seu Android não entre em Bootloop.

---

1. Full - todos os comandos disponíveis no busybox menos aqueles que causam crash do sistema 
`su sh init adb surfaceflinger logcat logger chcon getcon setenforce getenforce getprop setprop load_policy insmod rmmod lsmod kill logd start stop am pm monkey wm reboot poweroff swapon swapoff service toolbox toybox cmd dumpsys killall uptime watch ps top free resetprop powertop`
2. Medium - só o Essencial
`ash chrt taskset renice ionice vi nano cat less more head tail cp mv rm mkdir rmdir touch ln ls find grep sed awk wc sort uniq cut tr df du free kill mount umount ping wget curl tar gzip gunzip zip unzip date sleep which whoami id export unset`
3. Small - foca mais para um complemento ao meu modulo [GameHub-PRO-X](https://github.com/inrryoff/GameHub-PRO-X.V3) adicionando apenas estes 5 comandos: `ash taskset chrt renice ionice`

---

## 🚀 Instalação

1. Baixe o arquivo ".zip" do módulo
2. Abra o Magisk
3. Vá em Módulos
4. Toque em Instalar pelo armazenamento
5. Selecione o arquivo do BuSy
6. Durante a instalação:
   - 🔼 Volume Up → Full
   - 🔽 Volume Down → Small
   - ⏱️ Aguardar → Medium (padrão)
7. Reinicie o dispositivo

---

## Créditos e Licença
- **Scripts do Módulo:** Licença MIT © [inrryoff/BuSy](https://github.com/inrryoff)
- **Binário BusyBox:** Licença GNU GPLv2
  - Criador Original: **Erik Andersen**
  - Mantenedor Atual: **Denys Vlasenko**
  - Site Oficial: [busybox.net](https://busybox.net)
  - Fonte do Binário: [meefik/busybox](https://github.com/meefik/busybox)
