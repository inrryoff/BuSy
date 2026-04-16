[![Magisk](https://img.shields.io/badge/Magisk-27.0+-green.svg)](https://github.com/topjohnwu/Magisk)
[![Android](https://img.shields.io/badge/Android-12+-blue.svg)](https://www.android.com)
[![Device](https://img.shields.io/badge/Device-Moto_G24-orange.svg)](https://motorola.com)

# 👨🏻‍💻 BuSy
BuSy traz comandos Linux para o Android de forma segura usando Magisk (systemless),
evitando modificações diretas no sistema e reduzindo riscos de bootloop.

---
## ⚠️ Aviso

Este módulo é voltado para usuários avançados.

É necessário conhecimento básico de:

- Magisk
- Android (systemless / root)
- comandos Linux

O uso incorreto pode causar instabilidade no sistema.

---

## 📦 Estrutura

O módulo utiliza montagem systemless via Magisk para injetar os binários no sistema sem modificar partições reais.

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

### Full
Todos os comandos disponíveis (exceto os que causam conflito)

```md
    REMOVER="
        su sh init adb surfaceflinger logcat
        logger chcon getcon setenforce
        getenforce getprop setpropload_policy
        insmod rmmod lsmod kill logd start
        stop am pm monkey wm reboot poweroff
        swapon swapoff service toolbox toybox
        cmd dumpsys killall uptime watch df ps
        top tar free resetprop powertop
    "
```

### Medium
Apenas comandos essenciais do **busybox**

```md
    CMDS="
        ash chrt taskset renice ionice vi nano
        cat less more head tail cp mv rm mkdir
        rmdir touch ln ls find grep sed awk wc
        sort uniq cut tr df du free kill mount
        umount ping wget curl tar gzip gunzip
        zip unzip date sleep which whoami id
        export unset
    "
```
### Small
Focado como complemento para o módulo [GameHub-PRO-X](https://github.com/inrryoff/GameHub-PRO-X.V3) adicionando apenas estes 5 comandos:
```md
ash taskset chrt renice ionice
```
---

## 🚀 instalação
1. Baixe o arquivo ".zip" do módulo.
2. Abra o [Magisk](https://github.com/topjohnwu/magisk/releases)
3. Vá na aba de módulos 
4. Toque em Instalar pelo armazenamento
5. Selecione o arquivo do BuSy

## 🆕 Guia de Instalação da versão 3+
**🎮 Controles:**
  - **Volume + :** Alternar entre Full, Medium ou Small
  - **Volume - :** Confirmar escolha

**🛠️ Botão Action:**
  - Logs detalhados e acesso rápido ao GitHub pós-instalação.
6. Reinicie o dispositivo.

---

## 📄 Licença

- Scripts: MIT  
- BusyBox: GPLv2  

## 🙏 Créditos
- Criador Original: **Erik Andersen**
- Mantenedor Atual: **Denys Vlasenko**
- Fonte do Binário: [meefik/busybox](https://github.com/meefik/busybox)
- Site Oficial: [busybox.net](https://busybox.net)
