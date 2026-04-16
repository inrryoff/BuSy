#!/system/bin/sh
export PATH=/system/bin:/system/xbin:/vendor/bin:$PATH

SKIPUNZIP=0

MODID=${MODID:-"Custom_BuSy"}
MODPATH=${MODPATH:-"/data/adb/modules/$MODID"}
BIN="$MODPATH/system/bin"

ARCH=$(getprop ro.product.cpu.abi)
ui_print "🔍 Detectando arquitetura: $ARCH"

case $ARCH in
    arm64-v8a)
        BUSY_PATH="$MODPATH/busy/busybox_arm64"
        ;;
    armeabi-v7a|armeabi|armv7l)
        BUSY_PATH="$MODPATH/busy/busybox_arm"
        ;;
    x86_64)
        BUSY_PATH="$MODPATH/busy/busybox_x86_64"
        ;;
    x86)
        BUSY_PATH="$MODPATH/busy/busybox_x86"
        ;;
    *)
        ui_print "❌ Arquitetura não suportada: $ARCH"
        exit 1
        ;;
esac

FILE="$BUSY_PATH"
BU=$(basename "$FILE")

# Corrigido: verificação correta do arquivo
if [ ! -f "$FILE" ]; then
    ui_print "❌ Erro: $BU não encontrado!"
    exit 1
fi

chmod 755 "$FILE"

BUV=$("$FILE" --help 2>&1 | head -n 1 | awk '{print $2}')

ui_print " "
ui_print "  _____       _____       "
ui_print " |  _  | _ _ |   __| _ _  "
ui_print " |  _  || | ||__   || | | "
ui_print " |__|__||___||_____||_  | "
ui_print "                    |___| "
ui_print "    BY: @INRRYOFF         "
ui_print " "

# ============================================================
# FUNÇÃO DE ESCOLHAS
# ============================================================
choose_option() {
    local choice=2
    local total_options=3
    local timeout=5
    
    ui_print "  [ VOL+ : Trocar Opcao | VOL- : Confirmar ]"
    ui_print "  Pressione qualquer tecla para modo manual..."
    
    while [ $timeout -gt 0 ]; do
        ui_print "  ⏳ Padrao (Medium) em: $timeout..."
        local key=$(timeout 1 getevent -qlc 1 2>/dev/null | awk '{print $3}')
        [ ! -z "$key" ] && [ "$key" != "0000" ] && break
        timeout=$((timeout - 1))
    done

    [ $timeout -eq 0 ] && return 2

    ui_print " "
    ui_print "  -> MODO MANUAL ATIVADO"
    ui_print "  (Clique VOL+ para girar as opcoes)"
    
    getevent -ql | while read line; do
        echo "$line" | grep -q "KEY_VOLUME" || continue
        echo "$line" | grep -q " DOWN" || continue

        if echo "$line" | grep -q "KEY_VOLUMEUP"; then
            choice=$((choice + 1))
            [ $choice -gt $total_options ] && choice=1
            
            ui_print "     Selecionado: $choice" 
            
        elif echo "$line" | grep -q "KEY_VOLUMEDOWN"; then
            echo "$choice" > /tmp/busy_choice
            pkill getevent
            break
        fi
    done

    local final_choice=$(cat /tmp/busy_choice)
    rm -f /tmp/busy_choice
    
    ui_print " "
    case $final_choice in
        1) ui_print "  ✅ ESCOLHIDO: FULL BUSYBOX" ;;
        2) ui_print "  ✅ ESCOLHIDO: MEDIUM BUSYBOX" ;;
        3) ui_print "  ✅ ESCOLHIDO: SMALL BUSYBOX" ;;
    esac
    
    return $final_choice
}

# ============================================================
# MENU DE ESCOLHA
# ============================================================
escolher_versao() {
    ui_print "═══════════════════════════════════════"
    ui_print "       BuSy - Opções de Instalação"
    ui_print "═══════════════════════════════════════"
    ui_print "  1. FULL   | 2. MEDIUM (Auto) | 3. SMALL"
    ui_print "═══════════════════════════════════════"
    
    choose_option
    return $?
}

# ============================================================
# INSTALAÇÃO MEDIUM
# ============================================================
instalar_medium() {
    ui_print ""
    ui_print "🔰 Instalando MEDIUM BuSy..."
    
    # Garantir que diretório existe
    mkdir -p "$BIN"
    cd "$BIN" || exit 1
    
    CMDS="
        ash chrt taskset renice ionice vi nano
        cat less more head tail cp mv rm mkdir
        rmdir touch ln ls find grep sed awk wc
        sort uniq cut tr df du free kill mount
        umount ping wget curl tar gzip gunzip
        zip unzip date sleep which whoami id
        export unset
    "
    
    for cmd in $CMDS; do
        ln -sf "$FILE" "$cmd"
    done
    
    TOTAL_CMDS=$(ls -1 | wc -l)
    ui_print "✅ MEDIUM BuSy instalado ($TOTAL_CMDS comandos)"
    echo "$TOTAL_CMDS" > /tmp/total_cmds_installed
}

