Шаблонизация
Написать helm chart приложения, включая обработку ингресса любого домена и монтирование директории на ноде узла;
Задеплоить на EKS кластер.

Мониторинг
Настроить набольшой мониторинга эндпоинта на базе BlackBox Exporter в кластере
Добавить Prometheus/VMAgent для сбора состояния.

Для запуска helm chart-a используйте команду 
```
helm install myapp .

```
Затем установите Prometheus с использованием этого файла значений:
```
helm install prometheus prometheus-community/kube-prometheus-stack -f values.yaml
```
```
helm repo update
```
Установите kube-prometheus-stack из Helm чарта:
```
helm install prometheus prometheus-community/kube-prometheus-stack
```

Проверка результатов мониторинга
Убедитесь, что все ресурсы успешно созданы и запущены:

```
kubectl get pods -n <namespace>
```
```
kubectl get servicemonitors -n <namespace>
```
Просмотр метрик Blackbox Exporter:После применения конфигурации, проверьте метрики Blackbox Exporter, перейдя на веб-интерфейс Prometheus. Используйте port-forwarding для доступа к веб-интерфейсу:
```
kubectl port-forward -n <namespace> service/prometheus-kube-prometheus-prometheus <local_port>:9090
```
Затем откройте браузер и перейдите по адресу http://localhost:<local_port>.
