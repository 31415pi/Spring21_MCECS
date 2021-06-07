/*
 * PJ Waskiewicz
 * 6/28/2011
 * ECE 373
 *
 * Example 4: Hook up the char driver!
 */

#include <linux/module.h>
#include <linux/types.h>
#include <linux/kdev_t.h>
#include <linux/fs.h>
#include <linux/cdev.h>
#include <asm/uaccess.h>

#define DEVCNT 5
#define DEVNAME "example4"

static struct mydev_dev {
	struct cdev cdev;
	dev_t mydev_node;
	/* more stuff will go in here later... */
} mydev;

static int example4_open(struct inode *inode, struct file *file)
{
	printk(KERN_INFO "pop goes the open example!\n");

	return 0;
}

static ssize_t example4_read(struct file *file, char __user *user_buf,
			     size_t size, loff_t *offset)
{
	char *buf = "booga\n";
	int buflen = sizeof(buf) - 1; /* -1 to remove the null terminator */
	ssize_t len;

	if (*offset >= buflen)
		return 0;

	len = min_t(ssize_t, size, buflen);
	copy_to_user(&user_buf[*offset], buf, len);
	*offset += len;

	return len;
}

/* File operations for our device */
static struct file_operations mydev_fops = {
	.owner = THIS_MODULE,
	.read = example4_read,
	.open = example4_open,
};

static int __init example4_init(void)
{
	int ret;

	printk(KERN_INFO "example4 module loading...\n");

	ret = alloc_chrdev_region(&mydev.mydev_node, 0, DEVCNT, DEVNAME);
	if (ret) {
		printk(KERN_ERR "alloc_chrdev_region() failed! ret=%d\n", ret);
		goto chrdev_err;
	}

	printk(KERN_INFO "Allocated %d devices at major: %d\n", DEVCNT,
	       MAJOR(mydev.mydev_node));

	/* Initialize the character device and add it to the kernel */
	cdev_init(&mydev.cdev, &mydev_fops);
	mydev.cdev.owner = THIS_MODULE;

	ret = cdev_add(&mydev.cdev, mydev.mydev_node, DEVCNT);
	if (ret) {
		printk(KERN_ERR "cdev_add() failed! ret=%d\n", ret);
		goto cdev_err;
	}

	return ret;

cdev_err:
	/* clean up chrdev allocation */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);
chrdev_err:
	return ret;
}

static void __exit example4_exit(void)
{
	/* destroy the cdev */
	cdev_del(&mydev.cdev);

	/* clean up the devices */
	unregister_chrdev_region(mydev.mydev_node, DEVCNT);

	printk(KERN_INFO "example4 module unloaded!\n");
}

MODULE_AUTHOR("PJ Waskiewicz");
MODULE_LICENSE("GPL");
MODULE_VERSION("0.2");
module_init(example4_init);
module_exit(example4_exit);
