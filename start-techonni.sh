#!/bin/bash

# Techonni Server Auto-Start Script
# Porta: 8000
# Projeto: techonni-ready

PROJECT_DIR="/Users/oscarpinheiro/techonni-ready"
PID_FILE="$PROJECT_DIR/.server.pid"
LOG_FILE="$PROJECT_DIR/server.log"
PORT=8000

cd "$PROJECT_DIR"

echo "🚀 Techonni Server (Port $PORT)"
echo "================================"

# Função para verificar se o servidor está rodando
check_server() {
    if [ -f "$PID_FILE" ]; then
        PID=$(cat "$PID_FILE")
        if ps -p "$PID" > /dev/null 2>&1; then
            return 0  # Servidor está rodando
        else
            rm -f "$PID_FILE"  # Remove PID file inválido
            return 1  # Servidor não está rodando
        fi
    else
        return 1  # PID file não existe
    fi
}

# Função para iniciar o servidor
start_server() {
    echo "🔄 Iniciando servidor HTTP na porta $PORT..."
    echo "$(date): Iniciando servidor..." >> "$LOG_FILE"
    
    # Inicia servidor Python simples em background
    python3 -m http.server $PORT > "$LOG_FILE" 2>&1 &
    SERVER_PID=$!
    echo $SERVER_PID > "$PID_FILE"
    
    echo "✅ Servidor iniciado com PID: $SERVER_PID"
    echo "🌐 Site disponível em: http://localhost:$PORT"
    echo "📝 Logs salvos em: $LOG_FILE"
}

# Função para parar o servidor
stop_server() {
    if check_server; then
        PID=$(cat "$PID_FILE")
        echo "🛑 Parando servidor (PID: $PID)..."
        kill "$PID" 2>/dev/null
        rm -f "$PID_FILE"
        echo "✅ Servidor parado."
    else
        echo "ℹ️  Servidor não estava rodando."
    fi
}

# Função para reiniciar o servidor
restart_server() {
    stop_server
    sleep 2
    start_server
}

# Processar argumentos
case "${1:-start}" in
    "start")
        if check_server; then
            echo "ℹ️  Servidor já está rodando!"
            PID=$(cat "$PID_FILE")
            echo "🌐 Site disponível em: http://localhost:$PORT (PID: $PID)"
        else
            start_server
        fi
        ;;
    "stop")
        stop_server
        ;;
    "restart")
        restart_server
        ;;
    "status")
        if check_server; then
            PID=$(cat "$PID_FILE")
            echo "✅ Servidor está rodando (PID: $PID)"
            echo "🌐 Site disponível em: http://localhost:$PORT"
        else
            echo "❌ Servidor não está rodando"
        fi
        ;;
    *)
        echo "Uso: $0 {start|stop|restart|status}"
        echo ""
        echo "🚀 Techonni Server Manager"
        echo "  start   - Inicia o servidor na porta $PORT"
        echo "  stop    - Para o servidor"
        echo "  restart - Reinicia o servidor"
        echo "  status  - Mostra status do servidor"
        exit 1
        ;;
esac
