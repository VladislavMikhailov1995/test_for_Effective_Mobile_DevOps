# 🔍 Test Process Monitoring Script (systemd + bash)

Скрипт и systemd-юниты для автоматического мониторинга процесса `test` в Linux. Решение запускается при старте системы и проверяет состояние процесса каждую минуту.

---

## 📋 Что делает

- Проверяет, запущен ли процесс с именем `test`.
- Если процесс активен — отправляет HTTPS-запрос на `https://test.com/monitoring/test/api`.
- Если процесс был перезапущен — записывает в лог `/var/log/monitoring.log`.
- Если сервер мониторинга недоступен — также логирует событие.

---

## 🗂️ Состав репозитория

monitor_test.sh # основной bash-скрипт мониторинга
monitor-test.service # systemd unit для запуска скрипта
monitor-test.timer # systemd таймер для запуска сервиса каждую минуту

---

## ⚙️ Установка

1. Скопируйте файлы:
   ```bash
   sudo cp monitor_test.sh /usr/local/bin/
   sudo chmod +x /usr/local/bin/monitor_test.sh

   sudo cp monitor-test.service /etc/systemd/system/
   sudo cp monitor-test.timer /etc/systemd/system/

2. Перезапустите systemd и активируйте таймер:
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable --now monitor-test.timer

3. Проверить работу:
   ```bash
   systemctl status monitor-test.timer
   journalctl -u monitor-test.service

## 📄 Пример логов (/var/log/monitoring.log)

2025-06-24 10:00:01 - Обнаружен запуск процесса test. PID: 1245
2025-06-24 10:01:01 - Процесс test был перезапущен. Новый PID: 1302
2025-06-24 10:03:01 - Сервер мониторинга https://test.com/monitoring/test/api недоступен.

## ✅ Требования

Linux-система с systemd
curl установлен в системе
Права администратора (sudo)

## 📌 Примечания

Файл PID хранится в /var/run/monitor_test.pid.
Все логи пишутся в /var/log/monitoring.log.
Если процесс test не запущен — скрипт ничего не делает.
