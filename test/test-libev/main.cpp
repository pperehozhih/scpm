#include <ev++.h>
#include <stdio.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <unistd.h>
#include <string.h>

// Callback-функция для обработки событий при подключении клиента
static void client_cb(struct ev_loop *loop, struct ev_io *watcher, int revents) {
    if (EV_ERROR & revents) {
        perror("got invalid event");
        return;
    }

    char buffer[1024];
    ssize_t read_size;
    // Чтение данных от клиента
    if ((read_size = recv(watcher->fd, buffer, sizeof(buffer), 0)) < 0) {
        perror("read error");
        return;
    }

    if (read_size == 0) {
        // Клиент закрыл соединение, удаляем watcher и закрываем сокет
        ev_io_stop(loop, watcher);
        close(watcher->fd);
        free(watcher);
        printf("Client disconnected.\n");
        return;
    }

    // Вывод полученных данных на стандартный вывод
    printf("Received message from client: %.*s", (int)read_size, buffer);
}

int main() {
    struct ev_loop *loop = EV_DEFAULT;
    struct sockaddr_in addr;
    int sockfd;

    // Создание TCP сокета
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        return 1;
    }

    // Задание параметров адреса сервера
    memset(&addr, 0, sizeof(addr));
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(12345);

    // Привязка сокета к адресу
    if (bind(sockfd, (struct sockaddr *)&addr, sizeof(addr)) != 0) {
        perror("bind failed");
        close(sockfd);
        return 1;
    }

    // Установка сокета в режим прослушивания
    if (listen(sockfd, SOMAXCONN) != 0) {
        perror("listen failed");
        close(sockfd);
        return 1;
    }

    // Инициализация структуры watcher для серверного сокета
    struct ev_io *accept_watcher = (struct ev_io *)malloc(sizeof(struct ev_io));
    ev_io_init(accept_watcher, client_cb, sockfd, EV_READ);
    ev_io_start(loop, accept_watcher);

    printf("Server started. Listening on port 12345.\n");

    // Запуск цикла обработки событий
    ev_run(loop, 0);

    // Очистка памяти и завершение работы
    close(sockfd);
    free(accept_watcher);
    ev_loop_destroy(loop);

    return 0;
}
