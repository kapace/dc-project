#include <vector>
#include <iostream>
#include <unistd.h>
#include <pthread.h>
#include <sys/types.h> 
#include <sys/socket.h>
#include <netinet/in.h>
#include <string.h>
#include <strings.h>
#include <netdb.h>

#include "types.h"

using namespace std;

void error(const char *msg){perror(msg);exit(0);}

int main(int argc, char *argv[])
{
    int sockfd, portno, n;
    struct sockaddr_in serv_addr;
    struct hostent *server;

    if (argc < 4) {
       fprintf(stderr,"usage %s hostname port clientname\n", argv[0]);
       exit(0);
    }
    //// connect
    portno = atoi(argv[2]);
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        error("ERROR opening socket");
    server = gethostbyname(argv[1]);
    if (server == NULL) {
        fprintf(stderr,"ERROR, no such host\n");
        exit(0);
    }
    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy((char *)server->h_addr, 
         (char *)&serv_addr.sin_addr.s_addr,
         server->h_length);
    serv_addr.sin_port = htons(portno);
    
    if (connect(sockfd,(struct sockaddr *) &serv_addr,sizeof(serv_addr)) < 0) 
        error("ERROR connecting");
    // connect.

    player_matchmaking_t p = {0};
    strcpy(p.name, argv[3]);
    p.team = 1;
    p.role = 2;
    p.ready = false;

    n = write(sockfd, &p, sizeof(p));
    if (n < 0) 
         error("ERROR writing to socket");
    p.more_players = true;
    while (p.more_players) { // more players
        n = recv_complete(sockfd, &p, sizeof(p), 0);
        if (n < 0) 
             error("ERROR reading from socket");
        printf("Player: %s\n\tteam: %d\n\trole: %d\n\tready: %s\n",p.name, p.team, p.role, (p.ready ? "yes" : "no"));
    }
    close(sockfd);
    return 0;
}