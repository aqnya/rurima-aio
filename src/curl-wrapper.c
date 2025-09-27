#include <unistd.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
int main(int argc, char **argv)
{
	char *command[argc + 11];
	char *path = (char *)malloc(4096);
	path[0] = '\0';
	realpath("/proc/self/exe", path);
	for (size_t i = strlen(path) - 1; i >= 0; i--) {
		if (path[i] == '/') {
			path[i] = '\0';
			break;
		}
	}
	char curl[4096] = { '\0' };
	sprintf(curl, "%s/curl-static", path);
	command[0] = curl;
	command[1] = "--dns-servers";
	command[2] = "1.1.1.1,8.8.8.8";
	command[3] = "--capath";
    char cert_path[4096];
    sprintf(cert_path, "%s/certs", path);
	command[4] = cert_path;
	char ca_path[4096];
	sprintf(ca_path, "%s/certs/ca-certificates.crt", path);
	command[5] = "--cacert";
	command[6] = ca_path;
	for (int i = 1; i < argc; i++) {
		command[i + 6] = argv[i];
	}
	command[argc + 6] = NULL;
	free(path);
	execv(command[0], command);
    perror("execv");
    return 1;
}