# ============================================================
# INSTALAÇÃO SMALL
# ============================================================
instalar_small() {
    ui_print ""
    ui_print "🍥 Instalando SMALL BuSy..."
    
    mkdir -p "$BIN"
    cd "$BIN" || exit 1
    
    CMDS="
        ash taskset chrt renice ionice
    "

    for cmd in $CMDS; do
        ln -sf "$FILE" "$cmd"
    done
    
    TOTAL_CMDS=$(ls -1 | wc -l)
    ui_print "✅ SMALL BuSy instalado ($TOTAL_CMDS comandos)"
    echo "$TOTAL_CMDS" > /tmp/total_cmds_installed
}

# ============================================================
# INSTALAÇÃO FULL
# ============================================================
instalar_full() {
    ui_print ""
    ui_print "🚀 Instalando FULL BuSy..."

    mkdir -p "$BIN"
    cd "$BIN" || exit 1
    "$FILE" --install -s .
    
    REMOVER="
        su sh init adb surfaceflinger logcat
        logger chcon getcon setenforce
        getenforce getprop setprop load_policy
        insmod rmmod lsmod kill logd start
        stop am pm monkey wm reboot poweroff
        swapon swapoff service toolbox toybox
        cmd dumpsys killall uptime watch df ps
        top tar free resetprop powertop
    "
    
    for cmd in $REMOVER; do
        rm -f "$cmd"
    done
    
    TOTAL_CMDS=$(ls -1 | wc -l)
    ui_print "✅ FULL BuSy instalado"
    ui_print "📦 Comandos disponíveis: $TOTAL_CMDS"
    echo "$TOTAL_CMDS" > /tmp/total_cmds_installed
}

# ============================================================
# CRIA DIRETÓRIOS
# ============================================================
mkdir -p "$MODPATH/busy"
mkdir -p "$BIN"

# ============================================================
# EXECUTA
# ============================================================
escolher_versao
CHOICE=$?

# Determinar nome da versão
case $CHOICE in
    1) VERSAO="FULL" ;;
    2) VERSAO="MEDIUM" ;;
    3) VERSAO="SMALL" ;;
    *) VERSAO="MEDIUM (default)" ;;
esac

case $CHOICE in
    1) instalar_full ;;
    2) instalar_medium ;;
    3) instalar_small ;;
    *) instalar_medium ;;
esac

# Recuperar total de comandos instalados (se disponível)
if [ -f /tmp/total_cmds_installed ]; then
    TOTAL_CMDS=$(cat /tmp/total_cmds_installed)
    rm -f /tmp/total_cmds_installed
else
    TOTAL_CMDS="N/A"
fi

# ============================================================
# resetprop
# ============================================================
if [ -f "/data/adb/magisk/magisk" ]; then
    cat > "$BIN/resetprop" << 'EOF'
#!/system/bin/sh
exec /data/adb/magisk/magisk resetprop "$@"
EOF
    chmod 755 "$BIN/resetprop"
    RESETPROP_STATUS="wrapper"
    ui_print "✅ magisk resetprop configurado (via wrapper)"
elif [ -f "/data/adb/magisk/resetprop" ]; then
    ln -sf /data/adb/magisk/resetprop "$BIN/resetprop"
    RESETPROP_STATUS="symlink"
    ui_print "✅ Magisk resetprop configurado (via link simbólico)"
else
    RESETPROP_STATUS="ausente"
    ui_print "⚠️ Magisk resetprop não configurado (Não critico)"
    ui_print "   Varifique a integridade dos arquivos do Magisk"
fi

if [ ! -f "$BIN/ash" ]; then
    ui_print "⚠️ Aviso: Nenhum comando foi instalado!"
    ui_print "   Verifique se o BusyBox esta funcionando!"
    ASH_PRESENTE="não"
else
    ASH_PRESENTE="sim"
fi

# ============================================================
# REGISTRO DE INSTALAÇÃO
# ============================================================
LOG_FILE="$MODPATH/install.log"

cat > "$LOG_FILE" << EOF
========================================
        BuSy - Registro de Instalação
========================================
Data/Hora      : $(date '+%Y-%m-%d %H:%M:%S')
Versão Escolhida: $VERSAO
Arquitetura    : $ARCH
Binário Usado  : $BU
Versão BusyBox : $BUV
Comandos Instalados: $TOTAL_CMDS
resetprop      : $RESETPROP_STATUS
ASH presente   : $ASH_PRESENTE
Caminho do Módulo: $MODPATH
========================================
EOF

# ============================================================
# FINALIZAÇÃO
# ============================================================
ui_print ""
ui_print "═══════════════════════════════════════"
ui_print "✅ BuSy instalado!"
case $CHOICE in
    1) ui_print "📂 FULL (todos os comandos)" ;;
    2) ui_print "📂 MEDIUM (recomendado)" ;;
    3) ui_print "📂 SMALL (GameHub-PRO-X)" ;;
esac
ui_print "🌐 Dev: @inrryoff"
ui_print "✨ Version: $BUV"
ui_print "📦 BuSy Arch: $BU"
ui_print "═══════════════════════════════════════"