#!/system/bin/sh
export PATH=/system/bin:/system/xbin:/vendor/bin:$PATH

# Redireciona saída para o console do Magisk
exec > /proc/self/fd/1 2>&1

MODPATH="/data/adb/modules/Custom_BuSy"
LOGFILE="$MODPATH/install.log"

echo "═══════════════════════════════════════"
echo "           BuSy MODULE INFO            "
echo "═══════════════════════════════════════"
echo ""

if [ -f "$LOGFILE" ]; then
    echo "📋 Dados da instalação registrada:"
    echo ""
    grep -E "Data/Hora|Versão Escolhida|Arquitetura|Binário Usado|Versão BusyBox|Comandos Instalados|resetprop|ASH presente" "$LOGFILE" | while read line; do
        echo "   $line"
    done
    echo ""
    
    VERSAO=$(grep "Versão Escolhida" "$LOGFILE" | cut -d: -f2 | xargs)
    echo "✅ Módulo configurado como: $VERSAO"
else
    echo "⚠️  Arquivo de registro não encontrado."
    echo "🏗️  Arquitetura: $(getprop ro.product.cpu.abi)"
    echo "📦 Versão BusyBox: $($MODPATH/busy/busybox* --help 2>/dev/null | head -n 1)"
    echo "📂 Comandos em bin: $(ls $MODPATH/system/bin 2>/dev/null | wc -l)"
fi

sleep 10
echo ""
echo "═══════════════════════════════════════"
echo "🔗 Abrindo GitHub do desenvolvedor..."
echo "═══════════════════════════════════════"
sleep 1
am start -a android.intent.action.VIEW -d "https://github.com/inrryoff/Inrryoff" >/dev/null 2>&1
