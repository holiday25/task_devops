import threading
import time
from flask import Flask

from ping3 import ping

app = Flask(__name__)

node_status = {'1.1.1.1': False, '8.8.8.8': False}
status_lock = threading.Lock()

# Функция для проверки доступности узлов по ICMP пингу
def check_nodes():
    global node_status

    while True:
        for node in node_status:
            if ping(node, timeout=2) is not None:
                node_status[node] = True
                print(f"Node {node} is reachable")
            else:
                node_status[node] = False
                print(f"Node {node} is not reachable")

        time.sleep(5)

# Запуск функции проверки узлов в отдельном потоке
ping_thread = threading.Thread(target=check_nodes)
ping_thread.daemon = True
ping_thread.start()

@app.route('/health')
def health_check():
    global node_status

    with status_lock:
        if all(node_status.values()):
            return "OK", 200
        else:
            return "Service Unavailable", 503

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
