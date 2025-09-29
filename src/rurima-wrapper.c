// SPDX-License-Identifier: MIT
// Copyright (c) 2025 Moe-hacker
// This file is a part of rurima-aio project.
/*
 * This is a wrapper for rurima to set up the environment.
 * It prepends the directory of this binary to PATH,
 * and just simply execs rurima-static with the same arguments.
 * It also checks if the dependent binaries exist in the same directory.
 * If any of them is missing, it prints an error message and exits.
 * This binary is intended to be statically linked.
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <string.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
void init(void)
{
	/*
	 * Check if the dependent binaries exist in the same directory.
	 * If any of them is missing, print an error message and exit.
	 * The dependent binaries are:
	 * - rurima-static
	 * - file
	 * - tar
	 * - xz
	 * - sha256sum
	 * - gzip
	 * - curl
	 * - proot
	 * - newuidmap
	 * - newgidmap
	 * And prepend the directory of this binary to PATH.
	 */
	// Get the directory of this binary.
	char *self_path = realpath("/proc/self/exe", NULL);
	if (!self_path) {
		perror("realpath");
		fprintf(stderr, "Error: cannot resolve /proc/self/exe\n");
		fprintf(stderr, "Make sure your /proc is mounted properly.\n");
		exit(1);
	}
	for (int i = strlen(self_path) - 1; i >= 0; --i) {
		if (self_path[i] == '/') {
			self_path[i + 1] = 0;
			break;
		}
	}
	char binary_path[PATH_MAX];
	// Check rurima-static.
	sprintf(binary_path, "%srurima-static", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the static binary at %s\n", binary_path);
		exit(1);
	}
	// Check file.
	sprintf(binary_path, "%sfile", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the file at %s\n", binary_path);
		exit(1);
	}
	// Check tar.
	sprintf(binary_path, "%star", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the tar at %s\n", binary_path);
		exit(1);
	}
	// Check xz.
	sprintf(binary_path, "%sxz", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the xz at %s\n", binary_path);
		exit(1);
	}
	// Check sha256sum.
	sprintf(binary_path, "%ssha256sum", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the sha256sum at %s\n", binary_path);
		exit(1);
	}
	// Check gzip.
	sprintf(binary_path, "%sgzip", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the gzip at %s\n", binary_path);
		exit(1);
	}
	// Check curl.
	sprintf(binary_path, "%scurl", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the curl at %s\n", binary_path);
		exit(1);
	}
	// Check proot.
	sprintf(binary_path, "%sproot", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the proot at %s\n", binary_path);
		exit(1);
	}
	// Check newuidmap.
	sprintf(binary_path, "%snewuidmap", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the newuidmap at %s\n", binary_path);
		exit(1);
	}
	// Check newgidmap.
	sprintf(binary_path, "%snewgidmap", self_path);
	if (access(binary_path, X_OK) != 0) {
		fprintf(stderr, "Error: cannot access the newgidmap at %s\n", binary_path);
		exit(1);
	}
	// Prepend self_path to PATH.
	char *old_path = getenv("PATH");
	if (!old_path) {
		// Set PATH to self_path.
		if (setenv("PATH", self_path, 1) != 0) {
			perror("setenv");
			exit(1);
		}
	} else {
		// Prepend self_path to PATH.
		char new_path[PATH_MAX];
		snprintf(new_path, PATH_MAX, "%s:%s", self_path, old_path);
		if (setenv("PATH", new_path, 1) != 0) {
			perror("setenv");
			exit(1);
		}
	}
	free(self_path);
	return;
}
int main(int argc, char **argv)
{
	// Initialize the environment.
	init();
	// Fork and exec rurima-static.
	pid_t pid = fork();
	if (pid < 0) {
		perror("fork");
		exit(1);
	}
	if (pid == 0) {
		// Child process.
		execvp("rurima-static", argv);
		// If execvp returns, there was an error.
		fprintf(stderr, "Error: execvp failed: %s\n", strerror(errno));
		exit(1);
	}
	// Parent process.
	int status;
	if (waitpid(pid, &status, 0) < 0) {
		perror("waitpid");
		exit(1);
	}
	if (WIFEXITED(status)) {
		return WEXITSTATUS(status);
	}
	if (WIFSIGNALED(status)) {
		fprintf(stderr, "Error: child process terminated by signal %d\n", WTERMSIG(status));
		return 1;
	}
	return 0;
}