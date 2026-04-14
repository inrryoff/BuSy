#!/system/bin/sh

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

# ============================================================
# FUNÇÃO SIMPLES PARA CAPTURAR BOTÃO
# ============================================================
wait_for_volume() {
    local timeout=5
    ui_print "  ⏳ Aguardando $timeout segundos..."
    
    for i in 1 2 3; do
        if [ -f "/data/adb/magisk/keycheck" ]; then
            local choice=$(/data/adb/magisk/keycheck)
            [ "$choice" = "0" ] && return 0
            [ "$choice" = "1" ] && return 1
        fi
        
        local key=$(getevent -qlc 1 2>/dev/null | awk '{ print $3 }')
        case $key in
            *"KEY_VOLUMEUP"*) return 0 ;;
            *"KEY_VOLUMEDOWN"*) return 1 ;;
        esac
        sleep 0.3
    done
    return 2
}

# ============================================================
# MENU DE ESCOLHA
# ============================================================
escolher_versao() {
    ui_print "═══════════════════════════════════════"
    ui_print "       BuSy - Full, Medium e Small"
    ui_print "═══════════════════════════════════════"
    ui_print ""
    ui_print "  🔼 VOLUME UP   = FULL (todos comandos)"
    ui_print "  🔽 VOLUME DOWN = SMALL (apenas GameHub)"
    ui_print "  ⏱️  Aguardar    = MEDIUM (recomendado)"
    ui_print ""
    
    wait_for_volume
    local key=$?
    
    case $key in
        0)
            ui_print "✅ FULL BuSy selecionado"
            return 1
            ;;
        1)
            ui_print "✅ SMALL BuSy selecionado"
            return 3
            ;;
        *)
            ui_print "✅ MEDIUM BuSy selecionado (padrão)"
            return 2
            ;;
    esac
}

# ============================================================
# INSTALAÇÃO MEDIUM
# ============================================================
instalar_medium() {
    ui_print ""
    ui_print "📦 Instalando MEDIUM BuSy..."
    
    CMDS="ash chrt taskset renice ionice vi nano cat less more head tail cp mv rm mkdir rmdir touch ln ls find grep sed awk wc sort uniq cut tr df du free ps kill mount umount ping wget curl tar gzip gunzip zip unzip date sleep which whoami id env export unset"
    
    for cmd in $CMDS; do
        ln -sf "$FILE" "$BIN/$cmd"
    done
    
    TOTAL_CMDS=$(echo $CMDS | wc -w)
    ui_print "✅ MEDIUM BuSy instalado ($TOTAL_CMDS comandos)"
}

# ============================================================
# INSTALAÇÃO SMALL
# ============================================================
instalar_small() {
    ui_print ""
    ui_print "📦 Instalando SMALL BuSy..."
    
    for cmd in ash taskset chrt renice ionice; do
        ln -sf "$FILE" "$BIN/$cmd"
    done
    
    ui_print "✅ SMALL BuSy instalado (5 comandos)"
}

# ============================================================
# INSTALAÇÃO FULL
# ============================================================
instalar_full() {
    ui_print ""
    ui_print "🚀 Instalando FULL BuSy..."

    cd "$BIN" || exit 1
    "$FILE" --install -s .
    
    REMOVER="
        su sh init adb surfaceflinger logcat logger
        chcon getcon setenforce getenforce getprop setprop
        load_policy insmod rmmod lsmod kill logd 
        start stop am pm monkey wm reboot poweroff
        swapon swapoff service toolbox toybox cmd dumpsys
        killall uptime watch ps top free resetprop powertop 
    "
    
    for cmd in $REMOVER; do
        rm -f "$cmd"
    done
    
    TOTAL_CMDS=$(ls -1 | wc -l)
    ui_print "✅ FULL BuSy instalado"
    ui_print "📦 Comandos disponíveis: $TOTAL_CMDS"
}

# ============================================================
# CRIA DIRETÓRIOS E VERIFICA BINÁRIO
# ============================================================
mkdir -p "$MODPATH/busy"
mkdir -p "$BIN"

if [ ! -f "$FILE" ]; then
    ui_print "❌ Erro: $FILE não encontrado!"
    exit 1
fi

chmod 755 "$FILE"

# ============================================================
# EXECUTA
# ============================================================
escolher_versao
CHOICE=$?

case $CHOICE in
    1) instalar_full ;;
    2) instalar_medium ;;
    3) instalar_small ;;
    *) instalar_medium ;;
esac

# ============================================================
# resetprop
# ============================================================
if [ -f "/data/adb/magisk/magisk" ]; then
    cat > "$BIN/resetprop" << 'EOF'
#!/system/bin/sh
exec /data/adb/magisk/magisk resetprop "$@"
EOF
    chmod 755 "$BIN/resetprop"
    ui_print "✅ magisk resetprop configurado (via wrapper)"
elif [ -f "/data/adb/magisk/resetprop" ]; then
    ln -sf /data/adb/magisk/resetprop "$BIN/resetprop"
    ui_print "✅ Magisk resetprop configurado (via link simbólico)"
else
    ui_print "⚠️ Magisk resetprop não configurado (Não critico)"
    ui_print "   Varifique a integridade dos arquivos do Magisk"
fi

if [ ! -f "$BIN/ash" ]; then
    ui_print "⚠️ Aviso: Nenhum comando foi instalado!"
    ui_print "   Verifique se o BusyBox esta funcionando!"
fi

# ============================================================
# FINALIZA
# ============================================================
ui_print ""
ui_print "═══════════════════════════════════════"
ui_print "✅ BuSy instalado!"
case $CHOICE in
    1) ui_print "📂 FULL (todos os comandos)" ;;
    2) ui_print "📂 MEDIUM (recomendado)" ;;
    3) ui_print "📂 SMALL (GameHub)" ;;
esac
ui_print "🌐 Dev: https://github.com/inrrtoff"
ui_print "═══════════════════════════════════════"
