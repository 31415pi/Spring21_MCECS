#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int main()
{
	int fd;
	ssize_t num_read, num_written;
	char my_read_str[10];
	const char my_write_str[27] = "this is a nifty system call";

	fd = open("/dev/example5_0", O_RDWR);

	num_read = read(fd, &my_read_str, 10);
	printf("returned %s from the system call, num bytes read: %d\n",
	       my_read_str, num_read);

	num_written = write(fd, my_write_str, sizeof(my_write_str));
	printf("successfully wrote %d bytes to the kernel\n", num_written);

	close(fd);

	return 0;
}
