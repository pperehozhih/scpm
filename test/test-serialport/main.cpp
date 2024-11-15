#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <libserialport.h>

#define BUFFER_SIZE 4096

void list_ports() {
    struct sp_port **ports;
    if (sp_list_ports(&ports) != SP_OK) {
        fprintf(stderr, "Не удалось получить список портов\n");
        return;
    }

    printf("Доступные порты:\n");
    for (int i = 0; ports[i] != NULL; i++) {
        printf("- %s\n", sp_get_port_name(ports[i]));
    }

    sp_free_port_list(ports);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        fprintf(stderr, "Использование: %s <имя_порта>\n", argv[0]);
        list_ports();
        return EXIT_FAILURE;
    }

    const char *port_name = argv[1];
    struct sp_port *port;

    // Открываем порт
    if (sp_get_port_by_name(port_name, &port) != SP_OK) {
        fprintf(stderr, "Не удалось найти порт: %s\n", port_name);
        return EXIT_FAILURE;
    }

    if (sp_open(port, SP_MODE_READ_WRITE) != SP_OK) {
        fprintf(stderr, "Не удалось открыть порт: %s\n", port_name);
        sp_free_port(port);
        return EXIT_FAILURE;
    }

    // Настраиваем порт
    sp_set_baudrate(port, 115200);
    sp_set_bits(port, 8);
    sp_set_parity(port, SP_PARITY_NONE);
    sp_set_stopbits(port, 1);
    sp_set_flowcontrol(port, SP_FLOWCONTROL_NONE);

    printf("Ожидание данных из порта %s...\n", port_name);

    // Чтение данных
    char buffer[BUFFER_SIZE];
    while (1) {
        int bytes_read = sp_nonblocking_read(port, buffer, sizeof(buffer) - 1);
        if (bytes_read > 0) {
            buffer[bytes_read] = '\0'; // Завершаем строку
            printf("%s\n", buffer);
        } else if (bytes_read < 0) {
            fprintf(stderr, "Ошибка чтения из порта\n");
            break;
        }
    }

    // Закрываем порт
    sp_close(port);
    sp_free_port(port);
    return EXIT_SUCCESS;
}
